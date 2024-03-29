import 'package:cardiac_petct/features/auth/submodules/login/login_cubit.dart';
import 'package:cardiac_petct/features/auth/submodules/login/widgets/petct_recover_password_dialog.dart';
import 'package:cardiac_petct/src/input_validators/validations_mixin.dart';
import 'package:cardiac_petct/src/ui/petct_elevated_button.dart';
import 'package:cardiac_petct/src/ui/petct_logo_titled.dart';
import 'package:cardiac_petct/src/ui/petct_switch_theme_mode.dart';
import 'package:cardiac_petct/src/ui/petct_text_button.dart';
import 'package:cardiac_petct/src/ui/petct_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:localization/localization.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with ValidationsMixin {
  final LoginCubit cubit = Modular.get();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
              onPressed: () {
                Modular.to.pop();
              },
              icon: const Icon(
                FeatherIcons.arrowLeft,
              ),
            ),
            const PetctSwitchThemeMode(),
          ],
        ),
      ),
      body: BlocConsumer(
        bloc: cubit,
        listener: (context, state) {
          if (state.runtimeType == LoginErrorState) {
            final errorState = state as LoginErrorState;
            var snackBar = SnackBar(
              content: Text(
                errorState.failure.errorMessage,
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 68,
                    ),
                    PetctLogoTitled(
                      title: 'login-title'.i18n(),
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          PetctTextFormField(
                            controller: emailController,
                            hintText: 'email-title'.i18n(),
                            textInputType: TextInputType.emailAddress,
                            validator: (value) => combine([
                              () => isNotEmpty(value),
                              () => isEmailValid(value),
                            ]),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          PetctTextFormField(
                            controller: passwordController,
                            obscureText: obscureText,
                            textInputType: TextInputType.text,
                            hintText: 'password-hint'.i18n(),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              icon: Icon(
                                obscureText
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.grey,
                              ),
                            ),
                            validator: (value) => combine([
                              () => isNotEmpty(value),
                              () => hasMinLength(value, 8),
                            ]),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: PetctElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await cubit.login(emailController.text,
                                    passwordController.text);
                              }
                            },
                            child: state.runtimeType == LoginLoadingState
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  )
                                : Text(
                                    'sign-in-label'.i18n(),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: PetctTextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return const PetctRecoverPasswordDialog();
                                },
                              );
                            },
                            child: Text(
                              'forgot-password-label'.i18n(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
