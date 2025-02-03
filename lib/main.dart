import 'package:flutter/material.dart';
import 'package:immoplus/app/appli/my_app.dart';
import 'package:immoplus/app/core/config/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  return runApp(const MyApp());
}
