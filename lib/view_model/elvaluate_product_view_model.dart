import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ElvaluateProductViewModel extends GetxController{


  Future<void> addOrderToFirestore({
    required String userId,
    required String idProduct,
    required String nameProduct,
    required String comment,
    required String nameUser,
    required double? total,
    required double? evalua,
  }) async {
    try {
      // Lấy tham chiếu đến collection 'orders'
      final ordersCollection = FirebaseFirestore.instance.collection('evaluations');

      // Tạo orderId bằng timestamp
      final orderId = DateTime.now().millisecondsSinceEpoch.toString();

      // Dữ liệu đơn hàng với orderId
      final orderData = {
        "userId": userId,
        "purchaseDate": DateTime.now().toIso8601String(),
        "total": total,
        "evalua": evalua,
        "idProduct": idProduct,
        "nameProduct": nameProduct,
        "comment": comment,
        "nameUser": nameUser,
      };

      // Lưu dữ liệu với orderId là ID của tài liệu
      await ordersCollection.doc(orderId).set(orderData);

      print('Evalua with ID $orderId added successfully!');
    } catch (e) {
      print('Error adding order: $e');
    }
  }

  Future<double> getAverageEvaluationByProduct(String productId) async {
    try {
      // Lấy tham chiếu đến collection 'evaluations'
      final evaluationsCollection = FirebaseFirestore.instance.collection('evaluations');

      // Lọc các đánh giá liên quan đến productId
      final querySnapshot = await evaluationsCollection.where('idProduct', isEqualTo: productId).get();

      // Kiểm tra nếu có dữ liệu
      if (querySnapshot.docs.isEmpty) {
        print('No evaluations found for product $productId.');
        return 0.0; // Trả về 0 nếu không có đánh giá cho sản phẩm
      }

      // Tính tổng điểm đánh giá và số lượng đánh giá
      double totalEvalua = 0.0;
      int count = 0;

      for (var doc in querySnapshot.docs) {
        // Lấy giá trị evalua từ mỗi đánh giá
        double evalua = doc['evalua'] ?? 0.0; // Nếu không có evalua, mặc định là 0.0
        totalEvalua += evalua;
        count++;
      }

      // Tính trung bình
      double averageEvalua = totalEvalua / count;

      print('Average evaluation for product $productId: $averageEvalua');
      return averageEvalua;
    } catch (e) {
      print('Error getting evaluations for product $productId: $e');
      return 0.0; // Trả về 0 nếu có lỗi
    }
  }

  Future<List<Map<String, String>>> getEvaluationsByProduct(String productId) async {
    try {
      // Lấy tham chiếu đến collection 'evaluations'
      final evaluationsCollection = FirebaseFirestore.instance.collection('evaluations');

      // Lọc các đánh giá liên quan đến productId
      final querySnapshot = await evaluationsCollection.where('idProduct', isEqualTo: productId).get();

      // Kiểm tra nếu có dữ liệu
      if (querySnapshot.docs.isEmpty) {
        print('No evaluations found for product $productId.');
        return []; // Trả về danh sách trống nếu không có đánh giá
      }

      // Danh sách để lưu tên và bình luận
      List<Map<String, String>> evaluations = [];

      for (var doc in querySnapshot.docs) {
        // Lấy tên sản phẩm và bình luận từ mỗi đánh giá
        String nameUser = doc['nameUser'] ?? 'Unknown Product';
        String comment = doc['comment'] ?? 'No comment';

        // Thêm tên sản phẩm và bình luận vào danh sách
        evaluations.add({
          'nameUser': nameUser,
          'comment': comment,
        });
      }

      print('Evaluations for product $productId: $evaluations');
      return evaluations;
    } catch (e) {
      print('Error getting evaluations for product $productId: $e');
      return []; // Trả về danh sách trống nếu có lỗi
    }
  }


}