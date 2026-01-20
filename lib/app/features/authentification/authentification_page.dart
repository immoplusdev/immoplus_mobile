import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/features/login_page/pages/login_with_email_screen.dart';
import 'package:immoplus/app/features/otp_login/otp_login_page.dart';
import 'package:immoplus/app/features/registration/screens/send_email_opt_page.dart';
import 'package:immoplus/app/logic/authentification/login_cubit.dart';
import 'package:immoplus/app/logic/authentification/registration_cubit.dart';
import 'package:immoplus/app/utils/app_colors.dart';

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
      child: Scaffold(
        backgroundColor: AppColors.primaryLite,
        body: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: AppColors.primaryLite,
              leadingWidth: 35,
            ),
            const SliverGap(30),

            // Titre principal
            SliverToBoxAdapter(
              child: Center(
                child: Text(
                  "Bienvenue",
                  style: context.textTheme.headlineMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SliverGap(8),

            // Sous-titre
            SliverPadding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: AutoSizeText(
                    maxLines: 1,
                    "Connectez-vous ou créez votre compte",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
            ),
            const SliverGap(30),

            // TabBar personnalisé
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: AppColors.lightBlue,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    labelColor: AppColors.primaryLite,
                    unselectedLabelColor: Colors.black,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(text: "Connexion"),
                      Tab(text: "Inscription"),
                    ],
                  ),
                ),
              ),
            ),
            const SliverGap(5),

            // Contenu des onglets
            SliverFillRemaining(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // Page de connexion
                    PageView(
                      controller: _loginPageController,
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        OTPLoginPage(
                          rootPageController: _loginPageController,
                        ),
                        LoginWithEmailScreen(
                          rootPageController: _loginPageController,
                        ),
                      ],
                    ),

                    // Page d'inscription
                    const SendEmailOptPage(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
