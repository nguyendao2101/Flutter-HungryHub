import 'package:flutter/material.dart';
import 'package:flutter_hungry_hub/view/main_nav_view.dart';
import 'package:flutter_hungry_hub/view/orders_view.dart';
import 'package:flutter_hungry_hub/view/register_shop_view.dart';
import 'package:flutter_hungry_hub/view_model/profile_view_model.dart';
import 'package:flutter_hungry_hub/widgets/common_widget/profile/addresses.dart';
import 'package:flutter_hungry_hub/widgets/common_widget/profile/favourite.dart';
import 'package:flutter_hungry_hub/widgets/common_widget/profile/notification.dart';
import 'package:flutter_hungry_hub/widgets/common_widget/profile/order_tracking.dart';
import 'package:flutter_hungry_hub/widgets/common_widget/profile/payment_method.dart';
import 'package:flutter_hungry_hub/widgets/common_widget/profile/persionnal_info.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../widgets/common/image_extention.dart';
import '../widgets/common_widget/profile/function_profile.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final controller = Get.put(ProfileViewModel());
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Profile', style: TextStyle(
                fontSize: 24,
                color: Color(0xff303030),
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
              ),)
            ],
          )),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  const SizedBox(height: 30,),
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade300,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        ImageAsset.users,
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 8),
                    child: Text(controller.userData['fullName']?.toString() ?? 'User', style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xff111A2C),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),),
                  ),
                  const Text('Explore the food', style: TextStyle(
                    fontSize: 12,
                    color: Color(0xff111A2C),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                  ),),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                    child: Container(
                      height: 170,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0xffF0F0F0).withOpacity(0.6)
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 24, bottom: 15, left: 16, right: 20),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Get.to(()=> const PersonalInfo());
                                },
                                  child: FunctionProfile(image: ImageAsset.personalInfo, title: 'Personal Info',)),
                              const SizedBox(height: 8,),
                              GestureDetector(
                                onTap: (){
                                  Get.to(()=> const Addresses());
                                },
                                  child: FunctionProfile(image: ImageAsset.GPS, title: 'Addresses',)),
                              const SizedBox(height: 8,),
                              GestureDetector(
                                  onTap: (){
                                    Get.to(()=> const OrderTracking());
                                  },
                                  child: FunctionProfile(image: ImageAsset.GPS, title: 'Order tracking',)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                    child: Container(
                      height: 214,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0xffF0F0F0).withOpacity(0.6)
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 24, bottom: 15, left: 16, right: 20),
                          child: Column(
                            children: [
                              GestureDetector(
                                  onTap: (){
                                    print('da nhan');
                                    Get.to(()=> const OrdersView());
                                  },
                                  child: FunctionProfile(image: ImageAsset.cartPlus, title: 'Cart',)),
                              const SizedBox(height: 8,),
                              GestureDetector(
                                  onTap: (){
                                      Get.to(()=> const Favourite());
                                  },
                                  child: FunctionProfile(image: ImageAsset.favourist, title: 'Favourite',)),
                              const SizedBox(height: 8,),
                              GestureDetector(
                                  onTap: (){
                                    Get.to(()=>  const NotificationPro());
                                  },
                                  child: FunctionProfile(image: ImageAsset.notification, title: 'Notification',)),
                              const SizedBox(height: 8,),
                              GestureDetector(
                                  onTap: (){
                                    Get.to(()=> const PaymentMethod());
                                  },
                                  child: FunctionProfile(image: ImageAsset.wallet, title: 'Payment Method',)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      controller.onLogout();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                      child: Container(
                        height: 70,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: const Color(0xffF0F0F0).withOpacity(0.6)
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 18, bottom: 15, left: 16, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        height: 36,
                                        width: 36,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape
                                              .circle, // Đặt hình dạng của container là hình tròn
                                          color: Color(0xffFFFFFF),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                            ImageAsset.logOut,
                                          ),
                                        )),
                                    const SizedBox(width: 20,),
                                    const Text('Log Out', style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xff111A2C),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Poppins',
                                    ),),
                                  ],
                                ),
                                SvgPicture.asset(ImageAsset.arrowRight),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                // Get.to(()=> const RegisterShopView());
                showTermsDialog(context);
                
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffEF5350), // Màu nền nút
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Bo góc nút
                ),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15), // Padding cho nút
                elevation: 5, // Độ bóng của nút
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min, // Đảm bảo chiều rộng của Row là nhỏ nhất
                children: [
                  Text(
                    'Shop',
                    style: TextStyle(
                      color: Colors.white, // Màu chữ
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 10), // Khoảng cách giữa chữ và icon
                  Icon(
                    Icons.shop,
                    color: Colors.white, // Màu icon
                  ),
                ],
              ),
            ),
          )

        ],
      ),
    );
  }

  void showTermsDialog(BuildContext context) {
    bool isChecked = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Điều Khoản Chuyển Tài Khoản',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chúng tôi tại HungryHub cam kết mang đến trải nghiệm mua sắm và bán hàng tốt nhất cho tất cả người dùng. '
                      'Nếu bạn là người dùng và mong muốn chuyển tài khoản cá nhân của mình lên thành tài khoản Shop để có thể bán các sản phẩm liên quan đến món gà tại HungryHub, xin vui lòng đọc kỹ các điều khoản dưới đây:\n\n'
                      '1. Điều kiện chuyển đổi tài khoản\n'
                      'Tài khoản User: Chỉ những tài khoản có trạng thái là "User" mới có thể chuyển đổi lên tài khoản Shop.\n'
                      'Thông tin xác thực: Bạn cần cung cấp đầy đủ thông tin về cửa hàng của mình, bao gồm nhưng không giới hạn ở tên cửa hàng, địa chỉ, và thông tin liên hệ.\n'
                      'Xác nhận chủ sở hữu: Bạn phải chứng minh rằng bạn là chủ sở hữu của cửa hàng muốn đăng ký bán sản phẩm trên HungryHub. Điều này có thể bao gồm việc cung cấp giấy tờ kinh doanh hợp lệ hoặc thông tin xác nhận quyền sở hữu.\n\n'
            
                      '2. Lợi ích khi chuyển tài khoản lên Shop\n'
                      'Bán hàng trực tuyến: Sau khi chuyển đổi, bạn sẽ có quyền đăng bán các sản phẩm gà và các món ăn khác trên nền tảng của HungryHub.\n'
                      'Quản lý đơn hàng: Bạn có thể dễ dàng quản lý các đơn hàng từ khách hàng, theo dõi tình trạng và xác nhận đơn hàng ngay trên ứng dụng.\n'
                      'Khả năng tiếp cận khách hàng mới: Với tài khoản Shop, bạn sẽ tiếp cận được nhiều khách hàng hơn từ nền tảng HungryHub.\n\n'
            
                      '3. Quy trình chuyển đổi tài khoản\n'
                      'Bước 1: Đăng nhập vào tài khoản hiện tại của bạn và truy cập vào phần "Chuyển đổi Tài Khoản" trong cài đặt tài khoản.\n'
                      'Bước 2: Cung cấp thông tin cửa hàng của bạn và các giấy tờ liên quan (nếu có).\n'
                      'Bước 3: Đợi phê duyệt từ đội ngũ quản lý của HungryHub. Sau khi phê duyệt, tài khoản của bạn sẽ được chuyển thành tài khoản Shop.\n'
                      'Bước 4: Sau khi chuyển đổi thành công, bạn sẽ có quyền đăng bán sản phẩm và bắt đầu hoạt động kinh doanh trên HungryHub.\n\n'
            
                      '4. Điều khoản và nghĩa vụ của Shop\n'
                      'Quản lý chất lượng sản phẩm: Bạn chịu trách nhiệm về chất lượng và nguồn gốc sản phẩm mà bạn bán trên HungryHub. Các sản phẩm phải tuân thủ các quy định về vệ sinh an toàn thực phẩm và pháp lý.\n'
                      'Chính sách bảo mật và thanh toán: Bạn cam kết tuân thủ các quy định về bảo mật thông tin khách hàng và quy trình thanh toán của HungryHub.\n'
                      'Đảm bảo dịch vụ khách hàng: Bạn cần đáp ứng các yêu cầu hỗ trợ khách hàng liên quan đến sản phẩm, giao hàng và các vấn đề phát sinh từ đơn hàng.\n\n'
            
                      '5. Chính sách hủy bỏ hoặc thay đổi tài khoản Shop\n'
                      'Bạn có quyền yêu cầu hủy bỏ hoặc thay đổi trạng thái tài khoản Shop về tài khoản User bất cứ lúc nào, nhưng bạn cần hoàn thành tất cả các đơn hàng hiện tại và cam kết không vi phạm các điều khoản của HungryHub.\n'
                      'HungryHub có quyền đình chỉ hoặc chấm dứt tài khoản Shop nếu có vi phạm các chính sách của nền tảng.\n\n'
            
                      '6. Liên hệ hỗ trợ\n'
                      'Nếu bạn có bất kỳ câu hỏi nào hoặc cần sự hỗ trợ trong quá trình chuyển tài khoản, vui lòng liên hệ với đội ngũ hỗ trợ của HungryHub qua email: support@hungryhub.com hoặc số điện thoại: 123-456-789.\n',
            
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (value) {
                        // Cập nhật trạng thái checkbox khi người dùng tick/uncheck
                        isChecked = value!;
                        (context as Element).markNeedsBuild();
                      },
                    ),
                    Text(
                      'Tôi đồng ý với các điều khoản trên',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog khi ấn "Hủy"
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isChecked
                  ? () {
                controller.transferUserDataToBrowseShop();
                // Thực hiện hành động xác nhận khi checkbox được chọn
                Navigator.of(context).pop(); // Đóng dialog
                // Thực hiện chuyển tài khoản hoặc hành động cần thiết tại đây
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(content: Text('The account has been transferred to the admin department!')),
                // );
                Get.to(() => const RegisterShopView());
              }
                  : null, // Vô hiệu hóa nút nếu chưa đồng ý
              style: ElevatedButton.styleFrom(
                backgroundColor: isChecked ? Colors.red : Colors.grey, // Màu nút thay đổi tùy theo trạng thái checkbox
                disabledForegroundColor: Colors.grey.withOpacity(0.38), disabledBackgroundColor: Colors.grey.withOpacity(0.12), // Màu khi nút bị vô hiệu hóa
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Bo tròn góc nút
                ),
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24), // Thêm padding cho nút
              ),
              child: Text(
                'Confirm',
                style: TextStyle(
                  color: isChecked ? Colors.white : Colors.black54, // Đổi màu chữ dựa vào trạng thái checkbox
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

}
