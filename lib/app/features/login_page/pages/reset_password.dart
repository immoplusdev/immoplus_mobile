import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/features/login_page/login_page.dart';
import 'package:immoplus/app/utils/formular_utils.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:immoplus/app/widgets/custom_text_field.dart';

class ResetPassword extends StatelessWidget {
  ResetPassword({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final sessionManager = getIt<SessionManager>();
  final TextEditingController _controllerEmail =
      TextEditingController(text: getIt<SessionManager>().currentUser!.email);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        // leading: IconButton(
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //     icon: Icon(CupertinoIcons.chevron_back)),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.only(left: 25, right: 25),
          //color: Theme.of(context).colorScheme.primary,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/logo_immo.svg',
                    color: HexColor('#2072ca'),
                    width: 110,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Modifiez votre mot de passe',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Card(
                    color: Colors.grey[200],
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      height: 55,
                      child: const Center(
                        child: Text(
                          'Nous vous enverrons un mail de réinitialisation',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    prefixIcon: const Icon(CupertinoIcons.mail),
                    labelText: 'Email',
                    controller: _controllerEmail,
                    textInputType: TextInputType.emailAddress,
                    validator: (String? value) => FormUtils.emailValidator(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                              (route) => false,
                            );
                          },
                          child: Text(
                            'Se connecter',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                          ))
                    ],
                  ),
                  CustomButtom(
                      color: Theme.of(context).colorScheme.primary,
                      textColor: Colors.white,
                      onClick: () {
                        // Validate will return true if the form is valid, or false if
                        // the form is invalid.
                        if (_formKey.currentState!.validate()) {
                          // Process data.

                          // showModalBottomSheet<void>(
                          //   isDismissible: false,
                          //   isScrollControlled: false,
                          //   shape: const RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.only(
                          //           topLeft: Radius.circular(30),
                          //           topRight: Radius.circular(30))),
                          //   backgroundColor: Colors.white,
                          //   context: context,
                          //   builder: (BuildContext context) {
                          //     context.read<AccountBloc>().add(
                          //         AccountUpdatePassWordEvent(body: _formData));
                          //     return Container(
                          //       padding: const EdgeInsets.only(top: 1),
                          //       decoration: const BoxDecoration(
                          //           borderRadius: BorderRadius.only(
                          //               topLeft: Radius.circular(30),
                          //               topRight: Radius.circular(30))),
                          //       height:
                          //           MediaQuery.of(context).size.height - 250,
                          //       child: Scaffold(
                          //         backgroundColor: Colors.transparent,
                          //         appBar: AppBar(
                          //           backgroundColor: Colors.transparent,
                          //           automaticallyImplyLeading: false,
                          //           actions: [
                          //             IconButton(
                          //               onPressed: () {
                          //                 Navigator.pop(context);
                          //               },
                          //               icon: Icon(
                          //                 Icons.cancel,
                          //                 color: Theme.of(context)
                          //                     .colorScheme
                          //                     .onSecondary,
                          //               ),
                          //             )
                          //           ],
                          //           elevation: 0,
                          //         ),
                          //         body: SingleChildScrollView(
                          //             padding: EdgeInsets.all(10),
                          //             child: BlocBuilder<AccountBloc,
                          //                 AccountState>(
                          //               builder: (context, state) {
                          //                 return (state
                          //                         is AccounReadyMessageState)
                          //                     ? Container(
                          //                         //color: Colors.amber,
                          //                         width: double.infinity,
                          //                         height: 300,
                          //                         child: Column(
                          //                           crossAxisAlignment:
                          //                               CrossAxisAlignment
                          //                                   .center,
                          //                           mainAxisAlignment:
                          //                               MainAxisAlignment
                          //                                   .center,
                          //                           children: [
                          //                             Text(
                          //                               state.status,
                          //                               textAlign:
                          //                                   TextAlign.center,
                          //                               style: const TextStyle(
                          //                                 fontWeight:
                          //                                     FontWeight.bold,
                          //                                 fontSize: 17,
                          //                               ),
                          //                             ),
                          //                             const SizedBox(
                          //                               height: 20,
                          //                             ),
                          //                             CustomButtom(
                          //                               text: 'Continuer',
                          //                               onClick: () {
                          //                                 Navigator.pop(
                          //                                     context);
                          //                               },
                          //                             ),
                          //                           ],
                          //                         ),
                          //                       )
                          //                     : (state is AccountPendingState)
                          //                         ? SizedBox(
                          //                             //color: Colors.red,
                          //                             //width: double.infinity,
                          //                             height: 300,
                          //                             child: Center(
                          //                               child:
                          //                                   CupertinoActivityIndicator(
                          //                                 color:
                          //                                     Theme.of(context)
                          //                                         .colorScheme
                          //                                         .onSecondary,
                          //                                 radius: 20,
                          //                               ),
                          //                             ),
                          //                           )
                          //                         : Container();
                          //               },
                          //             )),
                          //       ),
                          //     );
                          //   },
                          // );
                        }
                      },
                      text: "Rénitialiser")
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
