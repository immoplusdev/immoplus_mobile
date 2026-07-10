import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/custom_text_field.dart';

class SuggestSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final bool showClearButton;
  final bool showSearchButton;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onBackPressed;

  const SuggestSearchBar({
    super.key,
    required this.controller,
    this.focusNode,
    this.hintText = 'Recherche...',
    this.readOnly = false,
    this.onTap,
    this.onFieldSubmitted,
    this.onChanged,
    this.onClear,
    this.showClearButton = false,
    this.showSearchButton = false,
    this.onSearchPressed,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Back Button
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColors.primary,
              size: 22,
            ),
            onPressed: onBackPressed ?? () => Navigator.pop(context),
          ),

          const Gap(8),

          // Text Field
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: AbsorbPointer(
                absorbing: readOnly,
                child: SizedBox(
                  height: 48,
                  child: CustomTextField(
                    readOnly: readOnly,
                    bottomPadding: 0,
                    controller: controller,
                    focusNode: focusNode,
                    labelText: hintText,
                    onChanged: onChanged,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    prefixIcon: const Icon(
                      Iconsax.search_normal_1,
                      color: Colors.black,
                      size: 18,
                    ),
                    sufixIcon: showClearButton
                        ? UnconstrainedBox(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: GestureDetector(
                                onTap: onClear,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.primary,
                                      width: 1.5,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(2),
                                  child: Icon(
                                    Icons.close,
                                    color: AppColors.primary,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : null,
                    textInputAction: TextInputAction.search,
                    onFieldSubmitted: onFieldSubmitted,
                    fillColor: AppColors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ),
            ),
          ),

          if (showSearchButton) ...[
            const Gap(12),
            GestureDetector(
              onTap: onSearchPressed,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Recherche',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
