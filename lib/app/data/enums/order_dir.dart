enum OrderDir {
  asc("asc"),
  desc("desc");

  final String value;

  const OrderDir(this.value);
}

enum OrderByField {
  createdAt("createdAt"),
  updatedAt("updatedAt"),
  score("score");

  final String value;

  const OrderByField(this.value);
}
