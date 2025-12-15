import 'package:eshara/Core/Helper/helper.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  String type;
  final String label;
  final String hintText;
  final Widget icon;
  final String? Function(String?)? validateFunction;
  final TextEditingController? controller;

  CustomTextFormField({
    super.key,
    required this.type,
    required this.label,
    required this.hintText,
    required this.icon,
    this.controller,
    this.validateFunction,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool showpass = false;
  @override
  void initState() {
    showpass = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Helper.getResponsiveHeight(context, height: 20)),
          Text(widget.label, style: theme.textTheme.bodyMedium),
          SizedBox(height: Helper.getResponsiveHeight(context, height: 16)),
          TextFormField(
            validator: widget.validateFunction,
            obscureText: !showpass && widget.type == 'password',
            controller: widget.controller,
            keyboardType: widget.type == 'email'
                ? TextInputType.emailAddress
                : TextInputType.text,
            decoration: InputDecoration(
              suffixIcon: widget.type == 'password'
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          showpass = !showpass;
                        });
                      },
                      icon: Icon(
                        showpass == true
                            ? Icons.remove_red_eye
                            : Icons.visibility_off_outlined,
                      ),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  Helper.getResponsiveWidth(context, width: 20),
                ),
                gapPadding: 7,
              ),
              hintText: widget.hintText,
              prefixIcon: widget.icon,
            ),
          ),
        ],
      ),
    );
  }
}
