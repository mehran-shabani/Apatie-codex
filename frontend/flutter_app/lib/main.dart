import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = await HydratedStorage.build(
    storageDirectory: await getApplicationSupportDirectory(),
  );

  HydratedBlocOverrides.runZoned(
    () => runApp(App()),
    storage: storage,
  );
}
