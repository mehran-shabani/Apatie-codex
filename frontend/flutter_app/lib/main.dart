import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';

Future<void> main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    final storage = await HydratedStorage.build(
      storageDirectory: await getApplicationSupportDirectory(),
    );

    HydratedBlocOverrides.runZoned(
      () => runApp(App()),
      storage: storage,
    );
  }, (error, stack) {
    // TODO: Log errors to a remote service (e.g., Sentry, Firebase Crashlytics)
    debugPrint('Caught unhandled error: $error');
    debugPrint(stack.toString());
  });
}
