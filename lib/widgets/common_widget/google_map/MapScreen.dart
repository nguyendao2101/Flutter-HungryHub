// ignore_for_file: unused_local_variable, library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import '../../../model/map/open_route_service.dart';

class RouteScreen extends StatefulWidget {
  const RouteScreen({super.key});

  @override
  _RouteScreenState createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  String routeInfo = "Nhập vị trí và nhấn nút để tính quãng đường.";
  final OpenRouteService routeService = OpenRouteService();

  Future<void> getRoute() async {
    try {
      final data = await routeService.getRoute(
        10.8231, 106.6297, // Tọa độ Hồ Chí Minh
        21.0285, 105.8542, // Tọa độ Hà Nội
      );

      final route = data['routes'][0];
      final distance = route['summary']['distance']; // mét
      final duration = route['summary']['duration']; // giây
      final steps = route['segments'][0]['steps'];

      final instructions = steps.map((step) {
        return '${step['instruction']} '
            '(${(step['distance'] / 1000).toStringAsFixed(2)} km)';
      }).join('\n');

      setState(() {
        routeInfo = 'Quãng đường: ${(distance / 1000).toStringAsFixed(2)} km\n'
            'Thời gian: ${(duration / 3600).toStringAsFixed(2)} giờ\n\n';
        // 'Hướng dẫn:\n$instructions';
      });
    } catch (e) {
      setState(() {
        routeInfo = 'Có lỗi xảy ra: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tính Quãng Đường'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              routeInfo,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: getRoute,
              child: const Text('Tính Quãng Đường'),
            ),
          ],
        ),
      ),
    );
  }
}
