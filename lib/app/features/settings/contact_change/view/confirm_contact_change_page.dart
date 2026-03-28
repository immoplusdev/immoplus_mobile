import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/data/enums/contact_change_type.dart';
import 'package:immoplus/app/features/settings/contact_change/cubit/contact_change_cubit.dart';
import 'package:immoplus/app/features/settings/contact_change/cubit/contact_change_state.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/toast_utils.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:pinput/pinput.dart';

class ConfirmContactChangePage extends StatefulWidget {
  const ConfirmContactChangePage({super.key, required this.type});

  static const String name = 'CONFIRM_CONTACT_CHANGE_PAGE';

  final ContactChangeType type;

  @override
  State<ConfirmContactChangePage> createState() =>
      _ConfirmContactChangePageState();
}

class _ConfirmContactChangePageState extends State<ConfirmContactChangePage> {
  final _pinController = TextEditingController();
  bool _isValid = false;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.type == ContactChangeType.phone
        ? 'numéro de téléphone'
        : 'adresse email';

    final defaultTheme = PinTheme(
      width: 52,
      height: 56,
      textStyle: GoogleFonts.dmSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF0D0D0D),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFECECEC),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return BlocListener<ContactChangeCubit, ContactChangeState>(
      listener: (context, state) {
        if (state is ContactChangeConfirmLoading) {
          EasyLoading.show();
        } else {
          EasyLoading.dismiss();
        }
        if (state is ContactChangeConfirmSuccess) {
          ToastUtils.showSuccess(description: state.message);
          Future.delayed(const Duration(milliseconds: 800), () {
            if (context.mounted) {
              while (context.canPop()) {
                context.pop();
              }
            }
          });
        } else if (state is ContactChangeConfirmError) {
          ToastUtils.showError(description: state.message);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Vérification',
            style: GoogleFonts.dmSans(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0D0D0D),
            ),
          ),
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text(
                'Entrez le code de vérification',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0D0D0D),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Un code a été envoyé à votre $label.',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: const Color(0xFF64748B),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 36),
              Pinput(
                controller: _pinController,
                length: 6,
                autofocus: true,
                defaultPinTheme: defaultTheme,
                focusedPinTheme: defaultTheme.copyWith(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                ),
                onChanged: (value) {
                  setState(() => _isValid = value.length == 6);
                },
              ),
              const Spacer(),
              BlocBuilder<ContactChangeCubit, ContactChangeState>(
                builder: (context, state) {
                  return CustomButtom(
                    text: 'Confirmer',
                    isLoading: state is ContactChangeConfirmLoading,
                    borderRadius: BorderRadius.circular(28),
                    onClick: _isValid
                        ? () {
                            context.read<ContactChangeCubit>().confirmChange(
                                  type: widget.type,
                                  code: _pinController.text,
                                );
                          }
                        : null,
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
