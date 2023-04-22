import 'package:nu_link_shortener/domain/entities/alias_link.dart';

abstract class AliasJSONKeys {
  static const String id = 'alias';
  static const String links = '_links';
}

class Alias {
  final String id;
  final AliasLink links;

  Alias.fromJSON(Map<String, dynamic> json):
    id = json[AliasJSONKeys.id],
    links = AliasLink.fromJSON(json[AliasJSONKeys.links]);
    
}