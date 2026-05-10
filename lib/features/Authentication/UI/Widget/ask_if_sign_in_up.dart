// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class AskIfSignInUp extends StatelessWidget {
  final Function() ontap;
  final String textTap;
  final String text;
  const AskIfSignInUp({
    super.key,
    required this.ontap,
    required this.text,
    required this.textTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text),
        GestureDetector(
          onTap:  ontap,
          child: Text(textTap, style: theme.textTheme.bodySmall),
        ),
      ],
    );
  }
}
