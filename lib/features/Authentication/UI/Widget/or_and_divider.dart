import 'package:flutter/material.dart';

Widget orDividir() {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        Expanded(child: Divider(indent: 30, color: Color(0xFFD9D9D9))),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text("OR"),
        ),
        Expanded(child: Divider(endIndent: 30, color: Color(0xFFD9D9D9))),
      ],
    ),
  );
}
