extension StringExtension on String {
  String capitalize_custom() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
