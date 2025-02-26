import 'package:atd/features/login_feature/domain/repository/login_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../data/models/user_details.dart';

class GetLocalUserDetails {
  final LoginRepository repository;

  GetLocalUserDetails({required this.repository});

  Future<Either<Failure, UserDetails?>?> call() async { 
    return await repository.getLocalUserDetails();
  }
}
