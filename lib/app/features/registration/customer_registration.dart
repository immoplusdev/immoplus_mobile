// ignore_for_file: use_build_context_synchronously

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/core/config/injection.dart';
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
import 'package:immoplus/app/widgets/international_phone_number_input.dart';

class CustomerRegistration extends StatefulWidget {
  const CustomerRegistration({super.key});
  static String name = "customer_Registration";
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
  final PageController _pageController = PageController();
  final ValueNotifier<bool> _passwordNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _passwordConfirmNotifier =
      ValueNotifier<bool>(false);
  final ValueNotifier<bool> _cguNotifier = ValueNotifier<bool>(false);
  @override
  void initState() {
    _focusNode.unfocus();

    _formController = FormController(
        productId: 0,
        firstName: TextEditingController(text: ''),
        lastName: TextEditingController(text: ''),
        phoneNumber: TextEditingController(text: ''),
        email: TextEditingController(text: ''),
        password: TextEditingController(text: ''));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RgistrationCubitCubit>(),
      child: Form(
        key: _formKey,
        child: Scaffold(
          backgroundColor: AppColors.primaryLite,
          body: CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            //padding: const EdgeInsets.only(left: 15, right: 15),
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                backgroundColor: AppColors.primaryLite,
                leadingWidth: 35,
                centerTitle: true,
                pinned: true,
                title: Text(
                  "Inscription",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              SliverToBoxAdapter(
                child: Center(
                  child: AutoSizeText(
                    maxLines: 1,
                    "Veuillez renseigner les champs",
                    textAlign: TextAlign.center,
                    style:
                        Theme.of(context).textTheme.headlineSmall!.copyWith(),
                  ),
                ),
              ),
              const SliverGap(20),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                sliver: SliverToBoxAdapter(
                  child: InternationalPhoneInput(
                    backgroundColor: AppColors.primaryLite,
                    onValidPhoneNumber: (value) {
                      //phoneNumber = value;
                      print(value);
                      if (value != _formController.phoneNumber!.text) {
                        _formController.phoneNumber!.text = value;
                      }

                      // Le numéro valide est traité ici si nécessaire
                      // print(phoneNumber);
                    },
                    onInputValidated: (p0) {},
                    validator: (String? value) =>
                        FormUtils.numberValidator(number: value),
                  ),
                ),
              ),
              const SliverGap(6),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                sliver: SliverToBoxAdapter(
                  child: CustomTextField(
                    fillColor: Colors.white,
                    controller: _formController.email,
                    prefixIcon: const Icon(CupertinoIcons.mail),
                    labelText: 'Email',
                    textInputType: TextInputType.emailAddress,
                    validator: (String? value) =>
                        FormUtils.emailValidator(email: value),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                sliver: SliverToBoxAdapter(
                  child: CustomTextField(
                    fillColor: Colors.white,
                    controller: _formController.firstName,
                    prefixIcon: const Icon(FontAwesomeIcons.user),
                    labelText: "Nom",
                    validator: (String? value) =>
                        FormUtils.fieldValidator(value: value),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                sliver: SliverToBoxAdapter(
                  child: CustomTextField(
                    fillColor: Colors.white,
                    controller: _formController.lastName,
                    prefixIcon: const Icon(FontAwesomeIcons.user),
                    labelText: "Prénom",
                    validator: (String? value) =>
                        FormUtils.fieldValidator(value: value),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                sliver: SliverToBoxAdapter(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _passwordNotifier,
                    builder: (BuildContext context, bool value, child) {
                      return CustomTextField(
                        fillColor: Colors.white,
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
                ),
              ),
              const SliverGap(10),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                sliver: SliverToBoxAdapter(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _passwordConfirmNotifier,
                    builder: (BuildContext context, bool value, child) {
                      return CustomTextField(
                        fillColor: Colors.white,
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
                ),
              ),
              const SliverGap(10),
              SliverToBoxAdapter(
                child: ValueListenableBuilder<bool>(
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
              ),
              const SliverGap(10),
              SliverPadding(
                padding: const EdgeInsets.all(5.0),
                sliver:
                    BlocBuilder<RgistrationCubitCubit, RegistrationCubitState>(
                  builder: (context, state) {
                    return SliverToBoxAdapter(
                      child: CustomLoadingButtom(
                        isLoading: (state is REGISTRATION_LOADING),
                        onClick: ((state is REGISTRATION_LOADING))
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate() &&
                                    _formController
                                        .firstName!.text.isNotEmpty) {
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
                                      phoneNumber:
                                          PhoneNumberHandler.formatPhoneNumber(
                                              _formController.phoneNumber!.text
                                                ..replaceAll(" ", "")),
                                      password: _formController.password!.text,
                                    );

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
                      ),
                    );
                  },
                ),
              ),
            ],
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
