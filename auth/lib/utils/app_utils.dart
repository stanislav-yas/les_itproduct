import 'dart:io';

import 'package:jaguar_jwt/jaguar_jwt.dart';

abstract class AppUtils {
  static int getIdFromToken(String token) {
    try {
      final key = Platform.environment["SECRET_KEY"] ?? "SECRET_KEY";
      final jwtClaim = verifyJwtHS256Signature(token, key);
      return int.parse(jwtClaim["id"].toString());
    } catch (_) {
      rethrow;
    }
  }
}
