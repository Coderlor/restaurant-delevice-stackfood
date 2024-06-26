import 'package:efood_multivendor_restaurant/helper/price_converter.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletWidget extends StatelessWidget {
  final String title;
  final double? value;
  final bool isAmountAndTextInRow;
  const WalletWidget({Key? key, required this.title, required this.value, this.isAmountAndTextInRow = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge, horizontal: isAmountAndTextInRow ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300]!, spreadRadius: 0.5, blurRadius: 5)],
      ),
      alignment: Alignment.center,
      child: isAmountAndTextInRow ? Row(children: [
        Text(
          PriceConverter.convertPrice(value), textDirection: TextDirection.ltr,
          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
        ),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        Text(
          title, textAlign: TextAlign.center,
          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
        ),

      ]) : Column(children: [

        Text(
          PriceConverter.convertPrice(value), textDirection: TextDirection.ltr,
          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Text(
          title, textAlign: TextAlign.center,
          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
        ),

      ]),
    );
  }
}
