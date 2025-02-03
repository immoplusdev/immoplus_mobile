import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

@lazySingleton
class EnvHandler {
  init() async {
    Intl.defaultLocale = 'fr_FR';

    await initializeDateFormatting('fr_FR', null);
    await dotenv.load(fileName: ".env");
  }
}
