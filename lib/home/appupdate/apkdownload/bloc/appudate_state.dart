part of 'appudate_bloc.dart';

@immutable
class AppudateState extends Equatable {
  final double? progress;
  final bool? isButtonDisabled;
  final bool? isDownloading;
  final Failure? error;

  const AppudateState({
    this.progress,
    this.isButtonDisabled,
    this.isDownloading,
    this.error,
  });

  factory AppudateState.initial() {
    return const AppudateState(
      progress: null,
      isButtonDisabled: null,
      isDownloading: null,
      error: null,
    );
  }

  factory AppudateState.downloading({double? progress = 0.0}) {
    return AppudateState(
      progress: progress,
      isButtonDisabled: true,
      isDownloading: true,
      error: null,
    );
  }

  factory AppudateState.downloaded({double? progress}) {
    // InstallPlugin.installApk(_apkFilePath, 'app.healthyentrepreneurs.nl.he');
    return AppudateState(
      progress: progress,
      isButtonDisabled: false,
      isDownloading: false,
      error: null,
    );
  }

  factory AppudateState.error(Failure error) {
    return AppudateState(
      progress: null,
      isButtonDisabled: null,
      isDownloading: null,
      error: error,
    );
  }

  AppudateState copyWith({
    double? progress,
    bool? isButtonDisabled,
    bool? isDownloading,
    Failure? error,
  }) {
    return AppudateState(
      progress: progress ?? this.progress,
      isButtonDisabled: isButtonDisabled ?? this.isButtonDisabled,
      isDownloading: isDownloading ?? this.isDownloading,
      error: error ?? this.error,
    );
  }

  bool get gisButtonDisabled => isButtonDisabled ?? false;
  bool get gisDownloading => isDownloading ?? false;
  double get gprogress => progress ?? 0.0;
  @override
  List<Object?> get props => [progress, isButtonDisabled, isDownloading, error];
}
