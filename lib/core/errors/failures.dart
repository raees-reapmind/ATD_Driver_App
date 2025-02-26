abstract class Failure {
  final String? errorMessage;

  Failure({required this.errorMessage});
}

class ServerFailure extends Failure {
  ServerFailure({required String? errorMessage})
      : super (errorMessage: errorMessage);
}

class DatabaseFailure extends Failure {
  DatabaseFailure({required String? errorMessage})
      : super (errorMessage: errorMessage);
}

class NetworkConnectionFailure extends Failure{
  NetworkConnectionFailure({required super.errorMessage});
}