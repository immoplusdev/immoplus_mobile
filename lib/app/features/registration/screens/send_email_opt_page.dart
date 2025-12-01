import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/features/registration/screens/verify_email_otp_page.dart';
import 'package:immoplus/app/logic/authentification/registration_cubit.dart';
import 'package:immoplus/app/logic/authentification/registration_cubit_state.dart';

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

  String? _emailValidator(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return "L'email est requis";
    if (email.length > 254) return "L'email est trop long";
    if (email.contains(' ')) return "L'email ne doit pas contenir d'espaces";

    final regex = RegExp(r'^[\w\.\-+]+@([\w\-]+\.)+[A-Za-z]{2,}$');
    if (!regex.hasMatch(email)) return "Format d'email incorrect";

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Vérification de l’email"),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<RgistrationCubitCubit, RegistrationCubitState>(
        builder: (context, state) {
          final isLoading = state is REGISTRATION_LOADING;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: false,
                floating: false,
                automaticallyImplyLeading: false,
                toolbarHeight: 0,
                elevation: 0,
                backgroundColor: theme.scaffoldBackgroundColor,
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Form(
                            key: _formKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.mark_email_read_outlined,
                                    size: 48, color: theme.colorScheme.primary),
                                const SizedBox(height: 12),
                                Text(
                                  "Saisissez votre adresse email",
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Un code de vérification vous sera envoyé.",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.textTheme.bodyMedium?.color
                                        ?.withOpacity(0.8),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 28),

                                // Champ email
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.send,
                                  validator: _emailValidator,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                        RegExp(r"\s")),
                                    LengthLimitingTextInputFormatter(254),
                                  ],
                                  onFieldSubmitted: (_) =>
                                      isLoading ? null : _submit(context),
                                  decoration: InputDecoration(
                                    hintText: "Adresse email",
                                    prefixIcon:
                                        const Icon(Icons.email_outlined),
                                    filled: true,
                                    fillColor: theme
                                        .colorScheme.surfaceContainerHighest
                                        .withOpacity(0.4),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 18, horizontal: 14),
                                    suffixIcon: ValueListenableBuilder<
                                        TextEditingValue>(
                                      valueListenable: _emailController,
                                      builder: (context, value, _) {
                                        if (value.text.isEmpty)
                                          return const SizedBox();
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
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 24),

                                // Bouton
                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton(
                                    onPressed: isLoading
                                        ? null
                                        : () => _submit(context),
                                    style: FilledButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: isLoading
                                        ? const CupertinoActivityIndicator()
                                        : const Text(
                                            "Envoyer le code",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Votre email est uniquement utilisé pour cette vérification.",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.textTheme.bodySmall?.color
                                        ?.withOpacity(0.7),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
