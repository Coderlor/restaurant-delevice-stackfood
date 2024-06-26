
import 'dart:convert';

import 'package:efood_multivendor_restaurant/controller/addon_controller.dart';
import 'package:efood_multivendor_restaurant/controller/auth_controller.dart';
import 'package:efood_multivendor_restaurant/controller/bank_controller.dart';
import 'package:efood_multivendor_restaurant/controller/campaign_controller.dart';
import 'package:efood_multivendor_restaurant/controller/chat_controller.dart';
import 'package:efood_multivendor_restaurant/controller/coupon_controller.dart';
import 'package:efood_multivendor_restaurant/controller/delivery_man_controller.dart';
import 'package:efood_multivendor_restaurant/controller/disbursement_controller.dart';
import 'package:efood_multivendor_restaurant/controller/expense_controller.dart';
import 'package:efood_multivendor_restaurant/controller/localization_controller.dart';
import 'package:efood_multivendor_restaurant/controller/notification_controller.dart';
import 'package:efood_multivendor_restaurant/controller/order_controller.dart';
import 'package:efood_multivendor_restaurant/controller/pos_controller.dart';
import 'package:efood_multivendor_restaurant/controller/report_controller.dart';
import 'package:efood_multivendor_restaurant/controller/restaurant_controller.dart';
import 'package:efood_multivendor_restaurant/controller/splash_controller.dart';
import 'package:efood_multivendor_restaurant/controller/theme_controller.dart';
import 'package:efood_multivendor_restaurant/data/model/response/bank_repo.dart';
import 'package:efood_multivendor_restaurant/data/repository/addon_repo.dart';
import 'package:efood_multivendor_restaurant/data/repository/auth_repo.dart';
import 'package:efood_multivendor_restaurant/data/repository/campaign_repo.dart';
import 'package:efood_multivendor_restaurant/data/repository/chat_repo.dart';
import 'package:efood_multivendor_restaurant/data/repository/coupon_repo.dart';
import 'package:efood_multivendor_restaurant/data/repository/delivery_man_repo.dart';
import 'package:efood_multivendor_restaurant/data/repository/disbursement_repo.dart';
import 'package:efood_multivendor_restaurant/data/repository/expense_repo.dart';
import 'package:efood_multivendor_restaurant/data/repository/language_repo.dart';
import 'package:efood_multivendor_restaurant/data/repository/notification_repo.dart';
import 'package:efood_multivendor_restaurant/data/repository/order_repo.dart';
import 'package:efood_multivendor_restaurant/data/repository/pos_repo.dart';
import 'package:efood_multivendor_restaurant/data/repository/report_repo.dart';
import 'package:efood_multivendor_restaurant/data/repository/restaurant_repo.dart';
import 'package:efood_multivendor_restaurant/data/repository/splash_repo.dart';
import 'package:efood_multivendor_restaurant/data/api/api_client.dart';
import 'package:efood_multivendor_restaurant/util/app_constants.dart';
import 'package:efood_multivendor_restaurant/data/model/response/language_model.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()));

  // Repository
  Get.lazyPut(() => SplashRepo(sharedPreferences: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => LanguageRepo());
  Get.lazyPut(() => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => NotificationRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => OrderRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => BankRepo(apiClient: Get.find()));
  Get.lazyPut(() => RestaurantRepo(apiClient: Get.find()));
  Get.lazyPut(() => CampaignRepo(apiClient: Get.find()));
  Get.lazyPut(() => AddonRepo(apiClient: Get.find()));
  Get.lazyPut(() => PosRepo(apiClient: Get.find()));
  Get.lazyPut(() => DeliveryManRepo(apiClient: Get.find()));
  Get.lazyPut(() => ChatRepo(apiClient: Get.find(),sharedPreferences: Get.find()));
  Get.lazyPut(() => CouponRepo(apiClient: Get.find()));
  Get.lazyPut(() => ExpenseRepo(apiClient: Get.find()));
  Get.lazyPut(() => ReportRepo(apiClient: Get.find()));
  Get.lazyPut(() => DisbursementRepo(apiClient: Get.find()));

  // Controller
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => SplashController(splashRepo: Get.find()));
  Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => NotificationController(notificationRepo: Get.find()));
  Get.lazyPut(() => OrderController(orderRepo: Get.find()));
  Get.lazyPut(() => BankController(bankRepo: Get.find()));
  Get.lazyPut(() => RestaurantController(restaurantRepo: Get.find()));
  Get.lazyPut(() => CampaignController(campaignRepo: Get.find()));
  Get.lazyPut(() => AddonController(addonRepo: Get.find()));
  Get.lazyPut(() => PosController(posRepo: Get.find()));
  Get.lazyPut(() => DeliveryManController(deliveryManRepo: Get.find()));
  Get.lazyPut(() => ChatController(chatRepo: Get.find()));
  Get.lazyPut(() => CouponController(couponRepo: Get.find()));
  Get.lazyPut(() => ExpenseController(expenseRepo: Get.find()));
  Get.lazyPut(() => ReportController(reportRepo: Get.find()));
  Get.lazyPut(() => DisbursementController(disbursementRepo: Get.find()));

  // Retrieving localized data
  Map<String, Map<String, String>> languages = {};
  for(LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues =  await rootBundle.loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = jsonDecode(jsonStringValues);
    Map<String, String> json = {};
    mappedJson.forEach((key, value) {
      json[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] = json;
  }
  return languages;
}
