import 'package:eshara/Core/Helper/helper.dart';
import 'package:flutter/material.dart';

Widget headerAppBarAndBackgroundAuth(
  BuildContext context, {
  required Widget child,
}) {
  final theme = Theme.of(context);

  return Stack(
    children: [
      Container(
        color: theme.colorScheme.secondary,
        width: double.infinity,
        height: double.infinity,
      ),

      Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: Image.asset(
                  'assets/logo/Frame 17.png',
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(20),
                ),
              ),

              padding: EdgeInsets.only(top: 15),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: EdgeInsets.only(top: 15),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Helper.getResponsiveWidth(context, width: 16),
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onPrimary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  // this is my widget in auth pages
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(20),
                    ),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      Positioned(
        top: 0,
        left: 10,
        child: SafeArea(
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_forward, color: Colors.white),
          ),
        ),
      ),
    ],
  );
}
