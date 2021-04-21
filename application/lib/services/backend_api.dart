abstract class BackendApi {
  Future<String> signIn({String method, String token});
  Future<String> signOut();
}