import 'package:efood_multivendor_restaurant/data/api/api_client.dart';
import 'package:efood_multivendor_restaurant/data/model/body/update_status_body.dart';
import 'package:efood_multivendor_restaurant/util/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRepo extends GetxService {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  OrderRepo({required this.apiClient, required this.sharedPreferences});

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  Future<Response> getAllOrders() {
    return apiClient.getData(AppConstants.allOrdersUri);
  }

  Future<Response> getCurrentOrders() {
    return apiClient.getData(AppConstants.currentOrdersUri);
  }

  Future<Response> getCompletedOrders() {
    return apiClient.getData(AppConstants.completedOrdersUri);
  }

  Future<Response> getPaginatedOrderList(int offset, String status) async {
    return await apiClient.getData('${AppConstants.completedOrdersUri}?status=$status&offset=$offset&limit=10');
  }

  Future<Response> updateOrderStatus(UpdateStatusBody updateStatusBody, List<MultipartBody> proofAttachment) {
    return apiClient.postMultipartData(AppConstants.updateOrderStatusUri, updateStatusBody.toJson(), proofAttachment, []);
  }

  Future<Response> getOrderDetails(int? orderID) {
    return apiClient.getData('${AppConstants.orderDetailsUri}$orderID');
  }

  Future<Response> getOrderWithId(int? orderId) {
    return apiClient.getData('${AppConstants.currentOrderDetailsUri}$orderId');
  }

  Future<Response> getCancelReasons() async {
    return await apiClient.getData('${AppConstants.orderCancellationUri}?offset=1&limit=30&type=restaurant');
  }

  Future<Response> sendDeliveredNotification(int? orderID) {
    return apiClient.postData(AppConstants.deliveredOrderNotificationUri, {"_method": "put", 'token': getUserToken(), 'order_id': orderID});
  }

  Future<Response> getDeliveryManList() async {
    return await apiClient.getData(AppConstants.deliverymanListUri);
  }

  Future<Response> assignDeliveryMan(int? deliveryManId, int? orderId) async {
    return await apiClient.getData('${AppConstants.assignDeliverymanUri}?delivery_man_id=$deliveryManId&order_id=$orderId');
  }


}