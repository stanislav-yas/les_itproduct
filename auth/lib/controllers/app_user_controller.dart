import 'dart:io';

import 'package:auth/models/user_model.dart';
import 'package:auth/utils/app_const.dart';
import 'package:auth/utils/app_response.dart';
import 'package:auth/utils/app_utils.dart';
import 'package:conduit/conduit.dart';

class AppUserController extends ResourceController {
  final ManagedContext managedContext;

  AppUserController(this.managedContext);

  @Operation.get()
  Future<Response> getProfile(
      @Bind.header(HttpHeaders.authorizationHeader) String header) async {
    try {
      final id = AppUtils.getIdFromHeader(header);
      final user = await managedContext.fetchObjectWithID<User>(id);
      user?.removePropertiesFromBackingMap(
          [AppConst.accessToken, AppConst.refreshToken]);
      return AppResponse.ok(
          message: "getProfile success", body: user?.backing.contents);
    } catch (error) {
      return AppResponse.serverError(error, message: "getProfile failed!!!");
    }
  }

  @Operation.post()
  Future<Response> updateProfile(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
    @Bind.body() User user,
  ) async {
    try {
      final id = AppUtils.getIdFromHeader(header);
      final fUser = await managedContext.fetchObjectWithID<User>(id);
      final qUpdateUser = Query<User>(managedContext)
        ..where((x) => x.id).equalTo(id)
        ..values.username = user.username ?? fUser?.username
        ..values.email = user.email ?? fUser?.email;
      final uUser = await qUpdateUser.updateOne();
      uUser?.removePropertiesFromBackingMap(
          [AppConst.accessToken, AppConst.refreshToken]);
      return AppResponse.ok(
          message: "updateProfile success", body: uUser?.backing.contents);
    } catch (error) {
      return AppResponse.serverError(error, message: "updateProfile failed!!!");
    }
  }

  @Operation.put()
  Future<Response> updatePassword() async {
    try {
      return AppResponse.ok(message: "updatePassword success");
    } catch (error) {
      return AppResponse.serverError(error);
    }
  }
}
