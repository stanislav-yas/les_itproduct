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
  Future<Response> updateProfile() async {
    try {
      return AppResponse.ok(message: "updateProfile success");
    } catch (error) {
      return AppResponse.serverError(error);
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
