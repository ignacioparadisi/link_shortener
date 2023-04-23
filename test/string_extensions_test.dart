import 'package:flutter_test/flutter_test.dart';
import 'package:nu_link_shortener/domain/extensions/string_extensions.dart';

void main() {
  group('String Extensions', () { 
    test('String is not valid URL', () {
      const notValidURL = '123';
      expect(notValidURL.isValidURL, false);
    });

    test('String is valid URL', () {
      const validURL = 'https://nu.com.mx';
      expect(validURL.isValidURL, true);
    });
  });
}