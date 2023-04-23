import 'package:flutter_test/flutter_test.dart';
import 'package:nu_link_shortener/domain/entities/alias.dart';
import 'package:nu_link_shortener/domain/entities/alias_link.dart';

void main() {
  group('Alias Tests', () { 
    Map<String, dynamic> data = {
      "alias": "2081096980",
      "_links": {
        "self": 'https://nu.com.mx',
        "short": "https://url-shortener-server.onrender.com/api/alias/2081096980"
      }
    };

    test('Create AliasLink from JSON', () {
      final link = AliasLink.fromJSON(data['_links']);
      expect(link.original, data['_links']['self']);
      expect(link.short, data['_links']['short']);
    });
    
    test('Create Alias from JSON', () {
      final alias = Alias.fromJSON(data);
      expect(alias.id, data['alias']);
      expect(alias.links.original, data['_links']['self']);
      expect(alias.links.short, data['_links']['short']);
    });
  });
}