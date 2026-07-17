import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
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
import 'package:immoplus/app/widgets/custom_popup.dart';
import 'package:immoplus/app/widgets/custom_text_field.dart';

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

  final FileUploaderController fileUploaderControllerPhotoIdentite =
      FileUploaderController();
  final FileUploaderController fileUploaderControllerPieceIdentite =
      FileUploaderController();

  final FocusNode _focusNode = FocusNode();
  // final ValueNotifier<bool> _passwordNotifier = ValueNotifier<bool>(false);
  // final ValueNotifier<bool> _passwordConfirmNotifier =
  //     ValueNotifier<bool>(false);
  final ValueNotifier<bool> _cguNotifier = ValueNotifier<bool>(false);

  DateTime? _birthDate;
  String? _nomError;
  String? _prenomError;
  String? _birthDateError;

  static const _fieldBorderColor = Color(0x1C000000);

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

  InputBorder _fieldBorder({Color? color, double width = 1, double? radius}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius ?? radiusButton),
        borderSide: BorderSide(color: color ?? _fieldBorderColor, width: width),
      );

  bool get _hasFieldError =>
      _nomError != null || _prenomError != null || _birthDateError != null;

  bool _validateFields() {
    setState(() {
      _nomError =
          FormUtils.fieldValidator(value: _formController.firstName!.text);
      _prenomError =
          FormUtils.fieldValidator(value: _formController.lastName!.text);
      _birthDateError = _birthDate == null
          ? 'Veuillez renseigner votre date de naissance'
          : null;
    });
    return !_hasFieldError;
  }

  Future<void> _pickBirthDate() async {
    DateTime tempDate = _birthDate ?? DateTime(1995, 6, 1);
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) {
        return Container(
          height: 260,
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                    onPressed: () {
                      setState(() {
                        _birthDate = tempDate;
                        _birthDateError = null;
                      });
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.monthYear,
                  initialDateTime: tempDate,
                  minimumYear: 1930,
                  maximumYear: DateTime.now().year,
                  onDateTimeChanged: (value) {
                    tempDate = value;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBirthDateField() {
    final hasValue = _birthDate != null;
    return GestureDetector(
      onTap: _pickBirthDate,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(radiusButton),
          border: Border.all(
            color: _birthDateError != null ? Colors.red : _fieldBorderColor,
            width: _birthDateError != null ? 1.3 : 1,
          ),
        ),
        child: Row(
          children: [
            const Icon(CupertinoIcons.calendar, color: Colors.grey, size: 20),
            const Gap(12),
            Text(
              hasValue
                  ? DateFormat('MMMM yyyy', 'fr_FR').format(_birthDate!)
                  : 'Date de naissance',
              style: TextStyle(
                fontSize: 15,
                color: hasValue ? Colors.black : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24),
          child: GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
              child: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                    appPadding, appPadding, appPadding, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Gap(8),
                    Text(
                      "Créez votre compte",
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF1F1F1F),
                              ),
                    ),
                    const Gap(16),
                    Text(
                      "Renseignez vos informations pour finaliser votre inscription",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFA3A3A3),
                          ),
                    ),
                    const Gap(30),

                    // --- Champs désactivés temporairement ---
                    // InternationalPhoneInput(
                    //   backgroundColor: AppColors.primaryLite,
                    //   initialPhoneNumber: !isPhoneNumberEmpty
                    //       ? (widget.data.phoneNumber!.startsWith('+')
                    //           ? widget.data.phoneNumber
                    //           : '+${widget.data.phoneNumber}')
                    //       : null,
                    //   isEnabled: isPhoneNumberEmpty,
                    //   onValidPhoneNumber: (value) {
                    //     if (value != _formController.phoneNumber!.text) {
                    //       _formController.phoneNumber!.text = value;
                    //     }
                    //   },
                    //   onInputValidated: (p0) {},
                    //   validator: (String? value) =>
                    //       FormUtils.numberValidator(number: value),
                    // ),
                    // Gap(10),
                    // CustomTextField(
                    //   isEnabled: isEmailEmpty,
                    //   controller: _formController.email,
                    //   prefixIcon: const Icon(CupertinoIcons.mail),
                    //   labelText: 'Email',
                    //   textInputType: TextInputType.emailAddress,
                    //   validator: (String? value) =>
                    //       FormUtils.emailValidator(email: value),
                    // ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _formController.firstName,
                            labelText: "Nom",
                            autofocus: true,
                            fontSize: 15,
                            fillColor: Colors.transparent,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 18),
                            enabledBorder: _fieldBorder(
                                color: _nomError != null ? Colors.red : null,
                                width: _nomError != null ? 1.3 : 1,
                                radius: 16),
                            focusedBorder: _fieldBorder(
                                color: _nomError != null
                                    ? Colors.red
                                    : AppColors.blue65BAF0,
                                width: 1.5,
                                radius: 16),
                            onChanged: (_) {
                              if (_nomError != null) {
                                setState(() => _nomError = null);
                              }
                            },
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: CustomTextField(
                            controller: _formController.lastName,
                            labelText: "Prénom",
                            fontSize: 15,
                            fillColor: Colors.transparent,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 18),
                            enabledBorder: _fieldBorder(
                                color: _prenomError != null ? Colors.red : null,
                                width: _prenomError != null ? 1.3 : 1,
                                radius: 16),
                            focusedBorder: _fieldBorder(
                                color: _prenomError != null
                                    ? Colors.red
                                    : AppColors.blue65BAF0,
                                width: 1.5,
                                radius: 16),
                            onChanged: (_) {
                              if (_prenomError != null) {
                                setState(() => _prenomError = null);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const Gap(10),
                    _buildBirthDateField(),
                    if (_hasFieldError) ...[
                      const Gap(8),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          _nomError ?? _prenomError ?? _birthDateError ?? '',
                          style:
                              const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    ],

                    // ValueListenableBuilder<bool>(
                    //   valueListenable: _passwordNotifier,
                    //   builder: (BuildContext context, bool value, child) {
                    //     return CustomTextField(
                    //       prefixIcon: const Icon(CupertinoIcons.lock),
                    //       textInputType: TextInputType.visiblePassword,
                    //       textInputAction: TextInputAction.next,
                    //       controller: _formController.password,
                    //       obscureText: !value,
                    //       sufixIcon: IconButton(
                    //         onPressed: () {
                    //           _passwordNotifier.value = !value;
                    //         },
                    //         icon: Icon(
                    //           value
                    //               ? Icons.visibility_off_rounded
                    //               : Icons.visibility_rounded,
                    //         ),
                    //       ),
                    //       labelText: 'Mot de passe',
                    //       onFieldSubmitted: (_) {
                    //         FocusScope.of(context).nextFocus();
                    //       },
                    //       validator: (String? value) =>
                    //           FormUtils.passwordValidator(password: value),
                    //     );
                    //   },
                    // ),
                    // ValueListenableBuilder<bool>(
                    //   valueListenable: _passwordConfirmNotifier,
                    //   builder: (BuildContext context, bool value, child) {
                    //     return CustomTextField(
                    //       textInputAction: TextInputAction.done,
                    //       textInputType: TextInputType.visiblePassword,
                    //       prefixIcon: const Icon(CupertinoIcons.lock),
                    //       controller: _formController.passwordConfirm,
                    //       obscureText: !value,
                    //       sufixIcon: IconButton(
                    //         onPressed: () {
                    //           _passwordConfirmNotifier.value = !value;
                    //         },
                    //         icon: Icon(
                    //           value
                    //               ? Icons.visibility_off_rounded
                    //               : Icons.visibility_rounded,
                    //         ),
                    //       ),
                    //       labelText: 'Confirmation du mot de passe',
                    //       onFieldSubmitted: (_) {
                    //         FocusScope.of(context).unfocus();
                    //       },
                    //       validator: (String? value) {
                    //         if (value == null || value.isEmpty) {
                    //           return 'Veuillez entrer un mot de passe';
                    //         } else if (value != _formController.password!.text) {
                    //           return 'Le mot de passe ne correspond pas';
                    //         }
                    //         return null;
                    //       },
                    //     );
                    //   },
                    // ),
                    const Gap(20),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(appPadding, 12, appPadding, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: _cguNotifier,
                    builder: (BuildContext context, bool value, child) {
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _cguNotifier.value = !_cguNotifier.value;
                            },
                            child: Icon(
                              value
                                  ? Iconsax.tick_circle
                                  : Iconsax.record_circle,
                              size: 24,
                              color: value
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                            ),
                          ),
                          const Gap(8),
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
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              )),
                          const Gap(10),
                        ],
                      );
                    },
                  ),
                  const Gap(16),
                  BlocBuilder<RgistrationCubitCubit, RegistrationCubitState>(
                    builder: (context, state) {
                      return CustomLoadingButtom(
                        isLoading: (state is REGISTRATION_LOADING),
                        onClick: ((state is REGISTRATION_LOADING))
                            ? null
                            : () async {
                                if (_validateFields()) {
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

                                    final email =
                                        _formController.email!.text.trim();
                                    final password =
                                        _formController.password!.text.trim();

                                    final body = CustomerRegistrationBody(
                                        avatar: fileId,
                                        firstName:
                                            _formController.firstName!.text,
                                        lastName:
                                            _formController.lastName!.text,
                                        email: email.isEmpty ? null : email,
                                        token: widget.data.token,
                                        phoneNumber: PhoneNumberHandler
                                            .formatPhoneNumber(_formController
                                                .phoneNumber!.text
                                                .replaceAll(" ", "")),
                                        password:
                                            password.isEmpty ? null : password,
                                        provider: widget.data.provider,
                                        birthDate: DateFormat('yyyy-MM-dd')
                                            .format(DateTime(_birthDate!.year,
                                                _birthDate!.month, 1)));

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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class AlwaysDisabledFocusNode extends FocusNode {
//   @override
//   bool get hasFocus => false;
// }
