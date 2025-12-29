import 'package:go_router/go_router.dart';

extension GoRouterExtension on GoRouter {
  /// Obtenir la route actuelle
  String get currentLocation {
    return routeInformationProvider.value.uri.path;
  }

  /// Push seulement si différent
  void pushIfDifferent(String route) {
    if (!route.startsWith(currentLocation)) {
      push(route);
    }
  }
}
