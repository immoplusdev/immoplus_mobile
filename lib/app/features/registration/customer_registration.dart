import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/models/auth/customer_registration_body.dart';
import 'package:immoplus/app/data/models/remote/files/file_data_model.dart';
import 'package:immoplus/app/features/account/widgets/general_condition_page.dart';
import 'package:immoplus/app/logic/authentification/registration_cubit.dart';
import 'package:immoplus/app/logic/authentification/registration_cubit_state.dart';
import 'package:immoplus/app/modules/files_uploader.dart/file_uploader_controller.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/formuar_controller.dart';
import 'package:immoplus/app/utils/formular_utils.dart';
import 'package:immoplus/app/utils/phone_number_handler.dart';
import 'package:immoplus/app/widgets/custom_loading_button.dart';
import 'package:immoplus/app/widgets/custom_page_immo.dart';
import 'package:immoplus/app/widgets/custom_popup.dart';
import 'package:immoplus/app/widgets/custom_text_field.dart';
import 'package:immoplus/app/widgets/international_phone_number_input.dart';

class DataRouterRegistration {
  String? email;
  String token;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? provider;

  DataRouterRegistration(
      {required this.email,
      required this.token,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.provider});
}

class CustomerRegistration extends StatefulWidget {
  const CustomerRegistration({super.key, required this.data});
  final DataRouterRegistration data;

  static String name = "customer_Registration";
  static String routePath() => '/registration';

  @override
  State<CustomerRegistration> createState() => _CustomerRegistrationState();
}

class _CustomerRegistrationState extends State<CustomerRegistration> {
  late FormController _formController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FileUploaderController fileUploaderControllerPhotoIdentite =
      FileUploaderController();
  final FileUploaderController fileUploaderControllerPieceIdentite =
      FileUploaderController();

  final FocusNode _focusNode = FocusNode();
  final ValueNotifier<bool> _passwordNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _passwordConfirmNotifier =
      ValueNotifier<bool>(false);
  final ValueNotifier<bool> _cguNotifier = ValueNotifier<bool>(false);
  @override
  void initState() {
    _focusNode.unfocus();

    _formController = FormController(
        productId: 0,
        firstName: TextEditingController(text: widget.data.firstName ?? ''),
        lastName: TextEditingController(text: widget.data.lastName ?? ''),
        phoneNumber: TextEditingController(text: widget.data.phoneNumber ?? ''),
        email: TextEditingController(text: widget.data.email ?? ''),
        password: TextEditingController(text: ''));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isPhoneNumberEmpty =
        widget.data.phoneNumber == null || widget.data.phoneNumber!.isEmpty;
    final bool isEmailEmpty =
        widget.data.email == null || widget.data.email!.isEmpty;

    return Form(
      key: _formKey,
      child: CustomPageImmo(
        title: "Création de compte",
        content: Container(
          padding: const EdgeInsets.all(appPadding),
          child: SingleChildScrollView(
            child: Column(
              children: [
                InternationalPhoneInput(
                  backgroundColor: AppColors.primaryLite,
                  initialPhoneNumber: !isPhoneNumberEmpty
                      ? (widget.data.phoneNumber!.startsWith('+')
                          ? widget.data.phoneNumber
                          : '+${widget.data.phoneNumber}')
                      : null,
                  isEnabled: isPhoneNumberEmpty,
                  onValidPhoneNumber: (value) {
                    if (value != _formController.phoneNumber!.text) {
                      _formController.phoneNumber!.text = value;
                    }
                  },
                  onInputValidated: (p0) {},
                  validator: (String? value) =>
                      FormUtils.numberValidator(number: value),
                ),
                Gap(10),
                CustomTextField(
                  isEnabled: isEmailEmpty,
                  controller: _formController.email,
                  prefixIcon: const Icon(CupertinoIcons.mail),
                  labelText: 'Email',
                  textInputType: TextInputType.emailAddress,
                  validator: (String? value) =>
                      FormUtils.emailValidator(email: value),
                ),
                CustomTextField(
                  controller: _formController.firstName,
                  prefixIcon: const Icon(FontAwesomeIcons.user),
                  labelText: "Nom",
                  validator: (String? value) =>
                      FormUtils.fieldValidator(value: value),
                ),
                CustomTextField(
                  controller: _formController.lastName,
                  prefixIcon: const Icon(FontAwesomeIcons.user),
                  labelText: "Prénom",
                  validator: (String? value) =>
                      FormUtils.fieldValidator(value: value),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _passwordNotifier,
                  builder: (BuildContext context, bool value, child) {
                    return CustomTextField(
                      prefixIcon: const Icon(CupertinoIcons.lock),
                      textInputType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      controller: _formController.password,
                      obscureText: !value,
                      sufixIcon: IconButton(
                        onPressed: () {
                          _passwordNotifier.value = !value;
                        },
                        icon: Icon(
                          value
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                        ),
                      ),
                      labelText: 'Mot de passe',
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).nextFocus();
                      },
                      validator: (String? value) =>
                          FormUtils.passwordValidator(password: value),
                    );
                  },
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _passwordConfirmNotifier,
                  builder: (BuildContext context, bool value, child) {
                    return CustomTextField(
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.visiblePassword,
                      prefixIcon: const Icon(CupertinoIcons.lock),
                      controller: _formController.passwordConfirm,
                      obscureText: !value,
                      sufixIcon: IconButton(
                        onPressed: () {
                          _passwordConfirmNotifier.value = !value;
                        },
                        icon: Icon(
                          value
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                        ),
                      ),
                      labelText: 'Confirmation du mot de passe',
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).unfocus();
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un mot de passe';
                        } else if (value != _formController.password!.text) {
                          return 'Le mot de passe ne correspond pas';
                        }
                        return null;
                      },
                    );
                  },
                ),
                Gap(20),
                ValueListenableBuilder<bool>(
                  valueListenable: _cguNotifier,
                  builder: (BuildContext context, bool value, child) {
                    return Row(
                      children: [
                        Checkbox(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            value: value,
                            fillColor: value
                                ? WidgetStateProperty.all(
                                    Theme.of(context).colorScheme.primary)
                                : WidgetStateProperty.all(Colors.white),
                            onChanged: (val) {
                              _cguNotifier.value = !_cguNotifier.value;
                            }),
                        const Text("j'approuve les"),
                        TextButton(
                            onPressed: () {
                              showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                isScrollControlled: true,
                                useRootNavigator: true,
                                showDragHandle: true,
                                context: context,
                                builder: (context) =>
                                    const FractionallySizedBox(
                                        heightFactor: 0.9,
                                        child: GeneralConditionPage()),
                              );
                            },
                            child: Text(
                              'Termes & conditions',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                            )),
                        const Gap(10),
                      ],
                    );
                  },
                ),
                Gap(20),
                BlocBuilder<RgistrationCubitCubit, RegistrationCubitState>(
                  builder: (context, state) {
                    return CustomLoadingButtom(
                      isLoading: (state is REGISTRATION_LOADING),
                      onClick: ((state is REGISTRATION_LOADING))
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate() &&
                                  _formController.firstName!.text.isNotEmpty) {
                                if (!_cguNotifier.value) {
                                  CustomPopup.toast(
                                      text:
                                          "Les Conditions d'utilisation ne sont pas approuvées",
                                      toastPosition:
                                          EasyLoadingToastPosition.bottom);
                                } else {
                                  String? fileId;
                                  try {
                                    if (fileUploaderControllerPhotoIdentite
                                            .file !=
                                        null) {
                                      CustomPopup.showLoagingToast(
                                          text: "Envoi de l'image...");
                                      FileDataModel fileDataModel =
                                          await fileUploaderControllerPhotoIdentite
                                              .upladFile();
                                      fileId = fileDataModel.data!.id;
                                      EasyLoading.dismiss();
                                    }
                                  } catch (e) {
                                    EasyLoading.dismiss();
                                  }

                                  final body = CustomerRegistrationBody(
                                      avatar: fileId,
                                      firstName:
                                          _formController.firstName!.text,
                                      lastName: _formController.lastName!.text,
                                      email: _formController.email!.text,
                                      token: widget.data.token,
                                      phoneNumber:
                                          PhoneNumberHandler.formatPhoneNumber(
                                              _formController.phoneNumber!.text
                                                  .replaceAll(" ", "")),
                                      password: _formController.password!.text,
                                      provider: widget.data.provider);

                                  if (!context.mounted) return;
                                  context
                                      .read<RgistrationCubitCubit>()
                                      .createCustomerAccount(
                                        customerRegistrationBody: body,
                                        //fileID: fileId,
                                      );
                                }
                              }

                              //context.go('/homePage');
                            },
                      text: "créer mon compte",
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class AlwaysDisabledFocusNode extends FocusNode {
//   @override
//   bool get hasFocus => false;
// }
