import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_model.dart';
import 'package:immoplus/app/data/models/remote/rating/rating_request.dart';
import 'package:immoplus/app/features/rating/logic/rating_cubit.dart';
import 'package:immoplus/app/widgets/custom_loading_button.dart';
import 'package:immoplus/app/utils/toast_utils.dart';
import 'package:intl/intl.dart';
import 'package:immoplus/app/utils/utils.dart';

class RatingBottomSheet extends StatefulWidget {
  final ReservationModel reservation;

  const RatingBottomSheet({super.key, required this.reservation});

  static Future<bool?> show(BuildContext context,
      {required ReservationModel reservation}) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider(
        create: (_) => getIt<RatingCubit>(),
        child: RatingBottomSheet(reservation: reservation),
      ),
    );
  }

  @override
  State<RatingBottomSheet> createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<RatingBottomSheet> {
  int _propertyRating = 0;
  int _hostRating = 0;
  final List<String> _selectedTags = [];
  final TextEditingController _feedbackController = TextEditingController();

  final List<String> _availableTags = [
    'Propre',
    'Accueillant',
    'Confortable',
    'Bien équipé',
    'Calme',
    'Proche services'
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_propertyRating == 0) {
      ToastUtils.showError(title: 'Veuillez noter la résidence');
      return;
    }
    if (_hostRating == 0) {
      ToastUtils.showError(title: 'Veuillez noter l\'accueil');
      return;
    }

    final request = RatingRequest(
      reservationId: widget.reservation.id,
      propertyRating: _propertyRating,
      propertyFeedback: _feedbackController.text,
      hostRating: _hostRating,
      hostFeedback: '', // Provided in UI? UI only has one feedback field
      propertyTags: _selectedTags,
    );

    context.read<RatingCubit>().submitRating(request);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    String dateLabel = '';
    try {
      final inDate = Utils.toDateTime(widget.reservation.dateDebut);
      final outDate = Utils.toDateTime(widget.reservation.dateFin);
      final fmt = DateFormat('d MMM');
      dateLabel = '${fmt.format(inDate)} - ${fmt.format(outDate)}';
    } catch (_) {}

    return BlocListener<RatingCubit, RatingState>(
      listener: (context, state) {
        state.maybeWhen(
          success: () {
            ToastUtils.showSuccess(title: 'Merci pour votre avis !');
            Navigator.pop(context, true);
          },
          error: (msg) => ToastUtils.showError(title: msg),
          orElse: () {},
        );
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomPadding),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Évaluer votre séjour',
                style: GoogleFonts.dmSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Gap(8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.reservation.residence.nom,
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (dateLabel.isNotEmpty) ...[
                    const Gap(8),
                    Text(
                      dateLabel,
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ],
              ),
              const Gap(32),

              // Note de la résidence
              Text(
                'Note de la résidence',
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade800,
                ),
              ),
              const Gap(8),
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star_rounded,
                  color: Color(0xffFFBB00),
                ),
                onRatingUpdate: (rating) {
                  setState(() => _propertyRating = rating.toInt());
                },
              ),
              const Gap(24),

              // Note de l'accueil
              Text(
                'Note de l\'accueil',
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade800,
                ),
              ),
              const Gap(8),
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star_rounded,
                  color: Color(0xffFFBB00),
                ),
                onRatingUpdate: (rating) {
                  setState(() => _hostRating = rating.toInt());
                },
              ),
              const Gap(24),

              // Tags
              Text(
                'Qu\'avez-vous apprécié ?',
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade800,
                ),
              ),
              const Gap(12),
              Wrap(
                spacing: 8,
                runSpacing: 12,
                children: _availableTags.map((tag) {
                  final isSelected = _selectedTags.contains(tag);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedTags.remove(tag);
                        } else {
                          _selectedTags.add(tag);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? const Color(0xFF2548E5) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF2548E5)
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        tag,
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          color:
                              isSelected ? Colors.white : Colors.grey.shade700,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const Gap(24),

              // Feedback
              Text(
                'Votre commentaire ( optionnel )',
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade800,
                ),
              ),
              const Gap(12),
              TextField(
                controller: _feedbackController,
                maxLines: 4,
                maxLength: 500,
                decoration: InputDecoration(
                  fillColor: Colors.transparent,
                  hintText: 'Découvrez votre expérience...',
                  hintStyle: GoogleFonts.dmSans(color: Colors.grey.shade400),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2548E5)),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const Gap(24),

              // Bouton
              BlocBuilder<RatingCubit, RatingState>(
                builder: (context, state) {
                  final isLoading = state.maybeWhen(
                    loading: () => true,
                    orElse: () => false,
                  );
                  return SizedBox(
                    width: double.infinity,
                    child: CustomLoadingButtom(
                      text: 'Envoyer mon avis',
                      isLoading: isLoading,
                      color: const Color(0xFF2548E5),
                      onClick: _submit,
                    ),
                  );
                },
              ),
              Gap(MediaQuery.of(context).viewPadding.bottom),
            ],
          ),
        ),
      ),
    );
  }
}
