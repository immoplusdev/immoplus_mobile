import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/features/notification/model/notification_model.dart';
import 'package:intl/intl.dart';

class NotificationDetailPage extends StatelessWidget {
  final NotificationModel notification;
  const NotificationDetailPage({super.key, required this.notification});

  static const String name = 'NOTIFICATION_DETAIL_PAGE';

  @override
  Widget build(BuildContext context) {
    final type = notification.typeEnum;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Détails',
          style: GoogleFonts.dmSans(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: type.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(type.icon, color: type.color, size: 28),
                ),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.subject ?? 'Notification',
                        style: GoogleFonts.dmSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                      const Gap(4),
                      Text(
                        DateFormat('d MMMM yyyy, HH:mm', 'fr_FR')
                            .format(notification.createdAt ?? DateTime.now()),
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(32),
            Text(
              'Message',
              style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade400,
                letterSpacing: 0.5,
              ),
            ),
            const Gap(12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Text(
                notification.message ?? 'Aucun contenu.',
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  color: const Color(0xFF4B5563),
                  height: 1.6,
                ),
              ),
            ),
            const Gap(40),
          ],
        ),
      ),
    );
  }
}
