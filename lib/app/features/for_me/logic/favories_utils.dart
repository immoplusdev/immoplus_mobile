import 'package:immoplus/app/core/config/isar_config.dart';
import 'package:immoplus/app/core/services/analytics_service.dart';
import 'package:immoplus/app/data/models/local/fovorite_model.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/features/residence_detail/residence_page.dart';
import 'package:immoplus/app/data/models/remote/furniture/furniture_model.dart';
import 'package:immoplus/app/features/furniture_detail/furniture_detail_page.dart';
import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';

@singleton
class FavoriesUtils {
  IsarConfig isarConfig;
  AnalyticsService analyticsService;
  FavoriesUtils(this.isarConfig, this.analyticsService);
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
        ..destination = ResidencePage.route(residence.id)
        ..itemScore = residence.score?.toDouble()
        ..type = residence.typeResidence);
    });
    analyticsService.logAddToWishlist(
      itemId: residence.id,
      itemName: residence.nom,
      itemCategory: residence.typeResidence,
    );
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
        ..itemScore = bienImmobilierModel.score?.toDouble()
        ..type = bienImmobilierModel.typeBienImmobilier);
    });
    analyticsService.logAddToWishlist(
      itemId: bienImmobilierModel.id,
      itemName: bienImmobilierModel.nom,
      itemCategory: bienImmobilierModel.typeBienImmobilier,
    );
  }

  addFurnitureToFavorites(FurnitureModel furnitureModel) async {
    await isarConfig.instance.writeTxn(() async {
      await isarConfig.instance.fovoriteModels.put(FovoriteModel()
        ..itemId = furnitureModel.id
        ..adress = furnitureModel.adresse
        ..name = furnitureModel.titre
        ..images = furnitureModel.images
        ..date = DateTime.now()
        ..destination = FurnitureDetailPage.route(furnitureModel.id)
        ..type = furnitureModel.type);
    });
    analyticsService.logAddToWishlist(
      itemId: furnitureModel.id,
      itemName: furnitureModel.titre,
      itemCategory: furnitureModel.type ?? '',
    );
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
