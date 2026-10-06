import 'package:flutter/services.dart' show appFlavor;
import 'package:flutter_template/bootstrap.dart';
import 'package:flutter_template/core/config/flavor.dart';

void main() => bootstrap(flavor: Flavor.fromAppFlavor(appFlavor));
