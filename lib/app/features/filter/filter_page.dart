import 'dart:developer';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/features/filter/components/filter_range_price.dart';
import 'package:immoplus/app/features/filter/logic/filter_cubit.dart';
import 'package:immoplus/app/features/home_page/logic/home_cubit.dart';
import 'package:immoplus/app/features/home_page/logic/home_page_state.dart';
import 'package:immoplus/app/features/location_module/data/model/address.dart';
import 'package:immoplus/app/features/location_module/location_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/filter_handler.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final List<DateTime?> markedDates = [];
  Address? currentAddress;

  @override
  void initState() {
    if (FilterHandler.locationName != null) {
      currentAddress = Address(
        latitude: FilterHandler.lat ?? 0,
        longitude: FilterHandler.long ?? 0,
        description: FilterHandler.locationName!,
      );
    }
    if (FilterHandler.startDate != null && FilterHandler.endDate != null) {
      try {
        markedDates.add(DateTime.parse(FilterHandler.startDate!));
        markedDates.add(DateTime.parse(FilterHandler.endDate!));
      } catch (e) {}
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageCubit, HomePageState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: AppColors.whiteBackground,
        body: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(),

            // Section: Lieu
            SliverPadding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
              sliver: SliverToBoxAdapter(
                child: _buildSectionLabel(context, 'Où souhaitez-vous loger ?'),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      useRootNavigator: true,
                      context: context,
                      isScrollControlled: true,
                      enableDrag: false,
                      showDragHandle: true,
                      backgroundColor: AppColors.whiteBackground,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(24))),
                      builder: (context) => const FractionallySizedBox(
                        heightFactor: 0.9,
                        child: LocationPage(),
                      ),
                    ).then(
                      (value) {
                        inspect(value);
                        if (value is Address) {
                          setState(() {
                            currentAddress = value;
                          });
                        }
                      },
                    );
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFF2F4F7)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLite,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Iconsax.location,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: Text(
                            currentAddress == null
                                ? 'Sélectionner un lieu'
                                : currentAddress!.description.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  fontWeight: currentAddress == null
                                      ? FontWeight.w400
                                      : FontWeight.w600,
                                  color: currentAddress == null
                                      ? const Color(0xFF98A2B3)
                                      : const Color(0xFF344054),
                                ),
                          ),
                        ),
                        Icon(
                          Iconsax.arrow_down_1,
                          color: const Color(0xFF98A2B3),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SliverGap(20),

            // Section: Dates
            SliverPadding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
              sliver: SliverToBoxAdapter(
                child: _buildSectionLabel(
                    context, 'Quand souhaitez-vous réserver ?'),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF2F4F7)),
                  ),
                  child: CalendarDatePicker2(
                    config: CalendarDatePicker2Config(
                      controlsTextStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600),
                      disableModePicker: true,
                      firstDayOfWeek: 1,
                      calendarType: CalendarDatePicker2Type.range,
                      centerAlignModePicker: true,
                      customModePickerIcon: const SizedBox(),
                      firstDate: DateTime.now(),
                      selectedDayHighlightColor: AppColors.primary,
                      selectedRangeHighlightColor:
                          AppColors.primary.withValues(alpha: 0.1),
                      selectableDayPredicate: (day) => day.isAfter(
                          DateTime.now().subtract(const Duration(days: 1))),
                    ),
                    onDisplayedMonthChanged: null,
                    value: markedDates,
                    onValueChanged: (value) {
                      setState(() {
                        markedDates.clear();
                        markedDates.addAll(value);
                        inspect(markedDates);
                        FilterHandler.startDate = value.first.toIso8601String();
                        FilterHandler.endDate = value.length > 1
                            ? value.last.toIso8601String()
                            : null;
                      });
                    },
                  ),
                ),
              ),
            ),

            // Section: Prix
            const SliverToBoxAdapter(child: FilterRangePrice()),
            const SliverGap(80),
          ],
        ),

        // Bottom actions
        bottomSheet: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16)
              .copyWith(bottom: 16, top: 12),
          decoration: BoxDecoration(
            color: AppColors.whiteBackground,
            border: const Border(
              top: BorderSide(color: Color(0xFFF2F4F7)),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (currentAddress != null) {
                        FilterHandler.locationName =
                            currentAddress!.description;
                        FilterHandler.lat = currentAddress!.latitude;
                        FilterHandler.long = currentAddress!.longitude;
                      }
                      FilterHandler.notifyChange();

                      HomePageState.getPageListController(state.indexPage)
                          .refresh();
                      context.read<FilterCubit>().refresh(FilterHandler());
                      context.pop();
                    },
                    icon: const Icon(Iconsax.filter, size: 18),
                    label: const Text('Appliquer le filtre'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const Gap(8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        FilterHandler.cleanParameters();
                        markedDates.clear();
                        currentAddress = null;
                      });
                      HomePageState.getPageListController(state.indexPage)
                          .refresh();
                      context.read<FilterCubit>().refresh(FilterHandler());
                      context.pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFF04438),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    child: const Text('Annuler les filtres'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSectionLabel(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF344054),
          ),
    );
  }
}
