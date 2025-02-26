import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../data/models/user_details.dart';

abstract class LoginRepository {
  Future<Either<Failure, String?>>? getOtp({
    required UserDetails userDetails,
  });

  Future<Either<Failure, UserDetails?>>? putOtp({
    required UserDetails userDetails,
  });

  Future<Either<Failure, UserDetails?>>? getLocalUserDetails();

  Future<Either<Failure, void>>? setLocalUserDetails(
      {required UserDetails? userDetails});
}
