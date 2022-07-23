import 'package:flutter/foundation.dart';

/// {@printOnlyDebug} Print Only in debug mode
void printOnlyDebug(Object objectPrint) {
  if (kDebugMode) {
    print(objectPrint);
  }
}
