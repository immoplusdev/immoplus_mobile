enum OrderDir {
  asc("asc"),
  desc("desc");

  final String value;

  const OrderDir(this.value);
}

enum OrderByField {
  createdAt("createdAt"),
  updatedAt("updatedAt");

  final String value;

  const OrderByField(this.value);
}
