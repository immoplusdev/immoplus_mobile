class RequestUtils {
  static String addIndentation(String jsonString, int indentation) {
    StringBuffer indentedJson = StringBuffer();
    String indent = ' ' * indentation;

    int nestingLevel = 0;
    for (int i = 0; i < jsonString.length; i++) {
      String char = jsonString[i];

      if (char == '{' || char == '[') {
        nestingLevel++;
        indentedJson.write(char);
        indentedJson.write('\n${indent * nestingLevel}');
      } else if (char == '}' || char == ']') {
        nestingLevel--;
        indentedJson.write('\n${indent * nestingLevel}');
        indentedJson.write(char);
      } else if (char == ',') {
        indentedJson.write(char);
        indentedJson.write('\n${indent * nestingLevel}');
      } else {
        indentedJson.write(char);
      }
    }

    return indentedJson.toString();
  }
}
