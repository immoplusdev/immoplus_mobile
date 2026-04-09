import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/data/enums/contact_change_type.dart';
import 'package:immoplus/app/features/account/pages/change_password.dart';
import 'package:immoplus/app/features/account/widgets/settings_tile.dart';
import 'package:immoplus/app/features/settings/contact_change/view/request_contact_change_page.dart';

const Color _kIconBg = Color(0xFFF2F2F2);
const Color _kIconColor = Color(0xFF374151);
const Color _kLabelColor = Color(0xFF0D0D0D);
const Color _kTrailingColor = Color(0xFF374151);

class ChangeCredentialsPage extends StatelessWidget {
  const ChangeCredentialsPage({super.key});

  static const String name = 'CHANGE_CREDENTIALS_PAGE';
  static const String path = '/change_credentials';

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Identifiants de connexion',
          style: GoogleFonts.dmSans(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: _kLabelColor,
          ),
        ),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            SettingsTile(
              shape: SettingsTile.shapeFirst,
              leading: _iconLeading(
                  Icon(FontAwesomeIcons.key, size: 16, color: _kIconColor)),
              title: 'Changer mon mot de passe',
              titleColor: _kLabelColor,
              trailingColor: _kTrailingColor,
              titleStyle: GoogleFonts.dmSans(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: _kLabelColor,
                height: 1.25,
              ),
              onTap: () => context.pushNamed(ChangePassword.name),
            ),
            SettingsTile(
              shape: SettingsTile.shapeMiddle,
              leading: _iconLeading(Icon(FontAwesomeIcons.envelope,
                  size: 16, color: _kIconColor)),
              title: 'Changer mon email',
              titleColor: _kLabelColor,
              trailingColor: _kTrailingColor,
              titleStyle: GoogleFonts.dmSans(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: _kLabelColor,
                height: 1.25,
              ),
              onTap: () => context.pushNamed(
                RequestContactChangePage.name,
                extra: ContactChangeType.email,
              ),
            ),
            SettingsTile(
              shape: SettingsTile.shapeLast,
              leading: _iconLeading(Icon(FontAwesomeIcons.mobileScreen,
                  size: 16, color: _kIconColor)),
              title: 'Changer mon numéro de téléphone',
              titleColor: _kLabelColor,
              trailingColor: _kTrailingColor,
              titleStyle: GoogleFonts.dmSans(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: _kLabelColor,
                height: 1.25,
              ),
              onTap: () => context.pushNamed(
                RequestContactChangePage.name,
                extra: ContactChangeType.phone,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
