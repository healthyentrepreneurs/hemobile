abstract class Failure {
  String get message;
}

class RepositoryFailure extends Failure {
  @override
  final String message;
  RepositoryFailure(this.message);
}

class FirestoreFailure extends Failure {
  @override
  final String message;
  FirestoreFailure(this.message);
}

class ApkDownloadFailure extends Failure {
  @override
  final String message;
  ApkDownloadFailure(this.message);
}
