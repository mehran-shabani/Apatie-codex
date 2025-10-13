import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockHydratedStorage extends Mock implements HydratedStorage {}

Storage? _tryGetCurrentStorage() {
  try {
    return HydratedBloc.storage;
  } catch (_) {
    return null;
  }
}

HydratedStorage buildMockHydratedStorage({
  Map<String, dynamic>? storageValues,
}) {
  final storage = MockHydratedStorage();

  when(() => storage.read(any())).thenAnswer((invocation) {
    final key = invocation.positionalArguments.first as String;
    return storageValues?[key];
  });
  when(() => storage.write(any(), any())).thenAnswer((_) async {});
  when(() => storage.delete(any())).thenAnswer((_) async {});
  when(() => storage.clear()).thenAnswer((_) async {});

  return storage;
}

Future<T> runHydrated<T>(
  Future<T> Function() body, {
  Map<String, dynamic>? storageValues,
  HydratedStorage? storage,
}) async {
  final effectiveStorage =
      storage ?? buildMockHydratedStorage(storageValues: storageValues);
  final previousStorage = _tryGetCurrentStorage();

  HydratedBloc.storage = effectiveStorage;
  try {
    return await body();
  } finally {
    HydratedBloc.storage = previousStorage;
  }
}
