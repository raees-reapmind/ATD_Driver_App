import 'package:atd/features/login_feature/domain/repository/login_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../data/models/user_details.dart';

class GetOtp {
  final LoginRepository repository;

  GetOtp({required this.repository});

  Future<Either<Failure, String?>?> call(
      {required UserDetails userDetails}) async {
    return await repository.getOtp(userDetails: userDetails);
  }
}
