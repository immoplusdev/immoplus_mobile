import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/utils/formuar_controller.dart';
import 'package:immoplus/app/utils/formular_utils.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:immoplus/app/widgets/custom_text_field.dart';

class NamePasswordRegistration extends StatelessWidget {
  NamePasswordRegistration(
      {super.key,
      required this.formController,
      required this.formKey,
      required this.pageController});
  final FormController formController;
  final ValueNotifier<bool> _passwordNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _passworConfirmdNotifier =
      ValueNotifier<bool>(false);
  final GlobalKey<FormState> formKey;
  final PageController pageController;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: ClipRRect(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              const Gap(50),
              CustomTextField(
                controller: formController.firstName,
                prefixIcon: const Icon(FontAwesomeIcons.user),
                labelText: "Nom",
                validator: (String? value) =>
                    FormUtils.fieldValidator(value: value),
              ),
              const Gap(10),
              CustomTextField(
                controller: formController.lastName,
                prefixIcon: const Icon(FontAwesomeIcons.user),
                labelText: "Prénom",
                validator: (String? value) =>
                    FormUtils.fieldValidator(value: value),
              ),
              const Gap(10),
              ValueListenableBuilder<bool>(
                  valueListenable: _passwordNotifier,
                  builder: (BuildContext context, bool value, child) {
                    return CustomTextField(
                      prefixIcon: const Icon(CupertinoIcons.lock),
                      controller: formController.password,
                      obscureText: !_passwordNotifier.value,
                      sufixIcon: IconButton(
                          onPressed: () {
                            _passwordNotifier.value = !_passwordNotifier.value;
                          },
                          icon: Icon(
                            (value)
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                          )),
                      labelText: 'Mot de passe',
                      validator: (String? value) =>
                          FormUtils.passwordValidator(password: value),
                    );
                  }),
              const Gap(10),
              ValueListenableBuilder<bool>(
                  valueListenable: _passworConfirmdNotifier,
                  builder: (BuildContext context, bool value, child) {
                    return CustomTextField(
                      prefixIcon: const Icon(CupertinoIcons.lock),
                      obscureText: !_passworConfirmdNotifier.value,
                      sufixIcon: IconButton(
                          onPressed: () {
                            _passworConfirmdNotifier.value =
                                !_passworConfirmdNotifier.value;
                          },
                          icon: Icon(
                            (value)
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                          )),
                      labelText: 'Confirmation du mot de passe ',
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'veillez entrer un mot de passe';
                        } else if (value != formController.password!.text) {
                          return 'le mot de passe ne correspond pas';
                        }

                        return null;
                      },
                    );
                  }),
              const Gap(25),
              CustomButtom(
                text: "Suivant",
                onClick: () {
                  if (formKey.currentState!.validate()) {
                    pageController.nextPage(
                        duration: const Duration(microseconds: 500),
                        curve: Curves.bounceIn);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
