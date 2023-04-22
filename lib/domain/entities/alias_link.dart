abstract class AliasLinkJSONKeys {
  static const String original = 'self';
  static const String short = 'short';
}

class AliasLink {
  final String original;
  final String short;

  AliasLink.fromJSON(Map<String, dynamic> json) :
    original = json[AliasLinkJSONKeys.original] as String,
    short = json[AliasLinkJSONKeys.short] as String;
}