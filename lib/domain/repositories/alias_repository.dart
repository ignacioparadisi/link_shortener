import 'package:nu_link_shortener/domain/entities/alias.dart';

abstract class AliasRepository {
  Future<Alias> createAlias({ required String url });
}