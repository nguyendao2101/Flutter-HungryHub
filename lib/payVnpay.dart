import 'package:flutter/material.dart';
import 'package:flutter_hungry_hub/widgets/common/image_extention.dart';
import 'package:vnpay_flutter/vnpay_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Example(),
    );
  }
}

class Example extends StatefulWidget {
  const Example({Key? key}) : super(key: key);

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  String responseCode = '';

  // Hàm gọi payment với số tiền tùy ý
  Future<void> onPayment(double amount) async {
    final paymentUrl = VNPAYFlutter.instance.generatePaymentUrl(
      url: 'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html', //vnpay url, default is https://sandbox.vnpayment.vn/paymentv2/vpcpay.html
      version: '2.0.1',
      tmnCode: 'YLLVXBWY', //vnpay tmn code, get from vnpay
      txnRef: DateTime.now().millisecondsSinceEpoch.toString(),
      orderInfo: 'Pay $amount VND', //order info
      amount: amount, // Sử dụng amount từ tham số truyền vào
      returnUrl: 'https://sandbox.vnpayment.vn/merchant_webapi/api/transaction', //https://sandbox.vnpayment.vn/apis/docs/huong-dan-tich-hop/#code-returnurl
      ipAdress: '192.168.10.10',
      vnpayHashKey: '1J9MHQHA5NK9C4J3D26CZO1HAPO02IJY', //vnpay hash key, get from vnpay
      vnPayHashType: VNPayHashType.HMACSHA512, //hash type. Default is HMACSHA512, you can chang it in: https://sandbox.vnpayment.vn/merchantv2,
      vnpayExpireDate: DateTime.now().add(const Duration(hours: 1)),
    );
    await VNPAYFlutter.instance.show(
      paymentUrl: paymentUrl,
      onPaymentSuccess: (params) {
        setState(() {
          responseCode = params['vnp_ResponseCode'] ?? 'No Response Code';
        });
        // Print the response to the console
        print('Payment Success: $params');
      },
      onPaymentError: (params) {
        setState(() {
          responseCode = 'Error';
        });
        // Print the error to the console
        print('Payment Error: $params');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Response Code: $responseCode'),
            TextButton(
              onPressed: () {
                // Gọi hàm onPayment với số tiền cần thanh toán
                onPayment(50000);  // Ví dụ số tiền là 50,000 VND
              },
              child: const Text('Pay 50.000 VND'),
            ),
            TextButton(
              onPressed: () {
                // Gọi hàm onPayment với số tiền khác
                onPayment(100000);  // Ví dụ số tiền là 100,000 VND
              },
              child: const Text('Pay 100.000 VND'),
            ),
          ],
        ),
      ),
    );
  }

}
