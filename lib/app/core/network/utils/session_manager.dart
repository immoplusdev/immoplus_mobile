import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/config/isar_config.dart';
import 'package:immoplus/app/core/services/analytics_service.dart';
import 'package:immoplus/app/data/models/local/user_preference_schema.dart';
import 'package:immoplus/app/data/models/remote/configs/config_model.dart';
import 'package:immoplus/app/data/models/local/user_model_schema.dart';
import 'package:immoplus/app/routes/app_router.dart';
import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../../data/models/local/onboarding_schema.dart';

@singleton
class SessionManager {
  //final isarConfig = getIt<IsarConfig>();
  IsarConfig isarConfig;
  SessionManager(this.isarConfig);

  UserModelSchema? currentUser;
  ConfigModel? configModel = ConfigModel.fromJson({
    "data": {
      "id": "6133a1fd-3292-42d8-9d1a-c37c57cac7ca",
      "websiteUrl": null,
      "normalVisitPrice": 100,
      "expressVisitPrice": 100,
      "pourcentageCommissionReservation": 1,
      "projectName": "My Project",
      "projectUrl": null,
      "smsSenderName": null,
      "proximityRadius": null,
      "standardShippingPrice": null,
      "flashShippingPrice": null,
      "contactEmail": "support@immoplus.ci",
      "contactPhoneNumber": "2250720154645",
      "createdAt": "2024-08-19T16:16:50.682Z",
      "updatedAt": "2024-08-27T11:08:45.420Z",
      "deletedAt": null,
      "categories": [],
      "categoryPaymentTypes": [],
      "defaultStatus": [],
      "galleryGroups": [],
      "languages": [],
      "orderPaymentTypes": [],
      "paymentStatus": [],
      "productTypes": [],
      "servicePaymentTypes": [],
      "serviceStatus": [],
      "shippingStatus": [],
      "shippingTypes": [],
      "visitPaymentTypes": [],
      "typesResidence": [
        {"text": "Appartement", "value": "appartement"},
        {"text": "Maison", "value": "maison"},
        {"text": "Villa", "value": "villa"}
      ],
      "typesDemandeVisite": [
        {"text": "all.enum.express", "value": "express"},
        {"text": "all.enum.normal", "value": "normal"}
      ]
    }
  });

  Future<void> saveUser(UserModelSchema user) async {
    await isarConfig.instance.writeTxn(() async {
      await isarConfig.instance.userModelSchemas.put(user);
    });
    currentUser = user;
  }

  /// logout user clear session and navigate to login page
  Future<void> logout() async {
    getIt<AnalyticsService>().clearUserIdentity();
    await clearSession();
    OneSignal.logout();
    AppRouter.router.go('/');
    // AppRouter.router.goNamed(SplashScreen.name);
  }

  Future<UserModelSchema?> getCurrentUser() async {
    print('Get User ${currentUser?.firstName}');
    if (currentUser == null) {
      final user =
          await isarConfig.instance.userModelSchemas.where().findFirst();
      if (user != null) {
        currentUser = user;
      }
    }
    return currentUser;
  }

  Future<void> clearSession() async {
    await isarConfig.instance.writeTxn(() async {
      await isarConfig.instance.userModelSchemas.clear();
    });
    currentUser = null;
  }

  Future<UserModelSchema?> getUserInIsolate() async {
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [UserModelSchemaSchema],
      directory: dir.path,
      name: 'second',
    );
    return await isar.userModelSchemas.get(1);
  }

  /// Marque l'onboarding comme lu/vu par l'utilisateur
  Future<void> markOnboardingAsRead() async {
    await isarConfig.instance.writeTxn(() async {
      // On vide l'ancienne collection pour éviter les doublons de version
      await isarConfig.instance.onboardingSchemas.clear();

      await isarConfig.instance.onboardingSchemas.put(
        OnboardingSchema()
          ..hasReadOnboarding = true
          ..readAt = DateTime.now()
          ..version = 2, // L'onboarding actuel est la version 2
      );
    });
  }

  /// Vérifie si l'utilisateur a déjà vu l'onboarding (version la plus récente)
  Future<bool> hasReadOnboarding() async {
    final onboardingData =
        await isarConfig.instance.onboardingSchemas.where().findFirst();

    // On s'assure que l'utilisateur a vu la V2 de l'onboarding
    if (onboardingData?.hasReadOnboarding == true) {
      if (onboardingData!.version >= 2) {
        return true;
      }
    }
    return false;
  }

  /// Réinitialise le statut de l'onboarding (utile pour les tests)
  Future<void> resetOnboarding() async {
    await isarConfig.instance.writeTxn(() async {
      await isarConfig.instance.onboardingSchemas.clear();
    });
  }

  /// Sauvegarder les préférences locales
  Future<void> saveLocalPreferences(UserPreferenceSchema prefs) async {
    await isarConfig.instance.writeTxn(() async {
      await isarConfig.instance.userPreferenceSchemas.clear();
      await isarConfig.instance.userPreferenceSchemas.put(prefs);
    });
  }

  /// Récupérer les préférences locales
  Future<UserPreferenceSchema?> getLocalPreferences() async {
    return await isarConfig.instance.userPreferenceSchemas.where().findFirst();
  }

  /// Supprimer les préférences locales
  Future<void> clearLocalPreferences() async {
    await isarConfig.instance.writeTxn(() async {
      await isarConfig.instance.userPreferenceSchemas.clear();
    });
  }
}
