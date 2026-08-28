import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/reverse_search/reverse_search_model.dart';
import 'package:immoplus/app/features/payment_module/operators_selector_page.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_adapter.dart';
import 'package:immoplus/app/features/suggest/logic/reverse_search_cubit.dart';
import 'package:immoplus/app/features/suggest/pages/reverse_search_map_page.dart';

/// Point d'entrée unique pour reprendre une recherche inversée active depuis
/// n'importe quel écran (bouton flottant, bandeau de verrouillage sur une
/// autre résidence...), sans dupliquer la logique de résumé déjà utilisée par
/// `ReverseSearchPage`.
class ReverseSearchNavigation {
  ReverseSearchNavigation._();

  /// Reprend une recherche encore active (statut `en_recherche`) sur la carte
  /// des résultats, avec la résidence verrouillée épinglée le cas échéant.
  static void resumeToMap(BuildContext context, ReverseSearchItem item) {
    final cubit = getIt<ReverseSearchCubit>();
    final request = item.toRequest();

    cubit.resumeSearch(
      item.id,
      request,
      propositions: item.propositionsList,
      pendingSelection: item.pendingSelectionProposition,
      selectionExpireAt: item.selectionExpireAt,
    );

    context.pushNamed(
      ReverseSearchMapPage.routeName,
      extra: {'cubit': cubit, 'request': request},
    );
  }

  /// Sélection déjà verrouillée (statut `selection_en_attente_paiement`) :
  /// direction directe vers le paiement.
  static void resumeToPayment(BuildContext context, ReverseSearchItem item) {
    context.pushNamed(
      OperatorsSelectorPage.name,
      extra: PaymentPageAdapter(
        itemId: item.id,
        collection: ProductType.reverse_searches.name,
        amount: (item.montantSelectionne ?? 0).toInt(),
      ),
    );
  }

  /// Reprend au bon endroit selon le statut courant de [item].
  static void resume(BuildContext context, ReverseSearchItem item) {
    if (item.statusEnum.isSelectionEnAttentePaiement) {
      resumeToPayment(context, item);
    } else {
      resumeToMap(context, item);
    }
  }
}
