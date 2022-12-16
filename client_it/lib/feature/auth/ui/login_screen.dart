import 'package:client_it/app/ui/components/app_text_button.dart';
import 'package:client_it/app/ui/components/app_text_field.dart';
import 'package:client_it/feature/auth/domain/auth_state/auth_cubit.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final controllerLogin = TextEditingController();
  final controllerPassword = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Screen"),
      ),
      body: Form(
        key: formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(controller: controllerLogin, labelText: "логин"),
                const SizedBox(
                  height: 16,
                ),
                AppTextField(
                    controller: controllerPassword,
                    labelText: "пароль",
                    obscureText: true),
                const SizedBox(
                  height: 16,
                ),
                AppTextButton(
                  onPressed: () => {
                    if (formKey.currentState?.validate() == true)
                      { _onTapToSignIn(context.<AuthCubit>())}
                  },
                  text: "войти",
                ),
                const SizedBox(
                  height: 16,
                ),
                AppTextButton(
                  backgroundColor: Colors.blueGrey,
                  onPressed: () => {
                    if (formKey.currentState?.validate() == true)
                      {print("регистрация pressed")}
                  },
                  text: "регистрация",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTapToSignIn(AuthCubit authCubit) => authCubit.signIn(
      username: controllerLogin.text, password: controllerPassword.text);
}
