import 'dart:io';

enum AccountSource {
  customerApp(value: "customer_app");

  // TODO: NOT USED IN CUSTOMER APP
  // admin(value: "admin"),
  // proApp(value: "pro_app"),

  final String value;

  const AccountSource({required this.value});
}

/// Application cible pour l'enregistrement push backend (`push_installations`).
enum PushApp {
  client(value: "client"),
  pro(value: "pro");

  final String value;

  const PushApp({required this.value});
}

/// Plateforme de l'appareil pour l'enregistrement push backend (`push_installations`).
enum PushPlatform {
  android(value: "android"),
  ios(value: "ios");

  final String value;

  const PushPlatform({required this.value});

  static PushPlatform get current =>
      Platform.isIOS ? PushPlatform.ios : PushPlatform.android;
}

