import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/data/models/auth/customer_registration_body.dart';
import 'package:immoplus/app/data/models/remote/files/file_data_model.dart';
import 'package:immoplus/app/features/account/widgets/general_condition_page.dart';
import 'package:immoplus/app/logic/authentification/registration_cubit.dart';
import 'package:immoplus/app/logic/authentification/registration_cubit_state.dart';
import 'package:immoplus/app/modules/files_uploader.dart/file_uploader.dart';
import 'package:immoplus/app/modules/files_uploader.dart/file_uploader_controller.dart';
import 'package:immoplus/app/utils/formuar_controller.dart';
import 'package:immoplus/app/utils/formular_utils.dart';
import 'package:immoplus/app/utils/phone_number_handler.dart';
import 'package:immoplus/app/widgets/custom_loading_button.dart';
import 'package:immoplus/app/widgets/custom_popup.dart';
import 'package:immoplus/app/widgets/custom_text_field.dart';
import 'package:immoplus/app/widgets/international_phone_number_input.dart';

class NumberEmailRegistration extends StatelessWidget {
  NumberEmailRegistration(
      {super.key,
      required this.formController,
      required this.formKey,
      required this.fileUploaderControllerPhotoIdentite});
  final FormController formController;
  final GlobalKey<FormState> formKey;

  final ValueNotifier<bool> _cguNotifier = ValueNotifier<bool>(false);
  final FileUploaderController fileUploaderControllerPhotoIdentite;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          const Gap(50),
          CustomTextField(
            controller: formController.email,
            prefixIcon: const Icon(CupertinoIcons.mail),
            labelText: 'Email',
            textInputType: TextInputType.emailAddress,
            validator: (String? value) =>
                FormUtils.emailValidator(email: value),
          ),
          SizedBox(
            child: InternationalPhoneInput(
              onValidPhoneNumber: (value) {
                //phoneNumber = value;
                if (value != formController.phoneNumber!.text) {
                  formController.phoneNumber!.text = value;
                }

                // Le numéro valide est traité ici si nécessaire
                // print(phoneNumber);
              },
              onInputValidated: (p0) {},
              validator: (String? value) =>
                  FormUtils.numberValidator(number: value),
            ),
          ),
          const Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: FileUploader(
                  width: 150,
                  height: 130,
                  fileUploaderController: fileUploaderControllerPhotoIdentite,
                  title: "Photo de profile",
                  iconPlaceholder: FontAwesomeIcons.idBadge,
                ),
              ),
            ],
          ),
          const Gap(10),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const GeneralConditionPage(),
                            ));
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
          const Gap(20),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: BlocBuilder<RgistrationCubitCubit, RegistrationCubitState>(
              builder: (context, state) {
                return CustomLoadingButtom(
                  isLoading: (state is REGISTRATION_LOADING),
                  onClick: ((state is REGISTRATION_LOADING))
                      ? null
                      : () async {
                          if (formKey.currentState!.validate() &&
                              formController.firstName!.text.isNotEmpty) {
                            if (!_cguNotifier.value) {
                              CustomPopup.toast(
                                  text:
                                      "Les Conditions d'utilisation ne sont pas approuvées",
                                  toastPosition:
                                      EasyLoadingToastPosition.bottom);
                            } else {
                              String? fileId;
                              if (fileUploaderControllerPhotoIdentite.file !=
                                  null) {
                                CustomPopup.showLoagingToast(
                                    text: "Envoi de l'image...");
                                FileDataModel fileDataModel =
                                    await fileUploaderControllerPhotoIdentite
                                        .upladFile();
                                fileId = fileDataModel.data!.id;
                                EasyLoading.dismiss();
                              }

                              final body = CustomerRegistrationBody(
                                avatar: fileId,
                                firstName: formController.firstName!.text,
                                lastName: formController.lastName!.text,
                                email: formController.email!.text,
                                phoneNumber:
                                    PhoneNumberHandler.formatPhoneNumber(
                                        formController.phoneNumber!.text
                                          ..replaceAll(" ", "")),
                                password: formController.password!.text,
                              );

                              context
                                  .read<RgistrationCubitCubit>()
                                  .createCustomerAccount(
                                    customerRegistrationBody: body,
                                  );
                            }
                          }

                          //context.go('/homePage');
                        },
                  text: "créer mon compte",
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
