import 'package:atd/features/login_feature/domain/repository/login_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../data/models/user_details.dart';

class SetLocalUserDetails {
  final LoginRepository repository;

  SetLocalUserDetails({required this.repository});

  Future<Either<Failure, void>?> call(UserDetails? userDetails) async {
    return await repository.setLocalUserDetails(userDetails: userDetails);
  }
}
