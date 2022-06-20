import 'package:auth/models/response_model.dart';
import 'package:conduit/conduit.dart';

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

    final User fetchedUser = User();

    // connect to DB
    // create user
    // fetch user
    return Response.ok(ResponseModel(
      data: {
        "id": fetchedUser.id,
        "refreshToken": fetchedUser.refreshToken,
        "accessToken": fetchedUser.accessToken,
      },
      message: "Успешная регистрация",
    ).toJson());
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
}
