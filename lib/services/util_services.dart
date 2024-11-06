extension StringExtensions on String {
  String capitalize() {
    if (this.isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}