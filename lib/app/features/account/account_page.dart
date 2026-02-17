import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/data/models/local/user_model_schema.dart';
import 'package:immoplus/app/features/account/pages/change_password.dart';
import 'package:immoplus/app/features/account/pages/edit_account.dart';
import 'package:immoplus/app/features/account/widgets/general_condition_page.dart';
import 'package:immoplus/app/features/account/widgets/profile_hearder.dart';
import 'package:immoplus/app/features/authentification/authentification_page.dart';
import 'package:immoplus/app/features/booking_history/booking_history_page.dart';
import 'package:immoplus/app/features/notification/pages/notification_page.dart';
import 'package:immoplus/app/features/paymebt_history/payment_history_page.dart';
import 'package:immoplus/app/features/visit_history/visit_history_page.dart';
import 'package:immoplus/app/logic/authentification/delete_account_cubit.dart';
import 'package:immoplus/app/logic/authentification/delete_account_cubit_state.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:permission_handler/permission_handler.dart';

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
    if (mounted) {
      setState(() {});
    }
  }

  openSetting() {
    showCupertinoModalPopup<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Voulez-vous ouvrir les paramètres ?'),
        content:
            Text("Pour voir les permissions veuillez ouvrir les paramètres"),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            // isDestructiveAction: true,
            isDefaultAction: false,
            onPressed: () {
              context.pop();
            },
            child: const Text('Retour'),
          ),
          CupertinoDialogAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as deletion, and turns
            /// the action's text color to red.
            isDefaultAction: true,
            onPressed: () {
              context.pop();
              openAppSettings();
            },
            child: const Text('Paramètre'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return currentUser == null
        ? const AuthenticationPage()
        : Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.all(appPadding),
              child: CustomScrollView(
                slivers: [
                  // Header Section
                  const SliverGap(45),
                  ProfileHearder(
                    currentUser: currentUser,
                  ),
                  const SliverGap(18),
                  // List Sections
                  SliverToBoxAdapter(
                    child: ListTile(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                              20,
                            ),
                            topRight: Radius.circular(20)),
                      ),
                      tileColor: AppColors.scafold,
                      onTap: () async {
                        await context.pushNamed(EditAccountPage.name);
                        await sessionManager.getCurrentUser();

                        currentUser = sessionManager.currentUser;

                        if (mounted) {
                          setState(() {});
                        }
                      },
                      horizontalTitleGap: 0,
                      leading: Icon(
                        CupertinoIcons.person,
                        color: Colors.amber.shade800,
                      ),
                      title: const Text('Informations personnelles '),
                      trailing: Icon(
                        FontAwesomeIcons.circleChevronRight,
                        size: 15,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: ListTile(
                      tileColor: AppColors.scafold,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(
                            20,
                          ),
                          bottomLeft: Radius.circular(
                            20,
                          ),
                        ),
                      ),
                      onTap: () {
                        context.pushNamed(ChangePassword.name);
                      },
                      horizontalTitleGap: 0,
                      leading: const Icon(
                        FontAwesomeIcons.lock,
                        color: Colors.blue,
                        size: 20,
                      ),
                      title: const Text('Changer mon mot de passe'),
                      trailing: Icon(
                        FontAwesomeIcons.circleChevronRight,
                        size: 15,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  //
                  const SliverGap(10),
                  SliverToBoxAdapter(
                    child: ListTile(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                              20,
                            ),
                            topRight: Radius.circular(20)),
                      ),
                      tileColor: AppColors.scafold,
                      onTap: () {
                        showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          isScrollControlled: true,
                          useRootNavigator: true,
                          showDragHandle: true,
                          context: context,
                          builder: (context) => const FractionallySizedBox(
                              heightFactor: 0.9, child: GeneralConditionPage()),
                        );
                      },
                      horizontalTitleGap: 0,
                      leading: const Icon(
                        CupertinoIcons.text_alignleft,
                        color: Colors.black,
                      ),

                      // Icon(
                      //   FontAwesomeIcons.key,
                      //   color: AppColors.primary,
                      //   size: 20,
                      // ),
                      title: const Text('Termes et conditions'),

                      trailing: Icon(
                        FontAwesomeIcons.circleChevronRight,
                        size: 15,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: ListTile(
                      tileColor: AppColors.scafold,
                      onTap: openSetting,
                      horizontalTitleGap: 0,
                      leading: Icon(
                        FontAwesomeIcons.gears,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      title: const Text('Permissions'),
                      trailing: Icon(
                        FontAwesomeIcons.circleChevronRight,
                        size: 15,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: ListTile(
                      tileColor: AppColors.scafold,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(
                            20,
                          ),
                          bottomLeft: Radius.circular(
                            20,
                          ),
                        ),
                      ),
                      onTap: () {
                        context.pushNamed(NotificationsPage.name);
                      },
                      horizontalTitleGap: 0,
                      leading: const Icon(
                        FontAwesomeIcons.bell,
                        color: Colors.orange,
                        size: 20,
                      ),
                      title: const Text('Notification'),
                      trailing: Icon(
                        FontAwesomeIcons.circleChevronRight,
                        size: 15,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  //
                  const SliverGap(10),
                  SliverToBoxAdapter(
                    child: ListTile(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                              20,
                            ),
                            topRight: Radius.circular(20)),
                      ),
                      tileColor: AppColors.scafold,
                      onTap: () {
                        context.pushNamed(BookingHistoryPage.name);
                      },
                      horizontalTitleGap: 0,
                      leading: const Icon(
                        FontAwesomeIcons.doorOpen,
                        color: Colors.deepPurpleAccent,
                        size: 20,
                      ),
                      title: const Text('Historiques des réservations'),
                      trailing: Icon(
                        FontAwesomeIcons.circleChevronRight,
                        size: 15,
                        color: AppColors.primary,
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: ListTile(
                      tileColor: AppColors.scafold,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(
                            20,
                          ),
                          bottomLeft: Radius.circular(
                            20,
                          ),
                        ),
                      ),
                      onTap: () {
                        context.pushNamed(VisitHistoryPage.name);
                      },
                      horizontalTitleGap: 0,
                      leading: const Icon(
                        FontAwesomeIcons.personWalkingLuggage,
                        color: Colors.purple,
                      ),
                      title: const Text('Historiques des visites'),
                      trailing: Icon(
                        FontAwesomeIcons.circleChevronRight,
                        size: 15,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  //
                  const SliverGap(10),
                  SliverToBoxAdapter(
                    child: ListTile(
                      tileColor: AppColors.scafold,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onTap: () {
                        context.pushNamed(PaymentHistoryPage.name);
                      },
                      horizontalTitleGap: 0,
                      leading: const Icon(
                        FontAwesomeIcons.moneyBills,
                        color: Colors.green,
                        size: 20,
                      ),
                      title: const Text('Paiements'),
                      trailing: Icon(
                        FontAwesomeIcons.circleChevronRight,
                        size: 15,
                        color: AppColors.primary,
                      ),
                    ),
                  ),

                  const SliverGap(15),
                  SliverToBoxAdapter(
                    child: ListTile(
                      tileColor: AppColors.scafold,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onTap: () {
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return CupertinoAlertDialog(
                              title: const SizedBox(
                                child: Center(
                                  child: Icon(
                                    Icons.exit_to_app_rounded,
                                    size: 60,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              content: const Text(
                                  'Souhaitez vous vous déconnecter ?'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text(
                                    'Annuler',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text(
                                    'Se déconnecter',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () async {
                                    await sessionManager.logout();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      horizontalTitleGap: 0,
                      leading: const Icon(
                        FontAwesomeIcons.rightFromBracket,
                        color: Colors.red,
                        size: 20,
                      ),
                      title: const Text('Se déconnecter'),
                      trailing: Icon(
                        FontAwesomeIcons.circleChevronRight,
                        size: 15,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SliverGap(20),
                  SliverToBoxAdapter(
                    child: ListTile(
                      //tileColor: AppColors.scafold,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onTap: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return BlocProvider(
                              create: (context) => DeleteAccountCubit(),
                              child: BlocConsumer<DeleteAccountCubit,
                                  DeleteAccountState>(
                                listener: (context, state) {},
                                builder: (context, state) {
                                  return CupertinoAlertDialog(
                                    title: const Text('Suppression de compte'),
                                    content: const Text(
                                      'Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible.',
                                    ),
                                    actions: <Widget>[
                                      CupertinoDialogAction(
                                        isDefaultAction: true,
                                        onPressed: () {
                                          Navigator.of(dialogContext).pop();
                                        },
                                        child: const Text('Annuler'),
                                      ),
                                      CupertinoDialogAction(
                                        isDestructiveAction: true,
                                        onPressed: state.maybeWhen(
                                          loading: () => null,
                                          orElse: () => () {
                                            context
                                                .read<DeleteAccountCubit>()
                                                .deleteAccount();
                                          },
                                        ),
                                        child: state.maybeWhen(
                                          loading: () =>
                                              const CupertinoActivityIndicator(),
                                          orElse: () =>
                                              const Text('Oui, supprimer'),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                      horizontalTitleGap: 0,
                      leading: const Icon(
                        FontAwesomeIcons.userXmark,
                        color: Colors.red,
                        size: 20,
                      ),
                      title: const Text('Supprimer mon compte'),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
