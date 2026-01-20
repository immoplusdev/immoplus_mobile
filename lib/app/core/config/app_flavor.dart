class AppFlavor {
  AppFlavor._();

  static const String _flavor =
      String.fromEnvironment('FLAVOR', defaultValue: 'prod');

  static String get current => _flavor;

  static bool get isDev => _flavor == 'dev';
  static bool get isProd => _flavor == 'prod';

  static String get envFileName => isDev ? '.env.dev' : '.env.prod';

  static String get displayName {
    switch (_flavor) {
      case 'dev':
        return 'DEV';
      case 'prod':
      default:
        return 'PROD';
    }
  }
}
