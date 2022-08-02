import 'dart:io';

abstract class AppEnv {
  static final String secretKey =
      Platform.environment["SECRET_KEY"] ?? "SECRET_KEY";
  static final String port = Platform.environment["PORT"] ?? "6200";
  static final String dbUsername =
      Platform.environment["DB_USERNAME"] ?? "admin";
  static final String dbPassword =
      Platform.environment["DB_PASSWORD"] ?? "root";
  static final String dbHost = Platform.environment["DB_HOST"] ?? "172.17.0.1";
  static final String dbPort = Platform.environment["DB_PORT"] ?? "6201";
  static final String dbDatabaseName =
      Platform.environment["DB_NAME"] ?? "postgre";
}
