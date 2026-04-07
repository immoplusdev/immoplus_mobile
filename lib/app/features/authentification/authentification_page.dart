import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/core/services/auth_redirect_service.dart';
import 'package:immoplus/app/core/type/auth_redirect_data.dart';
import 'package:immoplus/app/features/login_page/login_page.dart';
import 'package:immoplus/app/features/registration/register_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/config_env.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:immoplus/gen/assets.gen.dart';

class AuthenticationPage extends StatefulWidget {
  final AuthRedirectData? redirectData;
  const AuthenticationPage({super.key, this.redirectData});
  static String name = "AUTHENTICATION_PAGE";

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    getIt<AuthRedirectService>().clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EnvironmentsBadge(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: context.canPop()
              ? UnconstrainedBox(
                  child: GestureDetector(
                    onTap: () {
                      context.pop();
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: AppColors.blue65BAF0),
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: AppColors.white,
                        size: 14,
                      ),
                    ),
                  ),
                )
              : null,
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: const [
                    Color(0xFFFFFFFF),
                    Color(0xFFFFFEFE),
                    Color(0xFF64DCFD),
                    Color(0xFF156CE4),
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(appPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Gap(80 + MediaQuery.of(context).padding.top),
                    _infoTile(label: "Meubles"),
                    _infoTile(label: "Résidences"),
                    _infoTile(label: "Locations"),
                    Gap(180),
                    Image.asset(
                      Assets.icon.iconRadius.path,
                      width: 63,
                      height: 63,
                    ),
                    Gap(15),
                    Text("Commencez à visiter, louer, acheter, réserver",
                        // textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        )),
                    Gap(80),
                    CustomButtom(
                      text: "Connexion",
                      onClick: () {
                        context.pushNamed(LoginPage.name,
                            extra: widget.redirectData);
                      },
                      color: AppColors.customBlue,
                      borderRadius: BorderRadius.circular(radiusButton),
                    ),
                    Gap(6),
                    CustomButtom(
                      onClick: () {
                        context.pushNamed(
                          RegisterPage.name,
                          extra: widget.redirectData,
                        );
                      },
                      color: AppColors.whiteBackground,
                      textColor: AppColors.black,
                      borderRadius: BorderRadius.circular(radiusButton),
                      child: FittedBox(
                        child: RichText(
                          text: TextSpan(
                            text: "Vous n’avez pas de compte ? ",
                            children: [
                              TextSpan(
                                text: "Inscrivez-vous",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              )
                            ],
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Gap(10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile({required String label}) {
    return Text(
      label,
      style: TextStyle(
        color: AppColors.black,
        fontSize: 40,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
