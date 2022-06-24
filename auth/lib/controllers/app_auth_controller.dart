import 'dart:io';

import 'package:auth/models/response_model.dart';
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

    final User fetchedUser = User();

    // connect to DB
    // find user
    // check password
    // fetch user

    return Response.ok(ResponseModel(
      data: {
        "id": fetchedUser.id,
        "refreshToken": fetchedUser.refreshToken,
        "accessToken": fetchedUser.accessToken,
      },
      message: "Success authorization",
    ).toJson());
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
        final Map<String, dynamic> tokens = _getTokens(id);
        final qUpdateToken = Query<User>(transaction)
          ..where((user) => user.id).equalTo(id)
          ..values.accessToken = tokens["access"]
          ..values.refreshToken = tokens["refresh"];
        await qUpdateToken.updateOne();
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
    final User fetchedUser = User();

    // connect to DB
    // find user
    // check token
    // fetch user

    return Response.ok(ResponseModel(
      data: {
        "id": fetchedUser.id,
        "refreshToken": fetchedUser.refreshToken,
        "accessToken": fetchedUser.accessToken,
      },
      message: "Успешное обновление токенов",
    ).toJson());
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
}
