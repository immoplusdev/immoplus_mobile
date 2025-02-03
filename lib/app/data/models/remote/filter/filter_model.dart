class FilterModel {
  final String field; // Correspond à "_field"
  final String operator; // Correspond à "_op"
  final dynamic value; // Correspond à "_val"
  final String logicalOperator; // Correspond à "_l_op"

  FilterModel({
    required this.field,
    required this.operator,
    required this.value,
    this.logicalOperator = "and", // Par défaut : "and"
  });

  @override
  String toString() {
    return '{ "_field": "$field", "_op": "$operator", "_val": $value, "_l_op": "$logicalOperator" }';
  }
}
