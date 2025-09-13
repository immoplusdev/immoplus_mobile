import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/features/reset_password/cubit/reset_password_cubit.dart';
import 'package:immoplus/app/features/reset_password/cubit/reset_password_cubit_state.dart';
import 'package:immoplus/app/features/reset_password/widgets/header_container.dart';
import 'package:immoplus/app/utils/formular_utils.dart';
import 'package:immoplus/app/utils/toast_utils.dart';
import 'package:immoplus/app/widgets/custom_loading_button.dart';
import 'package:immoplus/app/widgets/custom_text_field.dart';

class NewPasswordPage extends StatefulWidget {
  final PageController pageController;

  const NewPasswordPage({super.key, required this.pageController});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final ValueNotifier<bool> _passwordNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _confirmPasswordNotifier =
      ValueNotifier<bool>(false);
  bool _isFormCompleted = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_checkFormCompletion);
    _confirmPasswordController.addListener(_checkFormCompletion);
  }

  void _checkFormCompletion() {
    final isCompleted =
        FormUtils.passwordValidator(password: _passwordController.text) ==
                null &&
            _passwordController.text == _confirmPasswordController.text &&
            _confirmPasswordController.text.isNotEmpty;

    if (_isFormCompleted != isCompleted) {
      setState(() {
        _isFormCompleted = isCompleted;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: () {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) _checkFormCompletion();
        });
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            HeaderContainer(
              iconData: FontAwesomeIcons.lock,
              title: "Créez un nouveau mot de passe",
              subtitle:
                  "Votre nouveau mot de passe doit être différent des précédents.",
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Gap(30),
                  ValueListenableBuilder<bool>(
                    valueListenable: _passwordNotifier,
                    builder: (context, value, child) {
                      return CustomTextField(
                        controller: _passwordController,
                        obscureText: !value,
                        prefixIcon: const Icon(FontAwesomeIcons.lock),
                        sufixIcon: IconButton(
                          onPressed: () {
                            _passwordNotifier.value = !value;
                          },
                          icon: Icon(
                            value
                                ? FontAwesomeIcons.eyeSlash
                                : FontAwesomeIcons.eye,
                            size: 20,
                          ),
                        ),
                        labelText: 'Nouveau mot de passe',
                        validator: (value) =>
                            FormUtils.passwordValidator(password: value),
                      );
                    },
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: _confirmPasswordNotifier,
                    builder: (context, value, child) {
                      return CustomTextField(
                        controller: _confirmPasswordController,
                        obscureText: !value,
                        prefixIcon: const Icon(FontAwesomeIcons.lock),
                        sufixIcon: IconButton(
                          onPressed: () {
                            _confirmPasswordNotifier.value = !value;
                          },
                          icon: Icon(
                            value
                                ? FontAwesomeIcons.eyeSlash
                                : FontAwesomeIcons.eye,
                            size: 20,
                          ),
                        ),
                        labelText: 'Confirmer le mot de passe',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez confirmer votre mot de passe';
                          }
                          if (value != _passwordController.text) {
                            return 'Les mots de passe ne correspondent pas';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  const Gap(30),
                  BlocConsumer<ResetPasswordCubit, ResetPasswordCubitState>(
                    listener: (context, state) {
                      state.when(
                        initial: () {},
                        sendingEmailOtp: () {},
                        emailOtpSent: (message) {},
                        verifyingEmail: () {},
                        emailVerified: () {},
                        resettingPassword: () {},
                        passwordResetSuccess: (message) {
                          ToastUtils.success(message);
                          context.pop();
                          // context.goNamed(LoginPage.name);
                        },
                        error: (errorMessage) {},
                      );
                    },
                    builder: (context, state) {
                      return CustomLoadingButtom(
                        isLoading: state.maybeWhen(
                          resettingPassword: () => true,
                          orElse: () => false,
                        ),
                        clickable: _isFormCompleted,
                        onClick: _isFormCompleted
                            ? () async {
                                if (_formKey.currentState!.validate()) {
                                  context
                                      .read<ResetPasswordCubit>()
                                      .resetPassword(
                                          newPassword:
                                              _passwordController.text);
                                }
                              }
                            : null,
                        text: "Réinitialiser le mot de passe",
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.removeListener(_checkFormCompletion);
    _confirmPasswordController.removeListener(_checkFormCompletion);
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordNotifier.dispose();
    _confirmPasswordNotifier.dispose();
    super.dispose();
  }
}
