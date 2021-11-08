class DargitUninitializedException implements Exception {

  @override
  String toString() => "Dargit is not initialized. call Dargit.init() first before calling any other methods.";
}
