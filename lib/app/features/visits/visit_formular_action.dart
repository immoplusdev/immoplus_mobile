import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/demande_visit_request_body.dart';
import 'package:immoplus/app/features/visits/logic/visit_cubit.dart';
import 'package:immoplus/app/features/visits/logic/visit_request_state.dart';
import 'package:immoplus/app/features/visits/widgets/product_info.dart';
import 'package:immoplus/app/features/visits/widgets/visit_listtile_action.dart';
import 'package:immoplus/app/modules/country_phone_number/country_phone_number.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/formuar_controller.dart';
import 'package:immoplus/app/utils/toast_utils.dart';
import 'package:immoplus/app/widgets/bottom_immoplus.dart';
import 'package:immoplus/app/widgets/client_service_chip.dart';

class VisitFormularAction extends StatefulWidget {
  const VisitFormularAction({super.key, required this.bienImmoModel});
  final BienImmobilierModel bienImmoModel;
  @override
  State<VisitFormularAction> createState() => _VisitFormularActionState();
}

class _VisitFormularActionState extends State<VisitFormularAction> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late FormController _formController;
  final sessionManager = getIt<SessionManager>();

  String time = '';
  @override
  void initState() {
    super.initState();
    _formController = FormController(
      productId: 0,
      firstName:
          TextEditingController(text: sessionManager.currentUser!.firstName),
      lastName:
          TextEditingController(text: sessionManager.currentUser!.lastName),
      phoneNumber:
          TextEditingController(text: sessionManager.currentUser!.number),
      email: TextEditingController(text: sessionManager.currentUser!.email),
      placeLoading: TextEditingController(),
      placeUnloading: TextEditingController(),
      startWishedDate: TextEditingController(),
      endWishedDate: TextEditingController(),
      address: TextEditingController(text: ''),
      payementType: TextEditingController(text: 'cash'),
    );
  }

  String get phoneNumberWithCountryCode {
    return "225${_formController.phoneNumber?.text}";
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VisitCubit, VisitRequestState>(
      listener: (context, state) {
        state.when(
          loadingList: () {},
          initial: () {},
          loading: () {
            // Optionnel : Afficher un loading dans la popup
          },
          receive: (data) {
            // Fermer la popup
            // context.pop();
            // Afficher un message de succès

            ToastUtils.success('Demande de visite envoyée');
            context.pop();
            context.pop();
            // context.pushNamed(
            //   OperatorsSelectorPage.name,
            //   extra: PaymentPageAdapter(
            //     itemId: data.id,
            //     collection: "demandes_visites",
            //     amount: data.montantTotalDemandeVisite.toInt(),
            //   ),
            // );
          },
          error: (message) {
            // Fermer la popup
            context.pop();
            // Afficher le message d'erreur
            // ToastUtils.error(message);
          },
          receiveId: (data) {},
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.scafold,
        appBar: AppBar(
          backgroundColor: AppColors.scafold,
          automaticallyImplyLeading: true,
          title: const Text('Demande de visite'),
          actions: const [
            ClientServiceChip(),
            Gap(8),
            // IconButton(
            //     onPressed: () {
            //       ContactUtils(productDetailModel: ProductDetailModel())
            //           .showDialog(context: context);
            //     },
            //     icon: Icon(CupertinoIcons.phone))
          ],
        ),
        //backgroundColor: Colors.white,
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Article"),
                  const Gap(10),
                  ProductInfo(
                    bienImmobilierModel: widget.bienImmoModel,
                  ),
                  const Gap(30),
                  // Text("Vos information"),
                  // PersonalInfoEditor(formController: _formController),
                  CountryPhoneNumberInput(
                      controller: _formController.phoneNumber!),

                  Text(
                    "Numéro de téléphone sur lequel vous préférez être contacté, de préférence un numéro WhatsApp actif.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inder(
                      fontSize: 14,
                      color: AppColors.primary,
                    ),
                  ),
                  const Divider(),
                  const Gap(30),
                  const Text("Type de demande de visite"),
                  const Gap(10),
                  VisitListTileAction(
                    backgroundImage:
                        const AssetImage('assets/icon/express.webp'),
                    price:
                        (sessionManager.configModel?.data?.expressVisitPrice ??
                                "_")
                            .toString(),
                    title: 'Visite Expresse',
                    subTiltle:
                        "Vous serez programmé le plus vite possible voire le même jour pour la visite et un véhicule sera mis à votre disposition pour le transport.",
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        _formController.setServiceOption = 'express';
                        showCupertinoModalPopup<void>(
                          context: context,
                          builder: (BuildContext context) =>
                              CupertinoAlertDialog(
                            //title: const Text('Alert'),
                            content: const Text(
                                'Confirmez-vous cette demande de visite expresse ?'),
                            actions: <CupertinoDialogAction>[
                              CupertinoDialogAction(
                                isDefaultAction: false,
                                isDestructiveAction: true,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Annuer'),
                              ),
                              CupertinoDialogAction(
                                isDefaultAction: true,
                                isDestructiveAction: false,
                                onPressed: () {
                                  context.read<VisitCubit>().visitRequest(
                                      body: DemandeVisitRequestBody(
                                          bienImmobilier:
                                              widget.bienImmoModel.id,
                                          typeDemandeVisite:
                                              TypeDemandeVisite.express.name,
                                          clientPhoneNumber:
                                              phoneNumberWithCountryCode));
                                },
                                child: const Text('Confirmer'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                  const Gap(30),
                  VisitListTileAction(
                    backgroundImage: const AssetImage(
                      'assets/icon/normal.png',
                    ),
                    price:
                        (sessionManager.configModel?.data?.normalVisitPrice ??
                                "_")
                            .toString(),
                    title: 'Visite normale',
                    subTiltle:
                        "Vous serez programmé pour la visite et nous vous notifierons le jour et l'heure de votre passage.",
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        _formController.setServiceOption = 'normal';
                        showCupertinoModalPopup<void>(
                          context: context,
                          builder: (BuildContext context) =>
                              CupertinoAlertDialog(
                            //title: const Text('Alert'),
                            content: const Text(
                                'Confirmez-vous cette demande de visite standard ?'),
                            actions: <CupertinoDialogAction>[
                              CupertinoDialogAction(
                                isDefaultAction: false,
                                isDestructiveAction: true,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Annuer'),
                              ),
                              CupertinoDialogAction(
                                isDefaultAction: true,
                                isDestructiveAction: false,
                                onPressed: () {
                                  context.read<VisitCubit>().visitRequest(
                                      body: DemandeVisitRequestBody(
                                          bienImmobilier:
                                              widget.bienImmoModel.id,
                                          typeDemandeVisite:
                                              TypeDemandeVisite.normal.name,
                                          clientPhoneNumber:
                                              phoneNumberWithCountryCode));
                                },
                                child: const Text('Confirmer'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const BottomImmoPlus(),
      ),
    );
  }
}
