import 'package:flutter/material.dart';

class ChipWidget extends StatelessWidget {
  final String name;
  final String type;

  ChipWidget({required this.name, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 2.0, left: 2.0, top: 2.0),
      child: Chip(
        avatar: CircleAvatar(
          backgroundColor: Colors.grey.shade800,
          child: Icon(
            type == 'food' ? Icons.restaurant : Icons.coffee,
            size: 12,
          ),
        ),
        label: Text(name),
      ),
    );
  }
}
