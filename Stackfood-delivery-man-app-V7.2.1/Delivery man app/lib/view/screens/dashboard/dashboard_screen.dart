import 'dart:async';

import 'package:efood_multivendor_driver/controller/auth_controller.dart';
import 'package:efood_multivendor_driver/controller/disbursement_controller.dart';
import 'package:efood_multivendor_driver/controller/order_controller.dart';
import 'package:efood_multivendor_driver/helper/custom_print.dart';
import 'package:efood_multivendor_driver/helper/notification_helper.dart';
import 'package:efood_multivendor_driver/helper/route_helper.dart';
import 'package:efood_multivendor_driver/main.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/view/base/custom_alert_dialog.dart';
import 'package:efood_multivendor_driver/view/screens/dashboard/widget/bottom_nav_item.dart';
import 'package:efood_multivendor_driver/view/screens/dashboard/widget/new_request_dialog.dart';
import 'package:efood_multivendor_driver/view/screens/home/home_screen.dart';
import 'package:efood_multivendor_driver/view/screens/profile/profile_screen.dart';
import 'package:efood_multivendor_driver/view/screens/request/order_request_screen.dart';
import 'package:efood_multivendor_driver/view/screens/order/order_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  const DashboardScreen({Key? key, required this.pageIndex}) : super(key: key);

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  PageController? _pageController;
  int _pageIndex = 0;
  late List<Widget> _screens;
  final _channel = const MethodChannel('com.sixamtech/app_retain');
  late StreamSubscription _stream;
  //Timer _timer;
  //int _orderCount;

  @override
  void initState() {
    super.initState();

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      const HomeScreen(),
      OrderRequestScreen(onTap: () => _setPage(0)),
      const OrderScreen(),
      const ProfileScreen(),
    ];

    showDisbursementWarningMessage();

    customPrint('dashboard call');
     _stream = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
       customPrint("dashboard onMessage: ${message.data}/ ${message.data['type']}");
      String? type = message.notification!.bodyLocKey;
      String? orderID = message.notification!.titleLocKey;
      if(type != 'assign' && type != 'new_order' && type != 'message' && type != 'order_request'&& type != 'order_status') {
        NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin);
      }
      if(type == 'new_order' || type == 'order_request') {
        Get.find<OrderController>().getCurrentOrders();
        Get.find<OrderController>().getLatestOrders();
        Get.dialog(NewRequestDialog(isRequest: true, onTap: () => _navigateRequestPage(), orderId: int.parse(orderID!)));
      }else if(type == 'assign' && orderID != null && orderID.isNotEmpty) {
        Get.find<OrderController>().getCurrentOrders();
        Get.find<OrderController>().getLatestOrders();
        Get.dialog(NewRequestDialog(isRequest: false, onTap: () => Get.toNamed(RouteHelper.getOrderDetailsRoute(int.parse(orderID))), orderId: int.parse(orderID)));
      }else if(type == 'block') {
        Get.find<AuthController>().clearSharedData();
        Get.find<AuthController>().stopLocationRecord();
        Get.offAllNamed(RouteHelper.getSignInRoute());
      }
    });

    // _timer = Timer.periodic(Duration(seconds: 30), (timer) async {
    //   await Get.find<OrderController>().getLatestOrders();
    //   int _count = Get.find<OrderController>().latestOrderList.length;
    //   if(_orderCount != null && _orderCount < _count) {
    //     Get.dialog(NewRequestDialog(isRequest: true, onTap: () => _navigateRequestPage()));
    //   }else {
    //     _orderCount = Get.find<OrderController>().latestOrderList.length;
    //   }
    // });

  }

  showDisbursementWarningMessage() async{
    Get.find<DisbursementController>().enableDisbursementWarningMessage(true);
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _timer?.cancel();
  // }

  void _navigateRequestPage() {
    if(Get.find<AuthController>().profileModel != null && Get.find<AuthController>().profileModel!.active == 1
        && Get.find<OrderController>().currentOrderList != null && Get.find<OrderController>().currentOrderList!.isEmpty) {
      _setPage(1);
    }else {
      if(Get.find<AuthController>().profileModel == null || Get.find<AuthController>().profileModel!.active == 0) {
        Get.dialog(CustomAlertDialog(description: 'you_are_offline_now'.tr, onOkPressed: () => Get.back()));
      }else {
        //Get.dialog(CustomAlertDialog(description: 'you_have_running_order'.tr, onOkPressed: () => Get.back()));
        _setPage(1);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();

    _stream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(_pageIndex != 0) {
          _setPage(0);
          return false;
        }else {
          if (GetPlatform.isAndroid && Get.find<AuthController>().profileModel!.active == 1) {
            _channel.invokeMethod('sendToBackground');
            return false;
          } else {
            return true;
          }
        }
      },
      child: Scaffold(
        bottomNavigationBar: GetPlatform.isDesktop ? const SizedBox() : BottomAppBar(
          elevation: 5,
          notchMargin: 5,
          shape: const CircularNotchedRectangle(),

          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            child: Row(children: [
              BottomNavItem(iconData: Icons.home, isSelected: _pageIndex == 0, onTap: () => _setPage(0)),
              BottomNavItem(iconData: Icons.list_alt_rounded, isSelected: _pageIndex == 1, onTap: () {
                _navigateRequestPage();
              }),
              BottomNavItem(iconData: Icons.shopping_bag, isSelected: _pageIndex == 2, onTap: () => _setPage(2)),
              BottomNavItem(iconData: Icons.person, isSelected: _pageIndex == 3, onTap: () => _setPage(3)),
            ]),
          ),
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens[index];
          },
        ),
      ),
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController!.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }
}
