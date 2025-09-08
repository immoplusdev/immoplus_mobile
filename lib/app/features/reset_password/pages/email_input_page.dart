import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/features/reset_password/cubit/reset_password_cubit.dart';
import 'package:immoplus/app/features/reset_password/cubit/reset_password_cubit_state.dart';
import 'package:immoplus/app/features/reset_password/widgets/header_container.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/formular_utils.dart';
import 'package:immoplus/app/widgets/custom_loading_button.dart';
import 'package:immoplus/app/widgets/custom_text_field.dart';

class EmailInputPage extends StatefulWidget {
  final PageController pageController;

  const EmailInputPage({super.key, required this.pageController});

  @override
  State<EmailInputPage> createState() => _EmailInputPageState();
}

class _EmailInputPageState extends State<EmailInputPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isFormCompleted = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_checkFormCompletion);
  }

  void _checkFormCompletion() {
    final isCompleted = FormUtils.isValidEmail(_emailController.text);
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
              iconData: FontAwesomeIcons.envelope,
              title: "Entrez votre email",
              subtitle:
                  "Nous vous enverrons un code de vérification par email pour réinitialiser votre mot de passe.",
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Gap(30),
                  CustomTextField(
                    controller: _emailController,
                    prefixIcon: const Icon(FontAwesomeIcons.envelope),
                    labelText: 'Adresse email',
                    textInputType: TextInputType.emailAddress,
                    validator: (value) =>
                        FormUtils.emailValidator(email: value),
                  ),
                  const Gap(30),
                  BlocConsumer<ResetPasswordCubit, ResetPasswordCubitState>(
                    listener: (context, state) {
                      state.when(
                        initial: () {},
                        sendingEmailOtp: () {},
                        emailOtpSent: (message) {
                          widget.pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        verifyingEmail: () {},
                        emailVerified: () {},
                        resettingPassword: () {},
                        passwordResetSuccess: (message) {},
                        error: (errorMessage) {},
                      );
                    },
                    builder: (context, state) {
                      return CustomLoadingButtom(
                        isLoading: state.maybeWhen(
                          sendingEmailOtp: () => true,
                          orElse: () => false,
                        ),
                        clickable: _isFormCompleted,
                        onClick: () async {
                          if (_formKey.currentState!.validate()) {
                            context.read<ResetPasswordCubit>().sendEmailOtp(
                                email: _emailController.text.trim());
                          }
                        },
                        text: "Envoyer le code",
                      );
                    },
                  ),
                  const Gap(20),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: Text(
                      "Retour à la connexion",
                      style: TextStyle(
                        color: AppColors.lightBlue,
                        fontSize: 16,
                      ),
                    ),
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
    _emailController.removeListener(_checkFormCompletion);
    _emailController.dispose();
    super.dispose();
  }
}
