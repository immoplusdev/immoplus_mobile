import 'package:immoplus/app/data/models/local/onboarding_schema.dart';
import 'package:immoplus/app/data/models/local/user_model_schema.dart';
import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/models/local/fovorite_model.dart';

late final Isar _isar;

@singleton
class IsarConfig {
  /// Initialisation de la base de données Isar
  Future<void> init() async {
    _isar = await Isar.open(
      [
        UserModelSchemaSchema,
        OnboardingSchemaSchema,
        FovoriteModelSchema,
      ],
      directory:
          await getApplicationDocumentsDirectory().then((dir) => dir.path),
    );
  }

  /// Fournit une instance de Isar
  Isar get instance => _isar;
}
