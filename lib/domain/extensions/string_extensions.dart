extension URLString on String {
  bool get isValidURL {
    final uri = Uri.tryParse(this);
    return uri?.isAbsolute ?? false;
  }
}