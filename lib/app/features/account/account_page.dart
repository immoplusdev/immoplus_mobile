import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/data/models/local/user_model_schema.dart';
import 'package:immoplus/app/features/account/pages/change_password.dart';
import 'package:immoplus/app/features/account/pages/edit_account.dart';
import 'package:immoplus/app/features/account/widgets/delete_account_dialog.dart';
import 'package:immoplus/app/features/account/widgets/general_condition_page.dart';
import 'package:immoplus/app/features/account/widgets/logout_confirm_dialog.dart';
import 'package:immoplus/app/features/account/widgets/open_settings_dialog.dart';
import 'package:immoplus/app/features/account/widgets/profile_hearder.dart';
import 'package:immoplus/app/features/account/widgets/settings_tile.dart';
import 'package:immoplus/app/features/authentification/authentification_page.dart';
import 'package:immoplus/app/features/booking_history/booking_history_page.dart';
import 'package:immoplus/app/features/notification/pages/notification_page.dart';
import 'package:immoplus/app/features/paymebt_history/payment_history_page.dart';
import 'package:immoplus/app/features/visit_history/visit_history_page.dart';
import 'package:immoplus/app/utils/contact_utils.dart';
import 'package:url_launcher/url_launcher.dart';

// Design tokens — minimalist luxury, 2026
const Color _kIconBg = Color(0xFFF2F2F2);
const Color _kIconColor = Color(0xFF374151);
const Color _kLabelColor = Color(0xFF0D0D0D);
const Color _kSectionColor = Color(0xFF64748B);
const Color _kTrailingColor = Color(0xFF374151);
const Color _kBrandMuted = Color(0xFF9CA3AF); // muted light grey
const Color _kSocialIcon = Color(0xFF6B7280); // monochromatic grey

class AccountPage extends StatefulWidget {
  AccountPage({super.key});
  static String name = 'ACCOUNT_PAGE';

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final sessionManager = getIt<SessionManager>();
  UserModelSchema? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = sessionManager.currentUser;
    if (mounted) setState(() {});
  }

  Future<void> _refreshUser() async {
    await sessionManager.getCurrentUser();
    currentUser = sessionManager.currentUser;
    if (mounted) setState(() {});
  }

  void _showLogoutDialog() {
    showLogoutConfirmDialog(
      context,
      onLogout: sessionManager.logout,
    );
  }

  void _openServiceClient() {
    // TODO: ouvrir lien / téléphone service client
    ContactUtils.showContact();
  }

  void _showTermsBottomSheet() {
    showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      isScrollControlled: true,
      useRootNavigator: true,
      showDragHandle: true,
      context: context,
      builder: (context) => const FractionallySizedBox(
        heightFactor: 0.9,
        child: GeneralConditionPage(),
      ),
    );
  }

  /// Icône centrée dans un conteneur 40×40 gris doux, trait fin (monochrome).
  Widget _iconLeading(Widget icon) {
    return Container(
      width: SettingsTile.kIconContainerSize,
      height: SettingsTile.kIconContainerSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _kIconBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return const AuthenticationPage();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(appPadding),
        child: CustomScrollView(
          slivers: [
            const SliverGap(20),
             SliverAppBar(
      expandedHeight: 20.0, // Définit la hauteur de la barre lorsqu'elle est étendue [2]
      pinned: true,          // Permet de garder la barre visible en haut de l'écran lors du défilement [3, 4]
      flexibleSpace: FlexibleSpaceBar(
        title: Text("Profile"), // Le nom "Profil" est défini ici [2, 5]
        centerTitle: true,    // Par défaut à true, permet de centrer le titre [5]
      ),
    ),
            ProfileHearder(
              currentUser: currentUser,
              onServiceClientPressed: _openServiceClient,
            ),
            const SliverGap(32),
            _sectionTitle('COMPTE'),
            _buildFirstGroup(context),
            const SliverGap(28),
            _sectionTitle('ACTIVITÉ ET PAIEMENTS'),
            _buildSecondGroup(context),
            const SliverGap(28),
            _sectionTitle('SESSION'),
            _buildLogoutTile(context),
            const SliverGap(40),
            _buildDeleteAccountAction(context),
            const SliverGap(56),
            _buildBrandSignature(),
            const SliverGap(20),
            _buildSocialRow(),
            const SliverGap(32),
          ],
        ),
      ),
    );
  }

  /// Signature de marque centrée, typo élégante gris doux.
  Widget _buildBrandSignature() {
    return SliverToBoxAdapter(
      child: Center(
        child: Text(
          '@Afriq\'Solus',
          style: GoogleFonts.dmSans(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: _kBrandMuted,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  /// Ligne d’icônes sociales minimalistes, monochrome, trait fin.
  Widget _buildSocialRow() {
    return SliverToBoxAdapter(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _socialIcon(FontAwesomeIcons.instagram, () => _openUrl('https://www.instagram.com/immoplus_lapp')),
          const SizedBox(width: 28),
          _socialIcon(FontAwesomeIcons.tiktok, () => _openUrl('https://www.tiktok.com/@immoplus_lapp')),
          // const SizedBox(width: 28),
          // _socialIcon(FontAwesomeIcons.linkedin, () => _openUrl('https://www.linkedin.com/company/immo-plus-l-app')),
          const SizedBox(width: 28),
          _socialIcon(FontAwesomeIcons.facebook, () => _openUrl('https://www.facebook.com/profile.php?id=61584464421569')),
        ],
      ),
    );
  }

  Widget _socialIcon(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 22, color: _kSocialIcon),
        ),
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _sectionTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 10),
        child: Text(
          title,
          style: GoogleFonts.dmSans(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: _kSectionColor,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildFirstGroup(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        SettingsTile(
          shape: SettingsTile.shapeFirst,
          leading: _iconLeading(Icon(CupertinoIcons.person, size: 20, color: _kIconColor)),
          title: 'Informations personnelles',
          titleColor: _kLabelColor,
          trailingColor: _kTrailingColor,
          titleStyle: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: _kLabelColor,
            height: 1.25,
          ),
          onTap: () async {
            await context.pushNamed(EditAccountPage.name);
            await _refreshUser();
          },
        ),
        SettingsTile(
          shape: SettingsTile.shapeMiddle,
          leading: _iconLeading(Icon(FontAwesomeIcons.lock, size: 18, color: _kIconColor)),
          title: 'Changer mon mot de passe',
          titleColor: _kLabelColor,
          trailingColor: _kTrailingColor,
          titleStyle: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: _kLabelColor,
            height: 1.25,
          ),
          onTap: () => context.pushNamed(ChangePassword.name),
        ),
        SettingsTile(
          shape: SettingsTile.shapeMiddle,
          leading: _iconLeading(Icon(CupertinoIcons.text_alignleft, size: 20, color: _kIconColor)),
          title: 'Termes et conditions',
          titleColor: _kLabelColor,
          trailingColor: _kTrailingColor,
          titleStyle: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: _kLabelColor,
            height: 1.25,
          ),
          onTap: _showTermsBottomSheet,
        ),
        SettingsTile(
          shape: SettingsTile.shapeLast,
          leading: _iconLeading(Icon(FontAwesomeIcons.gears, size: 18, color: _kIconColor)),
          title: 'Permissions',
          titleColor: _kLabelColor,
          trailingColor: _kTrailingColor,
          titleStyle: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: _kLabelColor,
            height: 1.25,
          ),
          onTap: () => showOpenSettingsDialog(context),
        ),
      ]),
    );
  }

  Widget _buildSecondGroup(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        SettingsTile(
          shape: SettingsTile.shapeFirst,
          leading: _iconLeading(Icon(FontAwesomeIcons.bell, size: 18, color: _kIconColor)),
          title: 'Notification',
          titleColor: _kLabelColor,
          trailingColor: _kTrailingColor,
          titleStyle: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: _kLabelColor,
            height: 1.25,
          ),
          onTap: () => context.pushNamed(NotificationsPage.name),
        ),
        SettingsTile(
          shape: SettingsTile.shapeMiddle,
          leading: _iconLeading(Icon(FontAwesomeIcons.doorOpen, size: 18, color: _kIconColor)),
          title: 'Historiques des réservations',
          titleColor: _kLabelColor,
          trailingColor: _kTrailingColor,
          titleStyle: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: _kLabelColor,
            height: 1.25,
          ),
          onTap: () => context.pushNamed(BookingHistoryPage.name),
        ),
        SettingsTile(
          shape: SettingsTile.shapeMiddle,
          leading: _iconLeading(Icon(FontAwesomeIcons.personWalkingLuggage, size: 18, color: _kIconColor)),
          title: 'Historiques des visites',
          titleColor: _kLabelColor,
          trailingColor: _kTrailingColor,
          titleStyle: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: _kLabelColor,
            height: 1.25,
          ),
          onTap: () => context.pushNamed(VisitHistoryPage.name),
        ),
        SettingsTile(
          shape: SettingsTile.shapeLast,
          leading: _iconLeading(Icon(FontAwesomeIcons.moneyBills, size: 18, color: _kIconColor)),
          title: 'Paiements',
          titleColor: _kLabelColor,
          trailingColor: _kTrailingColor,
          titleStyle: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: _kLabelColor,
            height: 1.25,
          ),
          onTap: () => context.pushNamed(PaymentHistoryPage.name),
        ),
      ]),
    );
  }

  /// Tuile Déconnexion (section SESSION).
  Widget _buildLogoutTile(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        SettingsTile(
          shape: SettingsTile.shapeSingle,
          leading: _iconLeading(Icon(FontAwesomeIcons.arrowRightFromBracket, size: 18, color: _kIconColor)),
          title: 'Déconnexion',
          titleColor: _kLabelColor,
          trailingColor: _kTrailingColor,
          titleStyle: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: _kLabelColor,
            height: 1.25,
          ),
          onTap: _showLogoutDialog,
        ),
      ]),
    );
  }

  /// Bouton « Supprimer mon compte » : texte bordeaux discret, pas de fond.
  Widget _buildDeleteAccountAction(BuildContext context) {
    return SliverToBoxAdapter(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => showDeleteAccountDialog(context),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                'Supprimer mon compte',
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
