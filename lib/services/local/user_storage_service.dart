import 'package:ezymember_backend/models/user_model.dart';
import 'package:get_storage/get_storage.dart';

class UserStorageService {
  final _box = GetStorage();

  static const _isSignIn = "is_sign_in";

  void saveUser({required UserModel user}) {
    _box.write(_isSignIn, true);
    _box.write(fieldID, user.id);
    _box.write(fieldUserID, user.userID);
    _box.write(fieldName, user.name);
    _box.write(fieldEmail, user.email);
    _box.write(fieldContactNumber, user.contactNumber);
    _box.write(fieldUserType, user.userType);
    _box.write(fieldAccessRight, user.accessRight);
    _box.write(fieldCompanyID, user.companyID);
    _box.write(fieldDatabaseName, user.databaseName);
  }

  bool get isSignIn => _box.read(_isSignIn) ?? false;

  UserModel get user => UserModel(
    id: _box.read(fieldID),
    userID: _box.read(fieldUserID),
    name: _box.read(fieldName),
    email: _box.read(fieldEmail),
    contactNumber: _box.read(fieldContactNumber),
    userType: _box.read(fieldUserType),
    accessRight: _box.read(fieldAccessRight),
    companyID: _box.read(fieldCompanyID),
    databaseName: _box.read(fieldDatabaseName),
  );

  void clear() => _box.erase();
}
