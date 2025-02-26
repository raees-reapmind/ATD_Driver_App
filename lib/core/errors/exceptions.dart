class ServerException implements Exception {
  String? message;
  ServerException({this.message});
}

class DatabaseException implements Exception {}

class NetworkException implements Exception {}
