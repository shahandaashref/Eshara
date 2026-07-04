import 'package:eshara/Core/di/dependency_injection.dart';
import 'package:eshara/Core/di/injection_container.dart';
import 'package:eshara/my_app.dart';
import 'package:flutter/material.dart';

void main() async {
  // تأكد من تهيئة Flutter Widgets قبل أي شيء آخر
  WidgetsFlutterBinding.ensureInitialized();

  // قم بتهيئة جميع الاعتماديات وانتظر حتى تكتمل
  await initDependencies();

  runApp(const MyApp());
}
