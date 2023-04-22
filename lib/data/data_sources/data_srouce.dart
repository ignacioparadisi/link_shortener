abstract class DataSource {
  Future<dynamic> createAlias({ required String url });
  Future<dynamic> getAliasById({ required String id});
}