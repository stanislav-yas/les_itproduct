import 'package:auth/utils/app_response.dart';
import 'package:conduit/conduit.dart';

class AppUserController extends ResourceController {
  final ManagedContext managedContext;

  AppUserController(this.managedContext);

  @Operation.get()
  Future<Response> getProfile() async {
    try {
      return AppResponse.ok(message: "getProfile success");
    } catch (error) {
      return AppResponse.serverError(error);
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
