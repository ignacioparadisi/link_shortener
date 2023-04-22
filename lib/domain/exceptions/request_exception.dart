import 'package:nu_link_shortener/domain/exceptions/general_exception.dart';

class RequestException extends GeneralException {
  final String? code;
  RequestException({ super.message, this.code });
}