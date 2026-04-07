import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/core/network/utils/easy_loading_handler.dart';
import 'package:immoplus/app/data/enums/account_source.dart';
import 'package:immoplus/app/data/models/auth/login_otp_body.dart';
import 'package:immoplus/app/data/models/auth/send_opt_model.dart';
import 'package:immoplus/app/data/repositories/auth_repository.dart';
import 'package:immoplus/app/logic/authentification/login_cubit.dart';
import 'package:immoplus/app/logic/authentification/login_cubit_state.dart';
import 'package:immoplus/app/utils/phone_number_handler.dart';
import 'package:immoplus/app/utils/status_code_handler.dart';
import 'package:immoplus/app/widgets/custom_input.dart';
import 'package:immoplus/app/widgets/custom_popup.dart';
import 'package:immoplus/app/widgets/custom_page_immo.dart';
import 'package:immoplus/app/widgets/custom_loading_button.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key, required this.currentPhoneNumber});
  final String currentPhoneNumber;
  static String name = 'OTP__CONFIRM_LOGIN';

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  late final TextEditingController pinController;
  late final GlobalKey<FormState> formKey;
  String? _errorMessage;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    pinController = TextEditingController();
  }

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  Future<void> _resendOtp() async {
    if (_isResending) return;

    setState(() {
      _isResending = true;
    });

    EasyLoadingHandler.showLoagingToast(text: 'En cours...');

    try {
      final response = await AuthRepository().sendOtp(
        body: SendOptModel(
          phoneNumber: PhoneNumberHandler.formatPhoneNumber(
            widget.currentPhoneNumber,
          ),
        ),
      );

      if (!mounted) return;

      if (StatusCodeHandler.isSuccess(response.response.statusCode)) {
        CustomPopup.toast(
          color: Colors.green,
          toastPosition: EasyLoadingToastPosition.bottom,
          text: "Code renvoyé avec succès",
        );
      } else {
        CustomPopup.showErrorToast(
          text: 'Envoi du code échoué, veuillez ressayer',
        );
      }
    } catch (e) {
      if (!mounted) return;
      CustomPopup.toast(
        color: Colors.red,
        toastPosition: EasyLoadingToastPosition.bottom,
        text: "Envoi de OTP code échoué, veuillez réessayer",
      );
    } finally {
      EasyLoading.dismiss();
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  void _submitOtp() {
    if (pinController.text.length != 6) {
      setState(() {
        _errorMessage = 'Le code doit être composé de 6 chiffres';
      });
      return;
    }

    if (!RegExp(r'^\d{6}$').hasMatch(pinController.text)) {
      setState(() {
        _errorMessage = 'Le code doit être numérique';
      });
      return;
    }

    context.read<LoginCubit>().onSendOtpData(
          body: LoginOtpBody(
            phoneNumber: PhoneNumberHandler.formatPhoneNumber(
              widget.currentPhoneNumber,
            ),
            otp: pinController.text,
            source: AccountSource.customerApp.value,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageImmo(
      // ✅ Pas de BlocListener
      title: "Vérification",

      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Text("Entrez le code envoyé au ${widget.currentPhoneNumber}"),
              const Gap(50),

              // CustomPinput
              CustomPinput(
                controller: pinController,
                errorText: _errorMessage,
                onChanged: (code) {
                  if (_errorMessage != null) {
                    setState(() {
                      _errorMessage = null;
                    });
                  }
                },
                onCompleted: (pin) {
                  log('Code saisi: $pin');
                  _submitOtp();
                },
              ),

              const Gap(30),

              // ✅ BlocBuilder comme l'original
              BlocBuilder<LoginCubit, LoginCubitState>(
                builder: (context, state) {
                  return CustomLoadingButtom(
                    text: "Valider le code",
                    onClick: _submitOtp,
                    isLoading: state is LOGIN_LOADING,
                    clickable: pinController.text.length == 6,
                  );
                },
              ),

              const Gap(20),

              Text(
                'Vous n\'avez pas reçu le code ?',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color.fromRGBO(62, 116, 165, 1),
                    ),
              ),

              TextButton(
                onPressed: _isResending ? null : _resendOtp,
                child: Text(
                  _isResending ? 'Envoi en cours...' : 'Renvoyer',
                  style: TextStyle(
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                    color: _isResending
                        ? Colors.grey
                        : const Color.fromRGBO(62, 116, 165, 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
