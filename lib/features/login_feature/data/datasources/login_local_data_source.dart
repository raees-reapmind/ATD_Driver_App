 
import 'package:hive/hive.dart';

import '../models/user_details.dart';

abstract class LoginLocalDataSource {
  Future<void>? setUserDetails({required UserDetails? userDetails});

  Future<UserDetails?>? getUserDetails();
}

const loginKey = "login_details_key";

class LoginLocalDataSourceImpl implements LoginLocalDataSource {
  final Box loginDetailsBox;

  LoginLocalDataSourceImpl({required this.loginDetailsBox});

  @override
  Future<UserDetails?>? getUserDetails() async {
    return await loginDetailsBox.get(loginKey);
  }

  @override
  Future<void>? setUserDetails({required UserDetails? userDetails}) async {
    return await loginDetailsBox.put(loginKey, userDetails);
  }
}
