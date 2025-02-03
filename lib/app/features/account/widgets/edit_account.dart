import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/logic/authentification/login_cubit.dart';
import 'package:immoplus/app/logic/authentification/login_cubit_state.dart';
import 'package:immoplus/app/utils/formuar_controller.dart';
import 'package:immoplus/app/utils/formular_utils.dart';
import 'package:immoplus/app/widgets/custom_loading_button.dart';
import 'package:immoplus/app/widgets/custom_text_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EditAccount extends StatefulWidget {
  const EditAccount({super.key});

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  final sessionManager = getIt<SessionManager>();
  late FormController _formController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _passwordNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _passworConfirmdNotifier =
      ValueNotifier<bool>(false);
  final ValueNotifier<bool> _cguNotifier = ValueNotifier<bool>(false);
  final int _selectedCity = 0;
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

  @override
  void initState() {
    _focusNode.unfocus();

    _formController = FormController(
      productId: 0,
      firstName:
          TextEditingController(text: sessionManager.currentUser?.firstName),
      lastName:
          TextEditingController(text: sessionManager.currentUser?.firstName),
      // cityName: TextEditingController(
      //     text: ConfigModel.singleton.countries![0].cities![0].name),
      phoneNumber:
          TextEditingController(text: sessionManager.currentUser?.phoneNumber),
      email: TextEditingController(text: sessionManager.currentUser?.email),
    );
    // _formController.setCityCode =
    //     ConfigModel.singleton.countries![0].cities![0].id!;
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
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: SizedBox(
              width: double.infinity,
              //color: Theme.of(context).colorScheme.primary,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                    //BlocBuilder<GetCityData, CityModel>(
                    //   builder: (context, state) {
                    //     _formController.city!.text = state.name;
                    //     return CustomTextField(
                    //       prefixIcon: Icon(CupertinoIcons.building_2_fill),
                    //       focusNode: AlwaysDisabledFocusNode(),
                    //       controller: _formController.city,
                    //       labelText: 'Ville',
                    //       onTap: () {
                    //         sowModalCities(context);
                    //       },
                    //       validator: (String? value) =>
                    //           FormUtils.fieldValidator(value: value),
                    //     );
                    //   },
                    // ),
                    CustomTextField(
                      controller: _formController.phoneNumber,
                      textInputType: TextInputType.number,
                      labelText: 'Numéro de téléphone',
                      prefixIcon: const Icon(CupertinoIcons.phone),
                      validator: (String? value) =>
                          FormUtils.numberValidator(number: value),
                      inputFormatters: [
                        MaskTextInputFormatter(
                            mask: '+225 ##-##-##-##-##',
                            filter: {'#': RegExp(r'[0-9]')})
                      ],
                    ),
                    CustomTextField(
                      controller: _formController.email,
                      prefixIcon: const Icon(CupertinoIcons.mail),
                      labelText: 'Email',
                      textInputType: TextInputType.emailAddress,
                      validator: (String? value) =>
                          FormUtils.emailValidator(email: value),
                    ),
                    CustomTextField(
                      focusNode: _focusNode,
                      controller: _formController.cityName,
                      prefixIcon: const Icon(Icons.location_city_rounded),
                      labelText: 'Ville',
                      textInputType: TextInputType.emailAddress,
                      onTap: () {
                        // FocusScope.of(context).requestFocus(FocusNode());
                        // FocusManager.instance.primaryFocus?.unfocus();
                        // FocusScope.of(context).unfocus();
                        // getCity(
                        //   child: CupertinoPicker(
                        //     magnification: 1.22,
                        //     squeeze: 1.2,
                        //     useMagnifier: true,
                        //     itemExtent: 40,
                        //     // This sets the initial item.
                        //     scrollController: FixedExtentScrollController(
                        //       initialItem: _selectedCity,
                        //     ),
                        //     // This is called when selected item is changed.
                        //     onSelectedItemChanged: (int selectedItem) {
                        //       setState(() {
                        //         _selectedCity = selectedItem;
                        //         _formController.cityName!.text = ConfigModel
                        //             .singleton
                        //             .countries![0]
                        //             .cities![selectedItem]
                        //             .name!;
                        //         _formController.setCityCode = ConfigModel
                        //             .singleton
                        //             .countries![0]
                        //             .cities![selectedItem]
                        //             .id!;
                        //       });
                        //     },

                        //     children:
                        //         ConfigModel.singleton.countries![0].cities!
                        //             .map((e) => Center(
                        //                   child: Text(e.name ?? 'no'),
                        //                 ))
                        //             .toList(),
                        //   ),
                        // );
                      },
                      validator: (String? value) =>
                          FormUtils.fieldValidator(value: value),
                    ),

                    const SizedBox(
                      height: 300,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 100,
          padding: const EdgeInsets.all(10.0),
          child: BlocBuilder<LoginCubit, LoginCubitState>(
            builder: (context, state) {
              return CustomLoadingButtom(
                isLoading: (state is LOGIN_LOADING),
                onClick: ((state is LOGIN_LOADING))
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          // context.read<LoginCubit>().updateData(
                          //     formController: _formController,
                          //     context: context);
                        }

                        //context.go('/homePage');
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
