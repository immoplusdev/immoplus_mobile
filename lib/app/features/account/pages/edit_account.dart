// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ez_circle_avatar/ez_circle_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/data/models/auth/update_user_dto.dart';
import 'package:immoplus/app/extensions/safe_area_extensions.dart';
import 'package:immoplus/app/features/payment_module/utils/utils.dart';
import 'package:immoplus/app/logic/authentification/login_cubit.dart';
import 'package:immoplus/app/logic/authentification/login_cubit_state.dart';
import 'package:immoplus/app/modules/files_uploader.dart/file_uploader_controller.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/formuar_controller.dart';
import 'package:immoplus/app/utils/formular_utils.dart';
import 'package:immoplus/app/widgets/custom_loading_button.dart';
import 'package:immoplus/app/widgets/custom_text_field.dart';
import 'package:immoplus/app/widgets/international_phone_number_input.dart';
import 'package:shimmer/shimmer.dart';

class EditAccountPage extends StatefulWidget {
  const EditAccountPage({super.key});
  static String name = 'EDIT_ACCOUNT';

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  final sessionManager = getIt<SessionManager>();
  late FileUploaderController fileUploaderController;
  late FormController _formController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();

  getCity({required Widget child}) {
    _focusNode.unfocus();
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  bool isPhoneNumberValid = false;
  bool _photoLoading = false;
  String phoneNumber = '';

  void onInputValidated(bool isValid) {
    setState(() {
      isPhoneNumberValid = isValid;
    });
  }

  Future<void> _pickProfileImage() async {
    final XFile? file = await showModalBottomSheet<XFile?>(
      context: context,
      useSafeArea: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: AppColors.whiteBackground,
      showDragHandle: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 16),
              child: Text(
                "Photo de profil",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0D0D0D),
                ),
              ),
            ),
            _sheetTile(
              ctx: ctx,
              icon: Iconsax.camera,
              iconColor: AppColors.primary,
              label: "Prendre une photo",
              onTap: () => ImagePicker()
                  .pickImage(source: ImageSource.camera, imageQuality: 50)
                  .then((v) => Navigator.pop(ctx, v)),
            ),
            const Gap(10),
            _sheetTile(
              ctx: ctx,
              icon: Iconsax.gallery,
              iconColor: const Color(0xFF6B7280),
              label: "Choisir depuis la galerie",
              onTap: () => ImagePicker()
                  .pickImage(source: ImageSource.gallery, imageQuality: 50)
                  .then((v) => Navigator.pop(ctx, v)),
            ),
          ],
        ),
      ),
    );
    if (file == null) return;
    setState(() {
      _photoLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 50));
    setState(() {
      fileUploaderController.filePath = file.path;
      fileUploaderController.file = File(file.path);
      _photoLoading = false;
    });
  }

  @override
  void initState() {
    phoneNumber = sessionManager.currentUser!.phoneNumber ?? '';
    sessionManager.currentUser;
    _focusNode.unfocus();
    fileUploaderController = FileUploaderController();
    _formController = FormController(
      productId: 0,
      firstName:
          TextEditingController(text: sessionManager.currentUser!.firstName),
      lastName:
          TextEditingController(text: sessionManager.currentUser!.lastName),
      phoneNumber:
          TextEditingController(text: sessionManager.currentUser!.phoneNumber),
      email: TextEditingController(text: sessionManager.currentUser!.email),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginCubit>(),
      child: BlocListener<LoginCubit, LoginCubitState>(
        listener: (context, state) {
          if (state is LOGIN_SUCCESS) context.pop();
        },
        child: Scaffold(
          backgroundColor: AppColors.whiteBackground,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Informations personnelles'),
            backgroundColor: AppColors.whiteBackground,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Iconsax.arrow_left, size: 24),
              onPressed: () => context.pop(),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: BlocBuilder<LoginCubit, LoginCubitState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Gap(24),
                          _buildProfilePhotoCard(),
                          const Gap(32),

                          // Section titre
                          _buildSectionHeader(context, "Identité"),
                          const Gap(12),

                          CustomTextField(
                            controller: _formController.firstName,
                            prefixIcon: const Icon(Iconsax.user, size: 20),
                            labelText: 'Nom',
                            validator: (String? value) =>
                                FormUtils.fieldValidator(value: value),
                          ),
                          CustomTextField(
                            controller: _formController.lastName,
                            prefixIcon: const Icon(Iconsax.user, size: 20),
                            labelText: 'Prénom',
                            validator: (String? value) =>
                                FormUtils.fieldValidator(value: value),
                          ),

                          const Gap(16),
                          _buildSectionHeader(context, "Contact"),
                          const Gap(12),

                          InternationalPhoneInput(
                            initialPhoneNumber:
                                sessionManager.currentUser!.phoneNumber,
                            onValidPhoneNumber: (value) {
                              phoneNumber = value;
                            },
                            onInputValidated: onInputValidated,
                            isEnabled: false,
                          ),
                          const Gap(10),
                          CustomTextField(
                            controller: _formController.email,
                            prefixIcon: const Icon(Iconsax.sms, size: 20),
                            labelText: 'Email',
                            isEnabled: false,
                            textInputType: TextInputType.emailAddress,
                            validator: (String? value) =>
                                FormUtils.emailValidator(email: value),
                          ),

                          // Info box pour les champs non modifiables
                          const Gap(12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: const Color(0xFFF2F4F7)),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Iconsax.info_circle,
                                  size: 18,
                                  color: const Color(0xFF667085),
                                ),
                                const Gap(10),
                                Expanded(
                                  child: Text(
                                    "Le numéro de téléphone et l'email peuvent être modifiés dans le menu \"Changer mes identifiants de connexion\"",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: const Color(0xFF667085),
                                          height: 1.4,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(100),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          bottomNavigationBar: Container(
            height: 100,
            padding: const EdgeInsets.all(10.0),
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            decoration: BoxDecoration(
              color: AppColors.whiteBackground,
              border: const Border(
                top: BorderSide(color: Color(0xFFF2F4F7)),
              ),
            ),
            child: BlocBuilder<LoginCubit, LoginCubitState>(
              builder: (context, state) {
                return CustomLoadingButtom(
                  isLoading: (state is LOGIN_LOADING),
                  onClick: ((state is LOGIN_LOADING))
                      ? null
                      : () async {
                          String? avatar;
                          inspect(fileUploaderController);
                          if (fileUploaderController.file != null) {
                            avatar = await uploadFile(
                                file: fileUploaderController.file!);
                          }

                          if (_formKey.currentState!.validate() &&
                              isPhoneNumberValid) {
                            FocusScope.of(context).unfocus();

                            final body = UpdateUserDto(
                              firstName: _formController.firstName!.text,
                              lastName: _formController.lastName!.text,
                              email: _formController.email!.text,
                              avatar:
                                  avatar ?? sessionManager.currentUser!.avatar,
                              phoneNumber: phoneNumber,
                            );

                            context.read<LoginCubit>().updateUserData(
                                  body: body,
                                );
                          }
                        },
                  text: "Enregistrer les modifications",
                );
              },
            ),
          ),
        ).safeArea(),
      ),
    );
  }

  Widget _sheetTile({
    required BuildContext ctx,
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFFF9FAFB),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              const Gap(14),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E1E1E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF344054),
              letterSpacing: 0.3,
            ),
      ),
    );
  }

  Widget _buildProfilePhotoCard() {
    final user = sessionManager.currentUser!;
    final fullName = '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim();
    final hasLocalFile = fileUploaderController.filePath != null;
    final hasNetworkPhoto = user.avatar != null && user.avatar!.isNotEmpty;

    Widget avatar;
    if (_photoLoading) {
      avatar = Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade100,
        child: Container(color: Colors.white),
      );
    } else if (hasLocalFile) {
      avatar = Image.file(
        File(fileUploaderController.filePath!),
        fit: BoxFit.cover,
      );
    } else if (hasNetworkPhoto) {
      avatar = CachedNetworkImage(
        imageUrl: Utils.getImagePath(id: user.avatar!),
        fit: BoxFit.cover,
        memCacheWidth: 200,
        memCacheHeight: 200,
        placeholder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.grey.shade100,
          child: Container(color: Colors.white),
        ),
        errorWidget: (_, __, ___) => EzCircleAvatar(
          name: fullName.isNotEmpty ? fullName : 'U',
          radius: 48,
        ),
      );
    } else {
      avatar = EzCircleAvatar(
        name: fullName.isNotEmpty ? fullName : 'U',
        radius: 48,
      );
    }

    return GestureDetector(
      onTap: _pickProfileImage,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    width: 3,
                  ),
                  color: Colors.grey.shade100,
                ),
                child: ClipOval(child: avatar),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Iconsax.camera,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const Gap(10),
          Text(
            hasLocalFile || hasNetworkPhoto
                ? 'Changer la photo'
                : 'Ajouter une photo',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
