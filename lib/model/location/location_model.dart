// ignore_for_file: deprecated_member_use, avoid_print

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  // Hàm lấy vị trí hiện tại và thông tin địa chỉ
  Future<String> getCurrentLocationAndAddress() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Kiểm tra xem dịch vụ vị trí có được bật hay không
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Kiểm tra quyền truy cập vị trí
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Nếu quyền bị từ chối, yêu cầu quyền
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }

    // Lấy vị trí hiện tại với độ chính xác cao
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // In ra vĩ độ và kinh độ
    print('Latitudeee: ${position.latitude}');
    print('Longitude: ${position.longitude}');
    // Lấy địa chỉ từ tọa độ
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks[0];

      // Lấy thông tin thành phố và quốc gia, nếu null thì sẽ dùng giá trị mặc định
      String city =
          placemark.administrativeArea ?? placemark.subLocality ?? "Hà Nội";
      String country = placemark.country ?? "Unknown Country";

      // Trả về thông tin địa chỉ và vị trí
      return 'District: ${placemark.subAdministrativeArea ?? "Unknown"}, City: $city, \nCountry: $country';
    } else {
      return 'No address found.';
    }
  }
}
