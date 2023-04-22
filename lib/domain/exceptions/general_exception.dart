class GeneralException implements Exception {
  final String? message;
  GeneralException({ this.message });

  @override
  String toString() {
    if (message != null) return '$runtimeType: $message';
    return runtimeType.toString();
  }
}