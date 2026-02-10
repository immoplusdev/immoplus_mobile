import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/features/registration/screens/verify_email_otp_page.dart';
import 'package:immoplus/app/logic/authentification/registration_cubit.dart';
import 'package:immoplus/app/logic/authentification/registration_cubit_state.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/formular_utils.dart';
import 'package:immoplus/app/widgets/custom_loading_button.dart';
import 'package:immoplus/app/widgets/custom_page_immo.dart';
import 'package:immoplus/app/widgets/custom_text_field.dart';
import 'package:immoplus/gen/assets.gen.dart';

class SendEmailOptPage extends StatefulWidget {
  const SendEmailOptPage({super.key});
  static const String name = "SendEmailOptPage";
  @override
  State<SendEmailOptPage> createState() => _SendEmailOptPageState();
}

class _SendEmailOptPageState extends State<SendEmailOptPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<RgistrationCubitCubit>();
    final success =
        await cubit.sendEmailOTP(email: _emailController.text.trim());
    if (!mounted) return;

    if (success) {
      context.pushNamed(VerifyEmailOtpPage.name,
          extra: _emailController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomPageImmo(
      title: "Vérification de l'email",
      content: BlocBuilder<RgistrationCubitCubit, RegistrationCubitState>(
        builder: (context, state) {
          final isLoading = state is REGISTRATION_LOADING;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(appPadding),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Saisissez votre adresse email",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Gap(8),
                      Text(
                        "Un code de vérification vous sera envoyé.",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyMedium?.color
                              ?.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Gap(28),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.E6F5FF,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Image.asset(
                                Assets.img.email.path,
                                width: 35,
                              ),
                            ),
                            Gap(14),
                            Text("Adresse E-mail",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600, fontSize: 15)),
                            Gap(13),
                            // Champ email
                            CustomTextField(
                              labelText: "Adresse email",
                              controller: _emailController,
                              textInputType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.send,
                              validator: (String? value) =>
                                  FormUtils.emailValidator(email: value),
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r"\s")),
                                LengthLimitingTextInputFormatter(254),
                              ],
                              onFieldSubmitted: (_) =>
                                  isLoading ? null : _submit(context),
                              prefixIcon: const Icon(Icons.email_outlined),
                              fontSize: 16,
                              fillColor: AppColors.white,
                              sufixIcon:
                                  ValueListenableBuilder<TextEditingValue>(
                                valueListenable: _emailController,
                                builder: (context, value, _) {
                                  if (value.text.isEmpty) {
                                    return const SizedBox();
                                  }
                                  return IconButton(
                                    tooltip: "Effacer",
                                    icon: const Icon(Icons.close),
                                    onPressed: isLoading
                                        ? null
                                        : _emailController.clear,
                                  );
                                },
                              ),
                            ),
                            const Gap(8),

                            // Bouton
                            CustomLoadingButtom(
                              text: "Envoyer le code",
                              onClick: () => _submit(context),
                              isLoading: isLoading,
                              clickable: true,
                            ),
                            const Gap(24),
                            Text(
                              "Votre email est uniquement utilisé pour cette vérification.",
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
