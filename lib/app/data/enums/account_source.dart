enum AccountSource {
  customerApp(value: "customer_app");

  // TODO: NOT USED IN CUSTOMER APP
  // admin(value: "admin"),
  // proApp(value: "pro_app"),

  final String value;

  const AccountSource({required this.value});
}
