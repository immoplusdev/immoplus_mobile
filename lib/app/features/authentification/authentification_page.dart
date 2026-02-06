import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/features/login_page/login_page.dart';
import 'package:immoplus/app/features/registration/register_page.dart';
import 'package:immoplus/app/logic/authentification/login_cubit.dart';
import 'package:immoplus/app/logic/authentification/registration_cubit.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/config_env.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:immoplus/gen/assets.gen.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});
  static String name = "AUTHENTICATION_PAGE";

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  PageController _loginPageController = PageController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<LoginCubit>()),
        BlocProvider(create: (context) => getIt<RgistrationCubitCubit>()),
      ],
      child: EnvironmentsBadge(
        child: Scaffold(
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
                      Gap(80),
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
                          context.pushNamed(LoginPage.name);
                        },
                        color: AppColors.customBlue,
                        borderRadius: BorderRadius.circular(radiusButton),
                      ),
                      Gap(6),
                      CustomButtom(
                        onClick: () {
                          context.pushNamed(RegisterPage.name);
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
