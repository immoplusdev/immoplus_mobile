// ignore_for_file: use_build_context_synchronously

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/features/registration/screens/name_password_registration.dart';
import 'package:immoplus/app/features/registration/screens/number_email_registration.dart';
import 'package:immoplus/app/logic/authentification/registration_cubit.dart';
import 'package:immoplus/app/modules/files_uploader.dart/file_uploader_controller.dart';
import 'package:immoplus/app/routes/app_router.dart';
import 'package:immoplus/app/utils/formuar_controller.dart';

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
          backgroundColor: HexColor("#121224"),
          body: CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            //padding: const EdgeInsets.only(left: 15, right: 15),
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                backgroundColor: HexColor("#121224"),
                leadingWidth: 35,
                leading: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(40, 40),
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(3),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.white),
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      }
                    },
                    child: const Icon(
                      FontAwesomeIcons.chevronLeft,
                      color: Colors.black,
                    )),
                actions: [
                  SvgPicture.asset(
                    'assets/icons/logo_immo.svg',
                    color: HexColor('#2072ca'),
                    width: 50,
                  ),
                  const Gap(20),
                ],
              ),
              SliverToBoxAdapter(
                child: Center(
                  child: Text(
                    "Inscription",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Center(
                  child: AutoSizeText(
                    maxLines: 1,
                    "Veuillez renseigner les champs",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
              const SliverGap(50),
              SliverFillRemaining(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                  ),
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      NamePasswordRegistration(
                        formController: _formController,
                        formKey: _formKey,
                        pageController: _pageController,
                      ),
                      NumberEmailRegistration(
                          formController: _formController,
                          formKey: _formKey,
                          fileUploaderControllerPhotoIdentite:
                              fileUploaderControllerPhotoIdentite),
                    ],
                  ),
                ),
              )
            ],
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
