import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:he/home/home.dart';
import 'package:he/service/work_manager_service.dart';
import 'package:intl/intl.dart';

import '../../objects/blocs/blocs.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({Key? key}) : super(key: key);
  static Route<void> route() {
    return MaterialPageRoute(builder: (_) => const BackupPage());
  }

  @override
  _BackupPageState createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<BackupPage> {
  late final AnimationController _backupController;
  late final Animation<double> _backupScaleAnimation;
  bool isFirstBuild = true;

  @override
  void initState() {
    super.initState();
    _backupController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _backupScaleAnimation = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.0, end: 1.3),
        weight: 50,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.3, end: 1.0),
        weight: 50,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _backupController,
        curve: Curves.easeInOut,
      ),
    );
    _backupController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _backupController.reset();
      }
    });
    context.read<StatisticsBloc>().add(
          const LoadStateEvent(),
        );
  }

  @override
  void dispose() {
    _backupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // bool? isUploadingData =
    //     context.watch<DatabaseBloc>().state.backupdataModel?.isUploadingData;
    // double? uploadProgress =
    //     context.watch<DatabaseBloc>().state.backupdataModel?.uploadProgress;

    bool? isUploadingData = context.select(
        (StatisticsBloc bloc) => bloc.state.backupdataModel?.isUploadingData);
    double? uploadProgress = context.select(
        (StatisticsBloc bloc) => bloc.state.backupdataModel?.uploadProgress);
    return Scaffold(
      appBar: HeAppBar(
        course: 'Sync Data',
        appbarwidget: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
        transparentBackground: false,
      ),
      backgroundColor: const Color(0xfff6f6f6),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: ListView(
            children: [
              // ... (Rest of the ListView children code)
              SingleSection(
                title: "",
                children: [
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _buildBackupIconWidget(),
                            SizedBox(
                              width: MediaQuery.of(context).size.width *
                                  0.6, //150, // Adjust this value as needed
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: SizedBox(
                                  height: 65,
                                  child: Column(
                                    children: <Widget>[
                                      const Spacer(),
                                      _buildLastBackupDate(),
                                      const SizedBox(height: 5.0),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          "You can upload the local data sets when you get online by tapping the below button.",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              _buildProgressWidget(uploadProgress, isUploadingData),
              SingleSection(
                title: "Data Statistics",
                children: [_buildSurveyIconWidget(), _buildBookIconWidget()],
              ),
              // SingleSection(
              //   title: "Control Animations",
              //   children: [
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: [
              //         ElevatedButton(
              //           onPressed: () {
              //             _uploadDataTest();
              //           },
              //           child: const Text('StartB'),
              //         ),
              //         ElevatedButton(
              //           onPressed: () {
              //             _cleanDataTest();
              //           },
              //           child: const Text('CleanB'),
              //         ),
              //         ElevatedButton(
              //           onPressed: () {
              //             _generateDataTest();
              //           },
              //           child: const Text('Generate D'),
              //         ),
              //       ],
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  _uploadData() async {
    if (!mounted) return;
    debugPrint('@_uploadData isUploadingData');
    final workManagerService = GetIt.I<WorkManagerService>();
    await workManagerService.registerUploadDataTask();
    // _taskRegistered = true;
    // final databaseRepo = GetIt.I<DatabaseRepository>();
    // databaseRepo.uploadData();
  }

  _uploadDataTest() async {
    if (!mounted) return;
    final databaseRepo = GetIt.I<DatabaseRepository>();
    databaseRepo.uploadData();
  }

  _cleanDataTest() async {
    if (!mounted) return;
    final databaseRepo = GetIt.I<DatabaseRepository>();
    databaseRepo.cleanUploadedData();
  }

  _generateDataTest() async {
    if (!mounted) return;
    final databaseRepo = GetIt.I<DatabaseRepository>();
    databaseRepo.createDummyData();
  }

  void _updateAnimationStatus(StatisticsState state) {
    bool backupAnimation = state.backupdataModel?.backupAnimation ?? false;
    if (backupAnimation) {
      if (!_backupController.isAnimating) {
        _backupController.repeat(reverse: true);
      }
    } else {
      if (_backupController.isAnimating) {
        _backupController.stop();
      }
    }
  }

  Widget _buildProgressWidget(uploadProgress, isUploadingData) {
    double _uploadProgress = uploadProgress ?? 0.0;
    bool isUploading = isUploadingData ?? false;
    return SingleSection(
      title: "",
      children: [
        isUploading && _uploadProgress < 1
            ? LinearProgressIndicator(
                value: _uploadProgress,
                minHeight: 5,
              )
            : InkWell(
                onTap: () async {
                  _uploadData();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: const Text(
                    "Upload Data",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
        const SizedBox(height: 5),
        (_uploadProgress > 0 && _uploadProgress < 1) ||
                (!isUploading && _uploadProgress > 0)
            ? Text(
                '${(_uploadProgress * 100).toStringAsFixed(0)}%',
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildBackupIconWidget() {
    return BlocListener<StatisticsBloc, StatisticsState>(
      listenWhen: (previous, current) {
        return previous.backupdataModel?.backupAnimation !=
            current.backupdataModel?.backupAnimation;
      },
      listener: (context, state) {
        _updateAnimationStatus(state);
      },
      child: RepaintBoundary(
        child: TickerMode(
          enabled: context
                  .read<StatisticsBloc>()
                  .state
                  .backupdataModel
                  ?.backupAnimation ??
              false,
          child: AnimatedBuilder(
            animation: _backupScaleAnimation,
            builder: (context, child) => Transform.scale(
              scale: _backupScaleAnimation.value,
              child: Icon(
                Icons.backup_sharp,
                size: 75,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSurveyIconWidget() {
    return BlocBuilder<StatisticsBloc, StatisticsState>(
        buildWhen: (previous, current) {
      final surveysStillRunning = previous.backupdataModel?.surveyAnimation !=
          current.backupdataModel?.surveyAnimation;
      final listLengthChanged = previous.listOfSurveyDataModel?.length !=
          current.listOfSurveyDataModel?.length;
      return listLengthChanged || surveysStillRunning;
    }, builder: (context, state) {
      int? unsentSurveysCountText = state.listOfSurveyDataModel?.length;
      bool surveyAnimation = state.backupdataModel?.surveyAnimation ?? false;
      const iconSize = 24.0;

      if (state.listOfSurveyDataModel == null) {
        debugPrint(
            'MIKEPAMPA BEFORE ${state.listOfSurveyDataModel.toString()}');
        context
            .read<StatisticsBloc>()
            .add(const ListSurveyTesting(isPending: true));
      } else {
        unsentSurveysCountText = state.listOfSurveyDataModel?.length;
      }

      return ListTile(
        title: const Text(
          "Surveys",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            fontSize: 17,
          ),
        ),
        leading: Icon(
          Icons.library_books,
          color: Theme.of(context).primaryColor,
        ),
        subtitle: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 15,
              color: Colors.blueGrey,
            ),
            children: <TextSpan>[
              TextSpan(
                text: '${unsentSurveysCountText ?? '..'}',
                style: const TextStyle(color: Colors.red, fontSize: 17),
              ),
              const TextSpan(text: ' to be uploaded'),
            ],
          ),
        ),
        trailing: surveyAnimation
            ? SizedBox(
                width: iconSize,
                height: iconSize,
                child: SpinKitRing(
                  lineWidth: 1,
                  color: Theme.of(context).primaryColor,
                  size: iconSize,
                ),
              )
            : const Icon(
                Icons.sync,
                size: iconSize,
                weight: 1,
                color: Colors.blueGrey,
              ),
        onTap: () {
          // Show dialog to choose backup frequency
        },
      );
    });
  }

  Widget _buildBookIconWidget() {
    return BlocBuilder<StatisticsBloc, StatisticsState>(
        buildWhen: (previous, current) {
      final booksStillRunning = previous.backupdataModel?.booksAnimation !=
          current.backupdataModel?.booksAnimation;
      final listLengthChanged = previous.listOfBookDataModel?.length !=
          current.listOfBookDataModel?.length;
      return listLengthChanged || booksStillRunning;
    }, builder: (context, state) {
      int? unsentBooksCountText = state.listOfBookDataModel?.length;
      bool booksAnimation = state.backupdataModel?.booksAnimation ?? false;
      const iconSize = 24.0;
      // String unsentBooksCountText;
      if (state.listOfBookDataModel == null) {
        debugPrint('MIKEPAMPA BEFORE ${state.listOfBookDataModel.toString()}');
        context
            .read<StatisticsBloc>()
            .add(const ListBooksTesting(isPending: true));
        // context.read<DatabaseBloc>().add(const DbCountSurveyEvent());
      } else {
        unsentBooksCountText = state.listOfBookDataModel?.length;
      }
      return ListTile(
        title: const Text(
          "Books",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            fontSize: 17,
          ),
        ),
        leading: Icon(
          Icons.menu_book,
          color: Theme.of(context).primaryColor,
        ),
        subtitle: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 15,
              color: Colors.blueGrey,
            ),
            children: <TextSpan>[
              TextSpan(
                text: '${unsentBooksCountText ?? '..'}',
                style: const TextStyle(color: Colors.red, fontSize: 17),
              ),
              const TextSpan(text: ' to be uploaded'),
            ],
          ),
        ),
        trailing: booksAnimation
            ? SizedBox(
                width: iconSize,
                height: iconSize,
                child: SpinKitRing(
                  lineWidth: 1,
                  color: Theme.of(context).primaryColor,
                  size: iconSize,
                ),
              )
            : const Icon(
                Icons.sync,
                size: iconSize,
                weight: 1,
                color: Colors.blueGrey,
              ),
        onTap: () {
          // Show dialog to choose backup frequency
        },
      );
    });
  }

  Widget _buildLastBackupDate() {
    return BlocBuilder<StatisticsBloc, StatisticsState>(
      buildWhen: (previous, current) {
        var currentProgress = current.backupdataModel?.uploadProgress;
        var previousDate = previous.backupdataModel?.dateCreated;
        var currentDate = current.backupdataModel?.dateCreated;
        debugPrint(
            "DATES previousDate $previousDate and currentDate $currentDate");
        var previousUploading = previous.backupdataModel?.isUploadingData;
        var currentUploading = current.backupdataModel?.isUploadingData;
        debugPrint(
            "UPLOADNA previousUploading $previousUploading and currentUploading $currentUploading isFirstBuild $isFirstBuild currentProgress $currentProgress");
        bool shouldRebuild = (isFirstBuild && currentProgress == 0.0) ||
            (previousDate != currentDate &&
                previousUploading == true &&
                currentUploading == false);

        isFirstBuild = false;
        debugPrint(
            'NAKAisFirstBuild $isFirstBuild shouldRebuildNaka $shouldRebuild');
        return shouldRebuild;
      },
      builder: (context, state) {
        final lastBackup = state.backupdataModel?.dateCreated;
        debugPrint(
            'MPOLA $lastBackup and ${state.backupdataModel?.dateCreated} isFirstBuild $isFirstBuild');
        return RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 16,
              color: Colors.blueGrey,
            ),
            children: <TextSpan>[
              const TextSpan(text: 'Last Updated: '),
              TextSpan(
                text: formatRelativeDate(lastBackup),
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        );
      },
    );
  }

  String formatRelativeDate(DateTime? date) {
    if (date != null) {
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'Today at ${DateFormat('h:mm a').format(date)}';
      } else if (difference.inDays == 1) {
        return 'Yesterday at ${DateFormat('h:mm a').format(date)}';
      } else if (difference.inDays >= 2 && difference.inDays <= 3) {
        return '${difference.inDays} days ago at ${DateFormat('h:mm a').format(date)}';
      } else {
        return '${DateFormat('MMM d, yyyy').format(date)} at ${DateFormat('h:mm a').format(date)}';
      }
    } else {
      return '..';
    }
  }
}
