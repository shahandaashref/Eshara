import 'package:eshara/Core/Helper/theme.dart';
import 'package:flutter/material.dart';

class AddWordSuccessPage extends StatelessWidget {
  const AddWordSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: EsharaTheme.background,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 84,
                color: EsharaTheme.success,
              ),
              const SizedBox(height: 24),
              Text(
                'تم إرسال الطلب بنجاح',
                style: tt.headlineLarge!.copyWith(
                  color: EsharaTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'سيتم مراجعة الكلمة من قبل الأدمن، وفي حال الموافقة ستظهر في القاموس.',
                style: tt.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                ),
                child: const Text('العودة'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
