// 📦 Package imports:
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

// 🌎 Project imports:
import 'dependencies.config.dart';

/// Initialises dependencies
@injectableInit
void configureDependencies() {
  $initGetIt(GetIt.I);
}
