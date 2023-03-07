import 'dart:io';

abstract class IFoFiRepository {
  File getLocalFileHe(String filename);
  bool checkFilePresentHe(String path);
  Future<bool> checkDirectoryOrCreateHe(String path);
}