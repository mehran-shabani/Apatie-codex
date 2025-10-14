import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'package:apatie/shared/config/app_config.dart';

import 'app.dart';

Future<void> main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    final config = await AppConfig.load();

    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorageDirectory.web
          : HydratedStorageDirectory(
              (await getApplicationSupportDirectory()).path,
            ),
    );

    runApp(App(config: config));
  }, (error, stack) {
    debugPrint('Caught unhandled error: $error');
    debugPrint(stack.toString());
  });
}
