import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/features/home_page/home_page.dart';
import 'package:immoplus/app/features/user_preference/cubit/user_preference_cubit.dart';
import 'package:immoplus/app/features/user_preference/cubit/user_preference_cubit_state.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/toast_utils.dart';
import 'package:immoplus/app/widgets/custom_loading_button.dart';

class UserPreferencePage extends StatelessWidget {
  const UserPreferencePage({super.key});

  static const String routePath = '/user_preference';
  static const String name = 'USER_PREFERENCE_PAGE';

  @override
  Widget build(BuildContext context) {
    final sessionManager = getIt<SessionManager>();

    return FutureBuilder(
      future: sessionManager.getCurrentUser(),
      builder: (context, snapshot) {
        final userId = snapshot.data?.id.toString();

        return BlocProvider(
          create: (context) =>
              getIt<UserPreferenceCubit>()..init(userId: userId),
          child: BlocListener<UserPreferenceCubit, UserPreferenceCubitState>(
            listener: (context, state) {
              state.maybeWhen(
                success: () => context.goNamed(HomePage.name),
                error: (message) => ToastUtils.showError(title: message),
                orElse: () {},
              );
            },
            child: UserPreferenceView(userId: userId),
          ),
        );
      },
    );
  }
}

class UserPreferenceView extends StatelessWidget {
  final String? userId;
  const UserPreferenceView({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<UserPreferenceCubit, UserPreferenceCubitState>(
          builder: (context, state) {
            return state.maybeWhen(
              loading: () => const Center(child: CircularProgressIndicator()),
              loaded: (options, selectedIntentId, selectedTypes,
                      selectedLocations, budgetMin, budgetMax, isSaving) =>
                  Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Gap(40),
                          Text(
                            'Choisis ce qui te plaît',
                            style: GoogleFonts.dmSans(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const Gap(32),
                          _buildSectionTitle(
                              "Choisissez l'intent que vous souhaitez"),
                          const Gap(16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 12,
                            children: options.intents.map((intent) {
                              final isSelected = selectedIntentId == intent.id;
                              return _PreferenceChip(
                                label: intent.label,
                                isSelected: isSelected,
                                onTap: () => context
                                    .read<UserPreferenceCubit>()
                                    .selectIntent(intent.id),
                              );
                            }).toList(),
                          ),
                          const Gap(40),
                          _buildSectionTitle(
                              'Choisissez le type de bien qui vous intéresse'),
                          const Gap(16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 12,
                            children: options.propertyTypes.map((type) {
                              final isSelected =
                                  selectedTypes.contains(type.id);
                              return _PreferenceChip(
                                label: type.label,
                                isSelected: isSelected,
                                onTap: () => context
                                    .read<UserPreferenceCubit>()
                                    .togglePropertyType(type.id),
                              );
                            }).toList(),
                          ),
                          const Gap(40),
                          _buildSectionTitle(
                              'Choisissez les lieux qui vous intéresse'),
                          const Gap(16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 12,
                            children: options.locations.map((location) {
                              final isSelected =
                                  selectedLocations.contains(location.id);
                              return _PreferenceChip(
                                label: location.label,
                                isSelected: isSelected,
                                onTap: () => context
                                    .read<UserPreferenceCubit>()
                                    .toggleLocation(location.id),
                              );
                            }).toList(),
                          ),
                          const Gap(40),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: CustomLoadingButtom(
                      text: 'Démarrer',
                      isLoading: isSaving,
                      color: (selectedTypes.isEmpty &&
                              selectedLocations.isEmpty &&
                              selectedIntentId == null &&
                              budgetMin == null &&
                              budgetMax == null)
                          ? Colors.grey.shade300
                          : AppColors.primary,
                      onClick: (selectedTypes.isEmpty &&
                              selectedLocations.isEmpty &&
                              selectedIntentId == null &&
                              budgetMin == null &&
                              budgetMax == null)
                          ? null
                          : () => context.read<UserPreferenceCubit>().save(),
                    ),
                  ),
                ],
              ),
              error: (message) => Padding(
                padding: const EdgeInsets.all(appPadding),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.warning_2,
                          size: 64, color: Colors.grey.shade400),
                      const Gap(16),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const Gap(24),
                      CustomLoadingButtom(
                        text: 'Réessayer',
                        isLoading: false,
                        color: AppColors.primary,
                        onClick: () => context
                            .read<UserPreferenceCubit>()
                            .init(userId: userId),
                      ),
                    ],
                  ),
                ),
              ),
              orElse: () => const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.dmSans(
        fontSize: 16,
        color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _PreferenceChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PreferenceChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                color: isSelected ? Colors.white : Colors.grey.shade600,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            const Gap(6),
            Icon(
              Iconsax.add,
              size: 16,
              color: isSelected ? Colors.white : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
