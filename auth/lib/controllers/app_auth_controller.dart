import 'dart:io';

import 'package:auth/models/response_model.dart';
import 'package:auth/utils/app_utils.dart';
import 'package:conduit/conduit.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

import '../models/user_model.dart';

class AppAuthController extends ResourceController {
  final ManagedContext managedContext;

  AppAuthController(this.managedContext);

  /// Авторизация
  @Operation.post()
  Future<Response> signIn(@Bind.body() User user) async {
    if (user.username == null || user.password == null) {
      return Response.badRequest(
        body: ResponseModel(
          message: "username/password required",
        ),
      );
    }
    // connect to DB
    // find user
    // check password
    // fetch user
    try {
      final qFindUser = Query<User>(managedContext)
        ..where((table) => table.username).equalTo(user.username)
        ..returningProperties(
            (table) => [table.id, table.salt, table.hashPassword]);
      final findUser = await qFindUser.fetchOne();
      if (findUser == null) {
        throw QueryException.input(
            "Пользователь ${user.username} не найден", []);
      }
      final requestHasPassword =
          AuthUtility.generatePasswordHash(user.password!, findUser.salt!);
      if (requestHasPassword == findUser.hashPassword) {
        await _updateTokens(findUser.id ?? -1, managedContext);
        final newUser =
            await managedContext.fetchObjectWithID<User>(findUser.id);
        return Response.ok(ResponseModel(
            data: newUser?.backing.contents, message: "Успешная авторизация"));
      } else {
        throw QueryException.input("Пароль неверный", []);
      }
    } on QueryException catch (error) {
      return Response.serverError(body: ResponseModel(message: error.message));
    }
  }

  /// Регистрация
  @Operation.put()
  Future<Response> signUp(@Bind.body() User user) async {
    if (user.username == null || user.password == null || user.email == null) {
      return Response.badRequest(
        body: ResponseModel(
          message: "username/password/email required",
        ),
      );
    }
    final salt = AuthUtility.generateRandomSalt();
    final hashPassword = AuthUtility.generatePasswordHash(user.password!, salt);

    try {
      late final int id;
      await managedContext.transaction((transaction) async {
        final qCreateUser = Query<User>(transaction)
          ..values.username = user.username
          ..values.email = user.email
          ..values.salt = salt
          ..values.hashPassword = hashPassword;
        final createdUser = await qCreateUser.insert();
        id = createdUser.asMap()["id"]; // createdUser.id!
        await _updateTokens(id, transaction);
      });
      final userData = await managedContext.fetchObjectWithID<User>(id);
      return Response.ok(ResponseModel(
        data: userData?.backing.contents,
        message: "Успешная регистрация",
      ));
    } on QueryException catch (error) {
      return Response.serverError(body: ResponseModel(message: error.message));
    }
  }

  @Operation.post("refresh")
  Future<Response> refreshToken(
      @Bind.path("refresh") String refreshToken) async {
    try {
      final id = AppUtils.getIdFromToken(refreshToken);
      await _updateTokens(id, managedContext);
      final user = await managedContext.fetchObjectWithID<User>(id);
      return Response.ok(ResponseModel(
          data: user?.backing.contents,
          message: "Успешное обновление токенов"));
    } catch (error) {
      return Response.serverError(
          body: ResponseModel(message: error.toString()));
    }
  }

  Map<String, dynamic> _getTokens(int id) {
    // TODO remove when release
    final key = Platform.environment["SECRET_KEY"] ?? "SECRET_KEY";
    final accessClaimSet = JwtClaim(
      maxAge: Duration(hours: 1),
      otherClaims: {"id": id},
    );
    final refreshClaimSet = JwtClaim(otherClaims: {"id": id});
    final tokens = <String, dynamic>{};
    tokens["access"] = issueJwtHS256(accessClaimSet, key);
    tokens["refresh"] = issueJwtHS256(refreshClaimSet, key);
    return tokens;
  }

  Future<void> _updateTokens(int id, ManagedContext transaction) async {
    final Map<String, dynamic> tokens = _getTokens(id);
    final qUpdateToken = Query<User>(transaction)
      ..where((user) => user.id).equalTo(id)
      ..values.accessToken = tokens["access"]
      ..values.refreshToken = tokens["refresh"];
    await qUpdateToken.updateOne();
  }
}
