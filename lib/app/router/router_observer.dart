import 'package:flutter/widgets.dart';
import 'package:flutter_template/core/services/logger_service.dart';

/// Navigation observer that logs route transitions using [LoggerService].
class RouterObserver extends NavigatorObserver {
  RouterObserver(this._logger);

  final LoggerService _logger;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logger.info('[Router] Pushed: ${route.settings.name ?? route.settings.toString()}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _logger.info('[Router] Popped: ${route.settings.name ?? route.settings.toString()}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _logger.info('[Router] Replaced: ${oldRoute?.settings.name} -> ${newRoute?.settings.name}');
  }
}
