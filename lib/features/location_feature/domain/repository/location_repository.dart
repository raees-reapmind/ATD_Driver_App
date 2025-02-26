import 'package:atd/core/errors/failures.dart';
import 'package:atd/features/location_feature/domain/entities/location.dart';
import 'package:dartz/dartz.dart';

abstract class LocationRepository {
  Future<Either<Failure, bool?>>? setLocation({required List<Location> locationList});
}
