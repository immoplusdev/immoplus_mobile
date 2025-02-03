import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/config/isar_config.dart';
import 'package:immoplus/app/data/models/local/fovorite_model.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

@singleton
class FavoriesUtils {
  IsarConfig isarConfig;
  FavoriesUtils(this.isarConfig);
  Future<bool> isFavorite(String itemId) async {
    return await isarConfig.instance.fovoriteModels
            .where()
            .itemIdEqualTo(itemId)
            .count() >
        0;
  }

  addResidenceToFavorites(ResidenceModel residence) async {
    await isarConfig.instance.writeTxn(() async {
      await isarConfig.instance.fovoriteModels.put(FovoriteModel()
        ..itemId = residence.id
        ..adress = residence.adresse
        ..name = residence.nom
        ..images = residence.images
        ..date = DateTime.now()
        ..destination = '/residence_detail/${residence.id}'
        ..type = residence.typeResidence);
    });
  }

  addEstateToFavorites(BienImmobilierModel bienImmobilierModel) async {
    await isarConfig.instance.writeTxn(() async {
      await isarConfig.instance.fovoriteModels.put(FovoriteModel()
        ..itemId = bienImmobilierModel.id
        ..adress = bienImmobilierModel.adresse
        ..name = bienImmobilierModel.nom
        ..images = bienImmobilierModel.images
        ..date = DateTime.now()
        ..destination = '/estate_detail/${bienImmobilierModel.id}'
        ..type = bienImmobilierModel.typeBienImmobilier);
    });
  }

  Future<void> deleteFavoriteByItemId(String itemId) async {
    await isarConfig.instance.writeTxn(() async {
      final favorite = await isarConfig.instance.fovoriteModels
          .where()
          .itemIdEqualTo(itemId)
          .findFirst();
      if (favorite != null) {
        await isarConfig.instance.fovoriteModels.delete(favorite.id);
      }
    });
  }
}
