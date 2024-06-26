import 'package:efood_multivendor_restaurant/data/api/api_client.dart';
import 'package:efood_multivendor_restaurant/data/model/response/product_model.dart';
import 'package:efood_multivendor_restaurant/util/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class AddonRepo {
  final ApiClient apiClient;
  AddonRepo({required this.apiClient});

  Future<Response> getAddonList() {
    return apiClient.getData(AppConstants.addonUri);
  }

  Future<Response> addAddon(AddOns addonModel) {
    return apiClient.postData(AppConstants.addAddonUri, addonModel.toJson());
  }

  Future<Response> updateAddon(AddOns addonModel) {
    return apiClient.putData(AppConstants.updateAddonUri, addonModel.toJson());
  }

  Future<Response> deleteAddon(int? addonID) {
    return apiClient.postData('${AppConstants.deleteAddonUri}?id=$addonID', {"_method": "delete"});
  }

}