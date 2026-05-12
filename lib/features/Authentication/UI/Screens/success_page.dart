import 'package:eshara/Core/Helper/theme.dart';
import 'package:eshara/features/Authentication/UI/Widget/header_app_bar_and_backgroun_auth.dart';
import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: headerAppBarAndBackgroundAuth(
        context,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // الدائرة الزرقاء وعلامة الصح اللي في تصميمك
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: EsharaTheme.primaryBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 80, color: Colors.white),
              ),
              
              const SizedBox(height: 30),
              
              Text(
                "تم التحقق بنجاح!",
                style: Theme.of(context).textTheme.displayMedium,
              ),
              
              const SizedBox(height: 15),
              
              const Text(
                "لقد تم تأكيد حسابك بنجاح، يمكنك الآن\nالبدء في استكشاف تطبيق إشارة",
                textAlign: TextAlign.center,
                style: TextStyle(color: EsharaTheme.textSecondary),
              ),

              const SizedBox(height: 50),

              // زرار "ابدأ الآن"
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to Home or Dictionary
                  },
                  child: const Text("ابدأ الآن"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}