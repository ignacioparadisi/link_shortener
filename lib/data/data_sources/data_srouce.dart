abstract class DataSource {
  Future<void> createAlias({ required String url });
  Future<void> getAliasById({ required String id});
}