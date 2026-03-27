import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/data/enums/contact_change_type.dart';
import 'package:immoplus/app/features/settings/contact_change/cubit/contact_change_cubit.dart';
import 'package:immoplus/app/features/settings/contact_change/cubit/contact_change_state.dart';
import 'package:immoplus/app/features/settings/contact_change/view/confirm_contact_change_page.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:immoplus/app/widgets/international_phone_number_input.dart';

class RequestContactChangePage extends StatefulWidget {
  const RequestContactChangePage({super.key, required this.type});

  static const String name = 'REQUEST_CONTACT_CHANGE_PAGE';

  final ContactChangeType type;

  @override
  State<RequestContactChangePage> createState() =>
      _RequestContactChangePageState();
}

class _RequestContactChangePageState extends State<RequestContactChangePage> {
  String? _phoneNumber;
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String get _title => widget.type == ContactChangeType.phone
      ? 'Changer mon numéro'
      : 'Changer mon email';

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContactChangeCubit, ContactChangeState>(
      listener: (context, state) {
        if (state is ContactChangeRequestLoading) {
          EasyLoading.show();
        } else {
          EasyLoading.dismiss();
        }
        if (state is ContactChangeRequestSuccess) {
          context.pushNamed(
            ConfirmContactChangePage.name,
            extra: state.type,
          );
        } else if (state is ContactChangeRequestError) {
          //
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
            _title,
            style: GoogleFonts.dmSans(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0D0D0D),
            ),
          ),
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                Text(
                  widget.type == ContactChangeType.phone
                      ? 'Entrez votre nouveau numéro de téléphone. Un code de vérification vous sera envoyé.'
                      : 'Entrez votre nouvelle adresse email. Un code de vérification vous sera envoyé.',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: const Color(0xFF64748B),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),
                if (widget.type == ContactChangeType.phone)
                  InternationalPhoneInput(
                    onValidPhoneNumber: (phone) {
                      setState(() => _phoneNumber = phone);
                    },
                  )
                else
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Nouvelle adresse email',
                      filled: true,
                      fillColor: const Color(0xFFECECEC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Champ requis';
                      if (!v.contains('@')) return 'Email invalide';
                      return null;
                    },
                  ),
                const Spacer(),
                BlocBuilder<ContactChangeCubit, ContactChangeState>(
                  builder: (context, state) {
                    return CustomButtom(
                      text: 'Envoyer le code',
                      isLoading: state is ContactChangeRequestLoading,
                      borderRadius: BorderRadius.circular(28),
                      onClick: () {
                        if (widget.type == ContactChangeType.email &&
                            !(_formKey.currentState?.validate() ?? false)) {
                          return;
                        }
                        if (widget.type == ContactChangeType.phone &&
                            (_phoneNumber == null || _phoneNumber!.isEmpty)) {
                          EasyLoading.showError(
                              'Veuillez entrer un numéro valide');
                          return;
                        }
                        context.read<ContactChangeCubit>().requestChange(
                              type: widget.type,
                              phoneNumber: _phoneNumber,
                              email: widget.type == ContactChangeType.email
                                  ? _emailController.text.trim()
                                  : null,
                            );
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
