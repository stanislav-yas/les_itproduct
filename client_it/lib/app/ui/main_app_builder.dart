import 'package:client_it/app/di/init_di.dart';
import 'package:client_it/app/domain/app_builder.dart';
import 'package:client_it/feature/auth/domain/auth_repository.dart';
import 'package:client_it/feature/auth/domain/auth_state/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainAppBuilder implements AppBuilder {
  @override
  Widget buildApp() {
    return const _GlobalProviders(
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text("Hello"),
          ),
        ),
      ),
    );
  }
}

class _GlobalProviders extends StatelessWidget {
  const _GlobalProviders({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(locator<AuthRepository>()),
        )
      ],
      child: child,
    );
  }
}
