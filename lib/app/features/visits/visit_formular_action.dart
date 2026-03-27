import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
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
import 'package:immoplus/app/widgets/app_dialog.dart';
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
  String? _selectedType; // 'express' | 'normal'

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
    super.dispose();
  }

  void _showConfirmDialog({
    required String type,
    required String message,
    required TypeDemandeVisite typeDemandeVisite,
  }) {
    if (!_formKey.currentState!.validate()) return;

    _formController.setServiceOption = type;

    AppDialog.show(
      title: 'Confirmation',
      description: message,
      primaryButtonText: 'Confirmer',
      secondButtonText: 'Annuler',
      onPrimary: () => context.read<VisitCubit>().visitRequest(
            body: DemandeVisitRequestBody(
              bienImmobilier: widget.bienImmoModel.id,
              typeDemandeVisite: typeDemandeVisite.name,
              clientPhoneNumber: phoneNumberWithCountryCode,
            ),
          ),
    );
    
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return BlocListener<VisitCubit, VisitRequestState>(
      listener: (context, state) {
        state.when(
          loadingList: () {},
          initial: () {},
          loading: () {},
          receive: (data) {
            // ToastUtils.success('Demande de visite envoyée');
            context.pop();
            context.pop();
          },
          error: (message) {
            context.pop();
          },
          receiveId: (data) {},
        );
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text(
            'Demande de visite',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          // actions: const [
          //   ClientServiceChip(),
          //   Gap(12),
          // ],
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Section Article ──
                  _SectionLabel(title: 'Bien concerné', icon: Iconsax.home_hashtag, color: primaryColor),
                  const Gap(10),
                  ProductInfo(bienImmobilierModel: widget.bienImmoModel),

                  const Gap(28),

                  // ── Section Contact ──
                  _SectionLabel(title: 'Contact', icon: Iconsax.call, color: primaryColor),
                  const Gap(10),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        CountryPhoneNumberInput(
                          controller: _formController.phoneNumber!,
                        ),
                        const Gap(12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Icon(
                                  Iconsax.info_circle,
                                  size: 16,
                                  color: primaryColor,
                                ),
                              ),
                              const Gap(8),
                              Expanded(
                                child: Text(
                                  "Numéro sur lequel vous préférez être contacté, de préférence un numéro WhatsApp actif.",
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: primaryColor,
                                    height: 1.45,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Gap(28),

                  // ── Section Type de visite ──
                  _SectionLabel(title: 'Type de demande de visite', icon: Iconsax.routing_2, color: primaryColor),
                  const Gap(10),

                  VisitListTileAction(
                    icon: Iconsax.flash,
                    price: (sessionManager.configModel?.data?.expressVisitPrice ?? "_").toString(),
                    title: 'Visite Express',
                    subtitle:
                        "Votre visite sera planifiée dans les plus brefs délais, avec possibilité d'intervention le jour même.",
                    onTap: () => _showConfirmDialog(
                      type: 'express',
                      message: 'Confirmez-vous cette demande de visite expresse ?',
                      typeDemandeVisite: TypeDemandeVisite.express,
                    ),
                  ),

                  const Gap(14),

                  VisitListTileAction(
                    icon: Iconsax.calendar_search,
                    price: (sessionManager.configModel?.data?.normalVisitPrice ?? "_").toString(),
                    title: 'Visite normale',
                    subtitle:
                        "Vous serez programmé pour la visite et nous vous notifierons la date et l'heure de votre passage.",
                    onTap: () => _showConfirmDialog(
                      type: 'normal',
                      message: 'Confirmez-vous cette demande de visite standard ?',
                      typeDemandeVisite: TypeDemandeVisite.normal,
                    ),
                  ),

                  const Gap(30),
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

// ── Widget réutilisable pour les labels de section ──
class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.title,
    required this.icon,
    required this.color,
  });

  final String title;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Icon(icon, size: 18, color: color),
        // const Gap(6),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}