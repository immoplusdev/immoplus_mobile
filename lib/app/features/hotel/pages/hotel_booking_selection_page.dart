import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/core/services/auth_redirect_service.dart';
import 'package:immoplus/app/features/authentification/authentification_page.dart';
import 'package:immoplus/app/data/models/remote/hotel/hotel_detail_model.dart';
import 'package:immoplus/app/data/models/remote/hotel/hotel_estimation_request.dart';
import 'package:immoplus/app/features/hotel/cubit/hotel_cubit.dart';
import 'package:immoplus/app/features/hotel/cubit/hotel_state.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:immoplus/app/features/hotel/pages/hotel_booking_summary_page.dart';
import 'package:immoplus/app/features/hotel/widgets/hotel_booking_room_card.dart';
import 'package:immoplus/app/features/hotel/widgets/hotel_booking_card.dart';
import 'package:immoplus/app/utils/toast_utils.dart';
import 'package:intl/intl.dart';

class HotelBookingSelectionPage extends StatefulWidget {
  final String hotelId;
  final String? initialRoomId;

  const HotelBookingSelectionPage({
    super.key,
    required this.hotelId,
    this.initialRoomId,
  });

  static const String routePath = '/hotels/:hotelId/booking';
  static const String name = 'hotel_booking_selection';

  static String route(String hotelId, {String? roomId}) {
    if (roomId != null) {
      return '/hotels/$hotelId/booking?roomId=$roomId';
    }
    return '/hotels/$hotelId/booking';
  }

  @override
  State<HotelBookingSelectionPage> createState() =>
      _HotelBookingSelectionPageState();
}

class _HotelBookingSelectionPageState extends State<HotelBookingSelectionPage> {
  RoomTypeModel? _selectedRoom;
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _adults = 1;

  @override
  void initState() {
    super.initState();
    // Load hotel details if not already loaded, to get the room list
    context.read<HotelCubit>().getHotel(widget.hotelId);
  }

  int get _nightCount {
    if (_checkInDate != null && _checkOutDate != null) {
      return _checkOutDate!.difference(_checkInDate!).inDays;
    }
    return 0;
  }

  Future<void> _selectCheckInDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _checkInDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _checkInDate = picked;
        if (_checkOutDate != null && _checkOutDate!.isBefore(_checkInDate!)) {
          _checkOutDate = _checkInDate!.add(const Duration(days: 1));
        }
      });
    }
  }

  Future<void> _selectCheckOutDate(BuildContext context) async {
    if (_checkInDate == null) {
      ToastUtils.warning("Veuillez sélectionner la date d'arrivée d'abord.");
      return;
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _checkOutDate ?? _checkInDate!.add(const Duration(days: 1)),
      firstDate: _checkInDate!.add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _checkOutDate = picked);
    }
  }

  void _onContinue(HotelDetailModel hotel) {
    if (_selectedRoom == null) {
      ToastUtils.warning("Veuillez choisir un type de chambre.");
      return;
    }
    if (_checkInDate == null || _checkOutDate == null) {
      ToastUtils.warning("Veuillez sélectionner vos dates de séjour.");
      return;
    }

    final dateFormat = DateFormat('yyyy-MM-dd');
    final request = HotelEstimationRequest(
      roomTypeId: _selectedRoom!.roomTypeId,
      checkInDate: dateFormat.format(_checkInDate!),
      checkOutDate: dateFormat.format(_checkOutDate!),
      adults: _adults,
      children: 0,
      avecPetitDejeuner: false,
    );

    if (getIt<SessionManager>().currentUser == null) {
      getIt<AuthRedirectService>().set(
        (
          popUntilRouteName: HotelBookingSelectionPage.name,
          callback: () {
            //  context.push(
            //     HotelBookingSummaryPage.route(hotel.hotelId),
            //     extra: {
            //       'hotel': hotel,
            //       'room': _selectedRoom,
            //       'request': request,
            //     },
            //   );
          },
        ),
      );
      context.pushNamed(AuthenticationPage.name);
    } else {
      // Navigate to booking summary page
      context.push(
        HotelBookingSummaryPage.route(hotel.hotelId),
        extra: {
          'hotel': hotel,
          'room': _selectedRoom,
          'request': request,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayFormat = DateFormat('dd MMMM yyyy', 'fr_FR');

    return BlocConsumer<HotelCubit, HotelState>(
      listener: (context, state) {
        state.maybeWhen(
          hotelDetailLoaded: (hotel) {
            if (_selectedRoom == null && hotel.typesChambres.isNotEmpty) {
              if (widget.initialRoomId != null) {
                _selectedRoom = hotel.typesChambres.firstWhere(
                  (c) => c.roomTypeId == widget.initialRoomId,
                  orElse: () => hotel.typesChambres.first,
                );
              } else {
                _selectedRoom = hotel.typesChambres.first;
              }
              setState(() {});
            }
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        final HotelDetailModel? hotel = state.maybeWhen(
          hotelDetailLoaded: (h) => h,
          orElse: () => null,
        );

        if (hotel == null) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF7F8FA),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF7F8FA),
            elevation: 0,
            leadingWidth: 56,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.black, size: 20),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: HotelBookingCard(
              title: "Réservation",
              children: [
                // ── TYPE DE CHAMBRES Section ──
                Text(
                  "TYPE DE CHAMBRES",
                  style: TextStyle(
                      color: AppColors.color8A8A86,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5),
                ),
                const Gap(12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.35,
                  ),
                  itemCount: hotel.typesChambres.length,
                  itemBuilder: (context, index) {
                    final room = hotel.typesChambres[index];
                    final isSelected =
                        _selectedRoom?.roomTypeId == room.roomTypeId;

                    return HotelBookingRoomCard(
                      room: room,
                      isSelected: isSelected,
                      onTap: () => setState(() => _selectedRoom = room),
                    );
                  },
                ),

                const Gap(24),

                // ── SÉJOUR Section ──
                Text(
                  "SÉJOUR",
                  style: TextStyle(
                      color: AppColors.color8A8A86,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5),
                ),
                const Gap(16),

                // Date Arrivée
                Text("Date d'arrivée *",
                    style: TextStyle(
                      color: AppColors.color8A8A86,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    )),
                const Gap(6),
                InkWell(
                  onTap: () => _selectCheckInDate(context),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _checkInDate != null
                          ? displayFormat.format(_checkInDate!)
                          : "Sélectionner la date d'arrivée",
                      style: TextStyle(
                        color:
                            _checkInDate != null ? Colors.black : Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                const Gap(16),

                // Date Départ
                Text("Date de départ *",
                    style: TextStyle(
                      color: AppColors.color8A8A86,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    )),
                const Gap(6),
                InkWell(
                  onTap: () => _selectCheckOutDate(context),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _checkOutDate != null
                          ? displayFormat.format(_checkOutDate!)
                          : "Sélectionner la date de départ",
                      style: TextStyle(
                        color:
                            _checkOutDate != null ? Colors.black : Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                const Gap(16),

                // Durée
                Text("Durée",
                    style: TextStyle(
                      color: AppColors.color8A8A86,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    )),
                const Gap(6),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _nightCount > 0
                            ? "$_nightCount nuit${_nightCount > 1 ? 's' : ''}"
                            : "0 nuit",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const Text(
                        "calculé auto.",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),

                const Gap(16),

                // Occupants
                Text("Occupants",
                    style: TextStyle(
                      color: AppColors.color8A8A86,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    )),
                const Gap(6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _adults,
                      items: List.generate(10, (index) => index + 1).map((i) {
                        return DropdownMenuItem<int>(
                          value: i,
                          child: Text("$i adulte${i > 1 ? 's' : ''}"),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _adults = val);
                      },
                    ),
                  ),
                ),

                const Gap(40),

                // Continue Button
                CustomButtom(
                  text: "Continuer",
                  borderRadius: BorderRadius.circular(26),
                  onClick: () => _onContinue(hotel),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
