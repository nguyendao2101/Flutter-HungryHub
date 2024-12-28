import 'package:flutter/material.dart';

class RatingWidget extends StatefulWidget {
  final double initialRating; // Tham số để nhận giá trị sao mặc định

  RatingWidget({required this.initialRating}); // Constructor

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  late double _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating; // Gán giá trị sao mặc định từ widget
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(5, (index) {
        return Icon(
          index < _rating ? Icons.star : Icons.star_border,
          color: Colors.orange,
          size: 30,
        );
      }),
    );
  }
}
