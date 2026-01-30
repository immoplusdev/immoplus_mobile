import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/data/enums/account_source.dart';
import 'package:immoplus/app/data/models/auth/login_body_model.dart';
import 'package:immoplus/app/features/reset_password/pages/reset_password_page.dart';
import 'package:immoplus/app/logic/authentification/login_cubit.dart';
import 'package:immoplus/app/logic/authentification/login_cubit_state.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/formuar_controller.dart';
import 'package:immoplus/app/utils/formular_utils.dart';
import 'package:immoplus/app/widgets/custom_loading_button.dart';
import 'package:immoplus/app/widgets/custom_text_field.dart';
import 'package:immoplus/app/widgets/social_button_widget.dart';

class LoginWithEmailScreen extends StatefulWidget {
  const LoginWithEmailScreen({super.key, required this.rootPageController});
  final PageController rootPageController;

  @override
  State<LoginWithEmailScreen> createState() => _LoginWithEmailScreenState();
}

class _LoginWithEmailScreenState extends State<LoginWithEmailScreen> {
  late ValueNotifier<bool> _passwordNotifier;
  late GlobalKey<FormState> _formKey;

  late Map<String, dynamic> _formData;
  late FormController _formController;
  // INITSTATE
  @override
  void initState() {
    // TODO: implement initState
    _formController = FormController(
      productId: 0,
      email: TextEditingController(text: ''), //'satu1@gmail.com'
      password: TextEditingController(text: ''), //'satu@123'
    );
    _passwordNotifier = ValueNotifier<bool>(false);
    _formKey = GlobalKey<FormState>();

    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) => showModalBottomSheet(
    //       context: context,
    //       builder: (context) => Container(),
    //     ));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              const Gap(40),
              CustomTextField(
                fillColor: Colors.white,
                controller: _formController.email,
                labelText: 'Email',
                textInputType: TextInputType.emailAddress,
                prefixIcon: const Icon(
                  CupertinoIcons.mail,
                  size: 19,
                ),
                validator: (value) => FormUtils.emailValidator(email: value),
              ),
              const SizedBox(
                height: 10,
              ),
              ValueListenableBuilder<bool>(
                  valueListenable: _passwordNotifier,
                  builder: (BuildContext context, bool value, child) {
                    return CustomTextField(
                      fillColor: Colors.white,
                      controller: _formController.password,
                      obscureText: !_passwordNotifier.value,
                      prefixIcon: const Icon(CupertinoIcons.lock),
                      sufixIcon: IconButton(
                        onPressed: () {
                          _passwordNotifier.value = !_passwordNotifier.value;
                        },
                        icon: Icon(
                          (value)
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                        ),
                        iconSize: 22,
                      ),
                      labelText: 'Mot de passe',
                      validator: (value) =>
                          FormUtils.passwordValidator(password: value),
                    );
                  }),
              const Gap(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => ResetPassword(),
                        //     ));
                        context.pushNamed(ResetPasswordPage.name);
                      },
                      child: Text(
                        'Mot de passe oublié',
                        style: GoogleFonts.inter(color: AppColors.primary),
                      )),
                  // TextButton(
                  //     onPressed: () {
                  //       context.pushNamed(SendEmailOptPage.name);
                  //     },
                  //     child: Text(
                  //       'S\'inscrire',
                  //       style: GoogleFonts.inter(color: AppColors.primary),
                  //     )),
                ],
              ),
              const Gap(5),
              BlocBuilder<LoginCubit, LoginCubitState>(
                builder: (context, state) {
                  return CustomLoadingButtom(
                    isLoading: (state is LOGIN_LOADING),
                    onClick: ((state is LOGIN_LOADING))
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();

                              final body = LoginBodyModel(
                                username: _formController.email!.text,
                                password: _formController.password!.text,
                                source: AccountSource.customerApp.value,
                              );

                              context.read<LoginCubit>().onSendData(
                                    body: body,
                                  );
                            }

                            //context.go('/homePage');
                          },
                    text: 'Connexion'.toUpperCase(),
                  );
                },
              ),
              const Gap(10),
              const Row(
                children: [
                  Flexible(
                    child: SizedBox(
                      width: 200,
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Ou'),
                  ),
                  Flexible(
                      child: SizedBox(
                          child: Divider(
                    thickness: 1,
                  ))),
                ],
              ),
              const Gap(10),
              SocialLoginButtons(
                mode: LoginMode.email,
                onSwitchMode: () {
                  widget.rootPageController.previousPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
