import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockHydratedStorage extends Mock implements HydratedStorage {}

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
}) {
  final storage = buildMockHydratedStorage(storageValues: storageValues);
  return HydratedBlocOverrides.runZoned<Future<T>>(
    body,
    storage: storage,
  );
}
