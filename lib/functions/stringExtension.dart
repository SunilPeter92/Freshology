//extension StringExtension on String {
//  String capitalize() {
//    return "${this[0].toUpperCase()}${this.substring(1)}";
//  }
//}

String capitalize(String string) {
  if (string == null) {
    throw ArgumentError("string: $string");
  }

  if (string.isEmpty) {
    return string;
  }

  return string[0].toUpperCase() + string.substring(1);
}

String unCapitalize(String string) {
  if (string == null) {
    throw ArgumentError("string: $string");
  }

  if (string.isEmpty) {
    return string;
  }

  return string[0].toLowerCase() + string.substring(1);
}
