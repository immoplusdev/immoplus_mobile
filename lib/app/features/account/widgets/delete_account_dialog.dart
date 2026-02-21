import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/logic/authentification/delete_account_cubit.dart';
import 'package:immoplus/app/logic/authentification/delete_account_cubit_state.dart';

/// Affiche la boîte de dialogue de confirmation de suppression de compte.
void showDeleteAccountDialog(BuildContext context) {
  showCupertinoDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return BlocProvider(
        create: (context) => DeleteAccountCubit(),
        child: BlocConsumer<DeleteAccountCubit, DeleteAccountState>(
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
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Annuler'),
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: state.maybeWhen(
                    loading: () => null,
                    orElse: () => () {
                      context.read<DeleteAccountCubit>().deleteAccount();
                    },
                  ),
                  child: state.maybeWhen(
                    loading: () => const CupertinoActivityIndicator(),
                    orElse: () => const Text('Oui, supprimer'),
                  ),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
