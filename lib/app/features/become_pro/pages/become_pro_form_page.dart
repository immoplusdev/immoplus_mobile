import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/configs/app_typography.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:immoplus/app/features/become_pro/logic/become_pro_cubit.dart';
import 'package:immoplus/app/features/become_pro/logic/become_pro_state.dart';
import 'package:immoplus/app/core/services/image_picker_service.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/widgets/app_dialog.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:immoplus/gen/assets.gen.dart';

class BecomeProFormPage extends StatefulWidget {
  const BecomeProFormPage({super.key});

  static const String name = 'BECOME_PRO_FORM_PAGE';

  @override
  State<BecomeProFormPage> createState() => _BecomeProFormPageState();
}

class _BecomeProFormPageState extends State<BecomeProFormPage> {
  final List<String> _secteurs = [
    'Immobilier',
    'Aménagement et décoration',
    'BTP & Construction',
    'Promotion immobilière',
    'Autre',
  ];
  String? _selectedSecteur;

  File? _pieceIdentiteFile;
  File? _photoIdentiteFile;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BecomeProCubit(),
      child: BlocConsumer<BecomeProCubit, BecomeProState>(
        listener: (context, state) {
          if (state is BecomeProSuccess) {
            AppDialog.info(
              barrierDismissible: false,
              content: "Votre demande a été envoyée avec succès.",
              icon: const Text("Succès", style: TextStyle(color: Colors.green)),
              textButton: "Fermer",
              rollback: () {
                while (context.canPop()) {
                  context.pop();
                }
              },
            );
          } else if (state is BecomeProFailure) {
            //
          }
        },
        builder: (context, state) {
          final isSubmitting = _isLoading || state is BecomeProLoading;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => context.pop(),
              ),
              systemOverlayStyle: SystemUiOverlayStyle.dark,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title
                    Text(
                      "Créer votre compte\nprofessionnel",
                      textAlign: TextAlign.center,
                      style: AppTypography.h2.copyWith(
                        color: AppColors.textPrimaryDark,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Subtitle
                    Text(
                      "Veuillez renseigner vos informations afin de vérifier\nvotre identité.",
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondaryMedium,
                      ),
                    ),
                    const SizedBox(height: 32),

                    const Divider(
                        color: AppColors.borderLightGray, thickness: 1),
                    const SizedBox(height: 24),

                    // Section Document
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Document d'identité",
                        style: AppTypography.titleSmall.copyWith(
                          color: AppColors.textPrimaryDark,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Two Upload Buttons Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildUploadCard(
                            label: "Photo de pièces d'identité :",
                            icon: Assets.svgs.icons.directInbox,
                            actionText:
                                "Téléverser votre pièce\nd'identité (recto / verso)",
                            file: _pieceIdentiteFile,
                            onTap: () async {
                              final file = await ImagePickerService.pickImage(
                                context: context,
                                source: ImageSource.gallery,
                                imageQuality: 40,
                              );
                              if (file != null) {
                                setState(() {
                                  _pieceIdentiteFile = file;
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildUploadCard(
                            label: "Photo d'identité :",
                            icon: Assets.svgs.icons.galleryImport,
                            actionText: "Ajouter une photo\nd'identité",
                            file: _photoIdentiteFile,
                            onTap: () async {
                              final file = await ImagePickerService.pickImage(
                                context: context,
                                source: ImageSource.gallery,
                                imageQuality: 40,
                              );
                              if (file != null) {
                                setState(() {
                                  _photoIdentiteFile = file;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Secteur d'activité Dropdown
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Secteur d'activité :",
                        style: AppTypography.bodySmallMedium.copyWith(
                          color: AppColors.textSecondaryMedium,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderLightGray),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: const Row(
                            children: [
                              Icon(Iconsax.briefcase,
                                  color: AppColors.textSecondaryMedium,
                                  size: 18),
                              SizedBox(width: 12),
                              Text("Sélectionner un secteur"),
                            ],
                          ),
                          value: _selectedSecteur,
                          icon: const Icon(Icons.keyboard_arrow_down,
                              color: AppColors.textSecondaryMedium),
                          style: AppTypography.bodyMediumMedium.copyWith(
                            color: AppColors.textPrimaryDark,
                          ),
                          items: _secteurs.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  const Icon(Iconsax.briefcase,
                                      color: AppColors.textSecondaryMedium,
                                      size: 18),
                                  const SizedBox(width: 12),
                                  Text(value),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedSecteur = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Info Security Box
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.infoBgSoftBlue,
                        borderRadius: BorderRadius.circular(8),
                        border: const Border(
                          left: BorderSide(
                              color: AppColors.infoBorderBlue, width: 3),
                        ),
                      ),
                      child: Text(
                        "Tous vos documents sont sécurisés et utilisés uniquement pour la validation de votre compte.",
                        style: AppTypography.bodySmall.copyWith(
                          color: const Color(0xFF475467),
                        ),
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Passing Pro Button
                    CustomButtom(
                      text: "Passer pro",
                      // color: AppColors.gradientTop,
                      isLoading: isSubmitting,
                      borderRadius: BorderRadius.circular(28),
                      onClick: () async {
                        if (_pieceIdentiteFile == null ||
                            _photoIdentiteFile == null ||
                            _selectedSecteur == null) {
                          AppDialog.info(
                            barrierDismissible: true,
                            content:
                                "Veuillez remplir tous les champs et téléverser les documents.",
                            icon: const Text("Attention"),
                            textButton: "Compris",
                          );
                          return;
                        }

                        setState(() => _isLoading = true);
                        try {
                          final String? idPiece =
                              await uploadFile(file: _pieceIdentiteFile!);
                          final String? idPhoto =
                              await uploadFile(file: _photoIdentiteFile!);

                          if (idPiece != null && idPhoto != null) {
                            if (context.mounted) {
                              context.read<BecomeProCubit>().submitDemande(
                                    activite: _selectedSecteur!,
                                    photoIdentiteId: idPhoto,
                                    pieceIdentiteId: idPiece,
                                  );
                            }
                          }
                        } catch (e) {
                          AppDialog.info(
                            barrierDismissible: true,
                            content: "Erreur lors de l'envoi des fichiers.",
                            icon: const Text("Erreur"),
                            textButton: "Compris",
                          );
                        } finally {
                          if (mounted) {
                            setState(() => _isLoading = false);
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUploadCard({
    required String label,
    required String icon,
    required String actionText,
    required VoidCallback onTap,
    File? file,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodySmallMedium.copyWith(
            color: AppColors.textSecondaryMedium,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.borderMediumGray,
                width: 1,
                style: BorderStyle.none,
              ),
            ),
            child: Stack(
              children: [
                if (file != null)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        file,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else ...[
                  // Soft blue background
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: AppColors.borderSoftBlue,
                          width: 2),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          icon,
                          colorFilter: const ColorFilter.mode(
                            AppColors.infoBorderBlue,
                            BlendMode.srcIn,
                          ),
                          width: 28,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          actionText,
                          textAlign: TextAlign.center,
                          style: AppTypography.micro.copyWith(
                            color: AppColors.infoBorderBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
