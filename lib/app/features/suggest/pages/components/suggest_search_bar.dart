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
  final bool showBackButton;
  // Rule 1: showSearchButton & onSearchPressed kept for backward compat but
  // the redundant "Recherche" text link is no longer rendered.
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
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Back Button
          if (showBackButton) ...[
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
          ],

          // Text Field — Rule 1: single search trigger (prefix icon + keyboard action)
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
                    prefixIcon: GestureDetector(
                      onTap: () {
                        // Allow prefix icon tap to submit search when text is present
                        if (controller.text.trim().isNotEmpty) {
                          onFieldSubmitted?.call(controller.text);
                        }
                      },
                      child: const Icon(
                        Iconsax.search_normal_1,
                        color: Colors.black,
                        size: 18,
                      ),
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

          // Rule 1: "Recherche" text link removed — the prefix loupe icon
          // and the keyboard's search action are the single search trigger.
        ],
      ),
    );
  }
}
