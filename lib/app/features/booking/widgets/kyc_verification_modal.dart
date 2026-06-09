import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:didit_sdk/sdk_flutter.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/repositories/kyc_repository.dart';
import 'package:immoplus/app/data/models/remote/kyc/kyc_session_model.dart';
import 'package:immoplus/app/data/models/remote/kyc/kyc_session_create_model.dart';
import 'package:immoplus/app/utils/toast_utils.dart';
import 'package:immoplus/app/widgets/custom_button.dart';

class KycVerificationModal extends StatefulWidget {
  final VoidCallback onSuccess;
  final KycSessionModel? initialKycSession;

  const KycVerificationModal({
    super.key,
    required this.onSuccess,
    this.initialKycSession,
  });

  static Future<void> show(BuildContext context,
      {required VoidCallback onSuccess, KycSessionModel? initialKycSession}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => KycVerificationModal(
        onSuccess: onSuccess,
        initialKycSession: initialKycSession,
      ),
    );
  }

  @override
  State<KycVerificationModal> createState() => _KycVerificationModalState();
}

class _KycVerificationModalState extends State<KycVerificationModal> {
  final _kycRepository = getIt<KycRepository>();
  // final _picker = ImagePicker();

  // String _selectedDocumentType = 'national_id'; // 'national_id' or 'passport'
  // File? _frontFile;
  // File? _backFile;
  bool _isLoading = false;

  // Future<void> _pickImage(bool isFront) async {
  //   showCupertinoModalPopup(
  //     context: context,
  //     builder: (context) => CupertinoActionSheet(
  //       title: const Text("Sélectionner une photo"),
  //       actions: [
  //         CupertinoActionSheetAction(
  //           onPressed: () async {
  //             Navigator.pop(context);
  //             final pickedFile = await _picker.pickImage(
  //               source: ImageSource.camera,
  //               imageQuality: 80,
  //             );
  //             if (pickedFile != null) {
  //               setState(() {
  //                 if (isFront) {
  //                   _frontFile = File(pickedFile.path);
  //                 } else {
  //                   _backFile = File(pickedFile.path);
  //                 }
  //               });
  //             }
  //           },
  //           child: const Text("Prendre une photo"),
  //         ),
  //         CupertinoActionSheetAction(
  //           onPressed: () async {
  //             Navigator.pop(context);
  //             final pickedFile = await _picker.pickImage(
  //               source: ImageSource.gallery,
  //               imageQuality: 80,
  //             );
  //             if (pickedFile != null) {
  //               setState(() {
  //                 if (isFront) {
  //                   _frontFile = File(pickedFile.path);
  //                 } else {
  //                   _backFile = File(pickedFile.path);
  //                 }
  //               });
  //             }
  //           },
  //           child: const Text("Choisir depuis la galerie"),
  //         ),
  //       ],
  //       cancelButton: CupertinoActionSheetAction(
  //         isDefaultAction: true,
  //         onPressed: () => Navigator.pop(context),
  //         child: const Text("Annuler"),
  //       ),
  //     ),
  //   );
  // }

  // void _removeImage(bool isFront) {
  //   setState(() {
  //     if (isFront) {
  //       _frontFile = null;
  //     } else {
  //       _backFile = null;
  //     }
  //   });
  // }

  // Future<void> _submitManual() async {
  //   if (_isLoading) return;
  //   if (_frontFile == null) {
  //     ToastUtils.showError(
  //         description: "Veuillez ajouter la photo du recto de votre document.");
  //     return;
  //   }
  //   if (_selectedDocumentType == 'national_id' && _backFile == null) {
  //     ToastUtils.showError(
  //         description: "Veuillez ajouter la photo du verso de votre document.");
  //     return;
  //   }

  //   setState(() => _isLoading = true);

  //   try {
  //     await _kycRepository.verifyKyc(
  //       documentType: _selectedDocumentType,
  //       frontFile: _frontFile!,
  //       backFile: _selectedDocumentType == 'national_id' ? _backFile : null,
  //     );

  //     if (mounted) {
  //       Navigator.pop(context);
  //       ToastUtils.showSuccess(
  //         description: "Vos documents d'identité ont été soumis avec succès.",
  //       );
  //       widget.onSuccess();
  //     }
  //   } catch (e) {
  //     ToastUtils.showError(
  //       description:
  //           "Une erreur est survenue lors de la soumission. Veuillez réessayer.",
  //     );
  //   } finally {
  //     if (mounted) {
  //       setState(() => _isLoading = false);
  //     }
  //   }
  // }

  Future<void> _startDiditVerification() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      String token = widget.initialKycSession?.token ?? '';

      if (token.isEmpty) {
        log("No valid session token found, calling createKycSession");
        final sessionCreate = await _kycRepository.createKycSession();
        token = sessionCreate.token;
      }

      if (token.isEmpty) {
        throw Exception("Session token was empty");
      }

      log("_startDiditVerification $token");

      // 2. Launch Didit SDK
      final result = await DiditSdk.startVerification(
        token,
        config: DiditConfig(
          languageCode: 'fr',
          loggingEnabled: true,
        ),
      );

      // 3. Handle results
      switch (result) {
        case VerificationCompleted(:final session):
          if (session.status == VerificationStatus.approved) {
            if (mounted) {
              Navigator.pop(context);
              ToastUtils.showSuccess(
                  description: "Vérification d'identité approuvée !");
              widget.onSuccess();
            }
          } else {
            if (mounted) {
              Navigator.pop(context);
              ToastUtils.showSuccess(
                description:
                    "Votre vérification d'identité a été complétée et est en cours d'examen.",
              );
              widget.onSuccess();
            }
          }
          break;
        case VerificationCancelled():
          ToastUtils.showError(description: "Vérification Didit annulée.");
          break;
        case VerificationFailed(:final error):
          log("Didit Verification Failed - Type: ${error.type}, Message: ${error.message}");
          ToastUtils.showError(
              description:
                  "Échec de la vérification Didit [${error.type}]: ${error.message}");
          break;
      }
    } catch (e, s) {
      log("Error: $e $s");
      ToastUtils.showError(
        description:
            "Impossible de démarrer la vérification automatisée. Veuillez utiliser le formulaire manuel.",
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Gap(10),
                      // Title
                      const Text(
                        "Vérifier votre identité",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1D2939),
                        ),
                      ),
                      const Gap(8),
                      // Subtitle
                      const Text(
                        "Veuillez renseigner vos informations afin de vérifier votre identité.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF667085),
                          height: 1.4,
                        ),
                      ),
                      const Gap(24),

                      // Document Type Dropdown
                      // Container(
                      //   padding: const EdgeInsets.symmetric(horizontal: 16),
                      //   decoration: BoxDecoration(
                      //     color: const Color(0xFFF8F9FA),
                      //     borderRadius: BorderRadius.circular(12),
                      //     border: Border.all(color: const Color(0xFFE4E7EC)),
                      //   ),
                      //   child: DropdownButtonHideUnderline(
                      //     child: DropdownButton<String>(
                      //       value: _selectedDocumentType,
                      //       isExpanded: true,
                      //       icon: const Icon(Iconsax.arrow_down_1,
                      //           color: Color(0xFF667085)),
                      //       items: const [
                      //         DropdownMenuItem(
                      //           value: 'national_id',
                      //           child: Text("Carte d'identité"),
                      //         ),
                      //         DropdownMenuItem(
                      //           value: 'passport',
                      //           child: Text("Passeport"),
                      //         ),
                      //       ],
                      //       onChanged: (val) {
                      //         if (val != null) {
                      //           setState(() {
                      //             _selectedDocumentType = val;
                      //             _frontFile = null;
                      //             _backFile = null;
                      //           });
                      //         }
                      //       },
                      //     ),
                      //   ),
                      // ),
                      // const Gap(20),

                      // // Upload Area
                      // if (_selectedDocumentType == 'passport') ...[
                      //   _buildSingleUploadBox(true),
                      // ] else ...[
                      //   Row(
                      //     children: [
                      //       Expanded(child: _buildSingleUploadBox(true)),
                      //       const Gap(16),
                      //       Expanded(child: _buildSingleUploadBox(false)),
                      //     ],
                      //   ),
                      // ],
                      // const Gap(24),

                      // // Submit Button
                      // CustomLoadingButtom(
                      //   text: "Soumettre",
                      //   onClick: _submitManual,
                      //   isLoading: _isLoading,
                      //   clickable: !_isLoading,
                      // ),
                      // const Gap(12),

                      // Didit Automated Flow Button
                      CustomButtom(
                        onClick: _startDiditVerification,
                        isLoading: _isLoading,
                        clickable: !_isLoading,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Iconsax.security_safe,
                              size: 18,
                              color: Colors.white,
                            ),
                            Gap(8),
                            Text(
                              "Vérification automatisée (Didit)",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Close Button (Red Circle, White X)
              Positioned(
                top: 16,
                right: 16,
                child: GestureDetector(
                  onTap: () {
                    if (!_isLoading) {
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF0000),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildSingleUploadBox(bool isFront) {
  //   final File? file = isFront ? _frontFile : _backFile;

  //   return GestureDetector(
  //     onTap: () => _pickImage(isFront),
  //     child: Container(
  //       height: 140,
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(16),
  //         border: Border.all(color: const Color(0xFF2172CB), width: 1.5),
  //       ),
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(14),
  //         child: file != null
  //             ? Stack(
  //                 fit: StackFit.expand,
  //                 children: [
  //                   Image.file(
  //                     file,
  //                     fit: BoxFit.cover,
  //                   ),
  //                   Positioned(
  //                     top: 8,
  //                     right: 8,
  //                     child: GestureDetector(
  //                       onTap: () => _removeImage(isFront),
  //                       child: Container(
  //                         padding: const EdgeInsets.all(4),
  //                         decoration: const BoxDecoration(
  //                           color: Colors.black54,
  //                           shape: BoxShape.circle,
  //                         ),
  //                         child: const Icon(
  //                           Icons.delete,
  //                           size: 14,
  //                           color: Colors.white,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               )
  //             : DottedBorder(
  //                 borderType: BorderType.RRect,
  //                 radius: const Radius.circular(14),
  //                 padding: const EdgeInsets.all(8),
  //                 color: const Color(0xFF2172CB).withOpacity(0.5),
  //                 dashPattern: const [8, 6],
  //                 strokeWidth: 1.5,
  //                 child: Center(
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Icon(
  //                         Iconsax.image,
  //                         size: 32,
  //                         color: const Color(0xFF2172CB),
  //                       ),
  //                       const Gap(8),
  //                       Text(
  //                         _selectedDocumentType == 'passport'
  //                             ? "Ajouter une photo\nd'identité"
  //                             : (isFront
  //                                 ? "Téléverser votre pièce\nd'identité (recto)"
  //                                 : "Téléverser votre pièce\nd'identité (verso)"),
  //                         textAlign: TextAlign.center,
  //                         style: const TextStyle(
  //                           fontSize: 10,
  //                           fontWeight: FontWeight.w600,
  //                           color: Color(0xFF2172CB),
  //                           height: 1.3,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //       ),
  //     ),
  //   );
  // }
}
