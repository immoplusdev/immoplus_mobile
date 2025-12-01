// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/data/models/auth/update_user_dto.dart';
import 'package:immoplus/app/logic/authentification/login_cubit.dart';
import 'package:immoplus/app/logic/authentification/login_cubit_state.dart';
import 'package:immoplus/app/modules/files_uploader.dart/file_uploader.dart';
import 'package:immoplus/app/modules/files_uploader.dart/file_uploader_controller.dart';
import 'package:immoplus/app/utils/formuar_controller.dart';
import 'package:immoplus/app/utils/formular_utils.dart';
import 'package:immoplus/app/widgets/custom_loading_button.dart';
import 'package:immoplus/app/widgets/custom_text_field.dart';
import 'package:immoplus/app/widgets/international_phone_number_input.dart';

class EditAccountPage extends StatefulWidget {
  const EditAccountPage({super.key});
  static String name = 'EDIT_ACCOUNT';

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  final sessionManager = getIt<SessionManager>();
  late FileUploaderController fileUploaderController;
  late FormController _formController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();

  getCity({required Widget child}) {
    _focusNode.unfocus();
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  bool isPhoneNumberValid = false;
  String phoneNumber = '';
  void onInputValidated(bool isValid) {
    setState(() {
      isPhoneNumberValid = isValid;
    });
  }

  @override
  void initState() {
    phoneNumber = sessionManager.currentUser!.phoneNumber ?? '';
    sessionManager.currentUser;
    _focusNode.unfocus();
    fileUploaderController = FileUploaderController();
    _formController = FormController(
      productId: 0,
      firstName:
          TextEditingController(text: sessionManager.currentUser!.firstName),
      lastName:
          TextEditingController(text: sessionManager.currentUser!.lastName),
      phoneNumber:
          TextEditingController(text: sessionManager.currentUser!.phoneNumber),
      email: TextEditingController(text: sessionManager.currentUser!.email),
    );

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginCubit>(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Modifier mes informations'),
          //backgroundColor: Colors.red,
          //backgroundColor: Theme.of(context).colorScheme.primaryVariant,

          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.chevron_left,
              size: 30,
            ),
            onPressed: () async {
              context.pop();
            },
          ),

          centerTitle: true,
        ),
        body: SafeArea(
          child: BlocBuilder<LoginCubit, LoginCubitState>(
            builder: (context, state) {
              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: SizedBox(
                  width: double.infinity,
                  //color: Theme.of(context).colorScheme.primary,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FileUploader(
                          fileUploaderController: fileUploaderController,
                          title: "photo de profil",
                          placeholderImageId:
                              sessionManager.currentUser!.avatar,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        CustomTextField(
                          controller: _formController.firstName,
                          prefixIcon: const Icon(CupertinoIcons.person),
                          labelText: 'Nom',
                          validator: (String? value) =>
                              FormUtils.fieldValidator(value: value),
                        ),
                        CustomTextField(
                          controller: _formController.lastName,
                          prefixIcon: const Icon(CupertinoIcons.person),
                          labelText: 'Prénom',
                          validator: (String? value) =>
                              FormUtils.fieldValidator(value: value),
                        ),
                        InternationalPhoneInput(
                          initialPhoneNumber:
                              sessionManager.currentUser!.phoneNumber,
                          onValidPhoneNumber: (value) {
                            phoneNumber = value;
                            // Le numéro valide est traité ici si nécessaire
                            // print(phoneNumber);
                          },
                          onInputValidated: onInputValidated,
                          isEnabled: false,
                        ),
                        const Gap(10),
                        CustomTextField(
                          controller: _formController.email,
                          prefixIcon: const Icon(CupertinoIcons.mail),
                          labelText: 'Email',
                          isEnabled: false,
                          textInputType: TextInputType.emailAddress,
                          validator: (String? value) =>
                              FormUtils.emailValidator(email: value),
                        ),
                        const SizedBox(
                          height: 300,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: Container(
          height: 100,
          padding: const EdgeInsets.all(10.0),
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: BlocBuilder<LoginCubit, LoginCubitState>(
            builder: (context, state) {
              return CustomLoadingButtom(
                isLoading: (state is LOGIN_LOADING),
                onClick: ((state is LOGIN_LOADING))
                    ? null
                    : () async {
                        String? avatar;
                        inspect(fileUploaderController);
                        if (fileUploaderController.file != null) {
                          avatar = await uploadFile(
                              file: fileUploaderController.file!);
                        }

                        if (_formKey.currentState!.validate() &&
                            isPhoneNumberValid) {
                          FocusScope.of(context).unfocus();

                          final body = UpdateUserDto(
                            firstName: _formController.firstName!.text,
                            lastName: _formController.lastName!.text,
                            email: _formController.email!.text,
                            avatar:
                                avatar ?? sessionManager.currentUser!.avatar,
                            phoneNumber: phoneNumber,
                          );

                          context.read<LoginCubit>().updateUserData(
                                body: body,
                              );
                        }
                      },
                text: "Modifier",
              );
            },
          ),
        ),
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
