import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/utils/formuar_controller.dart';
import 'package:immoplus/app/utils/formular_utils.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:immoplus/app/widgets/custom_text_field.dart';

class NamePasswordRegistration extends StatelessWidget {
  NamePasswordRegistration({
    super.key,
    required this.formController,
    required this.formKey,
    required this.pageController,
  });

  final FormController formController;
  final ValueNotifier<bool> _passwordNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _passwordConfirmNotifier =
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
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            spacing: 30,
            children: [
              Gap(30),
              CustomTextField(
                controller: formController.firstName,
                prefixIcon: const FaIcon(FontAwesomeIcons.user),
                labelText: "Nom",
                validator: (String? value) =>
                    FormUtils.fieldValidator(value: value),
              ),
              CustomTextField(
                controller: formController.lastName,
                prefixIcon: const FaIcon(FontAwesomeIcons.user),
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
                    controller: formController.password,
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
                    validator: (String? value) =>
                        FormUtils.passwordValidator(password: value),
                  );
                },
              ),
              const Gap(10),
              ValueListenableBuilder<bool>(
                valueListenable: _passwordConfirmNotifier,
                builder: (BuildContext context, bool value, child) {
                  return CustomTextField(
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.visiblePassword,
                    prefixIcon: const Icon(CupertinoIcons.lock),
                    controller: formController.passwordConfirm,
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
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un mot de passe';
                      } else if (value != formController.password!.text) {
                        return 'Le mot de passe ne correspond pas';
                      }
                      return null;
                    },
                  );
                },
              ),
              CustomButtom(
                text: "Suivant",
                onClick: () {
                  if (formKey.currentState!.validate()) {
                    FocusScope.of(context).unfocus();
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
