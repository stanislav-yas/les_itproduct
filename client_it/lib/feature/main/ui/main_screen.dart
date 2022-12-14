import 'package:client_it/feature/auth/domain/entities/user_entity/user_entity.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.userEntity});

  final UserEntity userEntity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Main Screen")),
      body: Center(
        child: Text(userEntity.username),
      ),
    );
  }
}
