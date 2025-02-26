import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/user_details.dart';
import '../repository/login_repository.dart';

class PutOtp {
  final LoginRepository repository;

  PutOtp({required this.repository});

  Future<Either<Failure, UserDetails?>?> call(
      {required UserDetails userDetails}) async {
    return await repository.putOtp(userDetails: userDetails);
  }
}
