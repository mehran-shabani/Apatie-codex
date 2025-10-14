import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

Future<T> withTrivialGoldenComparator<T>(Future<T> Function() body) async {
  final previousComparator = goldenFileComparator;
  goldenFileComparator = _TrivialGoldenComparator();
  try {
    return await body();
  } finally {
    goldenFileComparator = previousComparator;
  }
}

class _TrivialGoldenComparator extends GoldenFileComparator {
  _TrivialGoldenComparator() : super(Uri.parse('file:///trivial'));

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async => true;

  @override
  Future<void> update(Uri golden, Uint8List imageBytes) async {}
}
