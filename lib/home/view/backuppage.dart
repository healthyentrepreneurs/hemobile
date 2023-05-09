import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:he/home/home.dart';
import 'package:he/objects/blocs/hedata/bloc/database_bloc.dart';
import 'package:he/objects/blocs/repo/database_repo.dart';
import 'package:he/service/work_manager_service.dart';

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
  late final AnimationController _surveyController;
  late final AnimationController _booksController;
  late final Animation<double> _backupScaleAnimation;
  late final Animation<double> _surveyRotationAnimation;
  late final Animation<double> _booksRotationAnimation;
  late final WorkManagerService workManagerService;

  @override
  void initState() {
    super.initState();
    workManagerService = WorkManagerService();
    workManagerService.initialize();
    _backupController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _surveyController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _booksController = AnimationController(
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
    _surveyRotationAnimation = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: Tween(begin: 0.0, end: 2 * pi),
        weight: 100,
      ),
    ]).animate(_surveyController);
    _booksRotationAnimation = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: Tween(begin: 0.0, end: 2 * pi),
        weight: 100,
      ),
    ]).animate(_booksController);
    context.read<DatabaseBloc>().add(
          const LoadStateEvent(),
        );
  }

  @override
  void dispose() {
    _backupController.dispose();
    _surveyController.dispose();
    _booksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool? isUploadingData =
        context.watch<DatabaseBloc>().state.backupdataModel?.isUploadingData;
    double? uploadProgress =
        context.watch<DatabaseBloc>().state.backupdataModel?.uploadProgress;
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
                          children: [
                            _buildBackupIconWidget(),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Last backup: Today at 12:34",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                  SizedBox(height: 5.0),
                                  Text(
                                    "Total Size: 1.29 GB",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          "You can upload the local data sets when you get online by tapping the below button.",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 16),
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
              SingleSection(
                title: "Control Animations",
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _uploadData(),
                        child: Text(
                          _backupController.isAnimating
                              ? 'Stop Backup'
                              : 'Start Backup',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
    // final workManagerService = GetIt.I<WorkManagerService>();
    // await workManagerService.cancelUploadDataTask();
    // await Future.delayed(const Duration(seconds: 1));
    // await workManagerService.registerUploadDataTask();
    // _taskRegistered = true;
    final databaseRepo = GetIt.I<DatabaseRepository>();
    databaseRepo.uploadData();
  }

  void _updateAnimationStatus(DatabaseState state) {
    bool backupAnimation = state.backupdataModel?.backupAnimation ?? false;
    bool surveyAnimation = state.backupdataModel?.surveyAnimation ?? false;
    bool booksAnimation = state.backupdataModel?.booksAnimation ?? false;

    if (backupAnimation) {
      if (!_backupController.isAnimating) {
        _backupController.repeat(reverse: true);
      }
    } else {
      if (_backupController.isAnimating) {
        _backupController.stop();
      }
    }

    if (surveyAnimation) {
      if (!_surveyController.isAnimating) {
        _surveyController.repeat(reverse: true);
      }
    } else {
      if (_surveyController.isAnimating) {
        _surveyController.stop();
      }
    }

    if (booksAnimation) {
      if (!_booksController.isAnimating) {
        _booksController.repeat(reverse: true);
      }
    } else {
      if (_booksController.isAnimating) {
        _booksController.stop();
      }
    }
  }

  // Widget _buildProgressWidget(uploadProgress, isUploadingData) {
  //   double _uploadProgress = uploadProgress ?? 0.0;
  //   bool isUploading = isUploadingData ?? false;
  //   return SingleSection(
  //     title: "",
  //     children: [
  //       isUploading && _uploadProgress < 1
  //           ? LinearProgressIndicator(
  //               value: _uploadProgress,
  //               minHeight: 5,
  //             )
  //           : InkWell(
  //               onTap: () async {
  //                 _uploadData();
  //               },
  //               child: Container(
  //                 padding: const EdgeInsets.symmetric(vertical: 12.0),
  //                 alignment: Alignment.center,
  //                 decoration: BoxDecoration(
  //                   color: Theme.of(context).primaryColor,
  //                 ),
  //                 child: const Text(
  //                   "Upload Data",
  //                   style: TextStyle(color: Colors.white, fontSize: 15),
  //                 ),
  //               ),
  //             ),
  //       const SizedBox(height: 5),
  //       (_uploadProgress > 0 && _uploadProgress < 1) || !isUploading
  //           ? Text(
  //               '${(_uploadProgress * 100).toStringAsFixed(0)}%',
  //               style:
  //                   const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
  //             )
  //           : const SizedBox.shrink(),
  //     ],
  //   );
  // }

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
    return BlocListener<DatabaseBloc, DatabaseState>(
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
                  .read<DatabaseBloc>()
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
    int? countingSurveys =
        context.watch<DatabaseBloc>().state.listOfSurveyDataModel?.length;
    return BlocListener<DatabaseBloc, DatabaseState>(
        listenWhen: (previous, current) {
          return previous.backupdataModel?.surveyAnimation !=
              current.backupdataModel?.surveyAnimation;
        },
        listener: (context, state) {
          // _updateAnimationStatus(state);
        },
        child: BlocBuilder<DatabaseBloc, DatabaseState>(
            buildWhen: (previous, current) {
          final surveyStillRunning =
              previous.backupdataModel?.surveyAnimation !=
                  current.backupdataModel?.surveyAnimation;
          return surveyStillRunning;
        }, builder: (context, state) {
          bool surveyAnimation =
              state.backupdataModel?.surveyAnimation ?? false;
          // int? countSurvey = state.listOfSurveyDataModel?.length;
          const iconSize = 24.0;
          return ListTile(
            title: const Text("Surveys"),
            leading: const Icon(
              Icons.library_books,
            ),
            subtitle: Text(
                '${countingSurveys ?? '..'} to be uploaded'), //${state.surveyTotalCount}
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
                : const Icon(Icons.sync, size: iconSize, weight: 1),
          );
        }));
  }

  Widget _buildBookIconWidget() {
    return BlocListener<DatabaseBloc, DatabaseState>(
        listenWhen: (previous, current) {
          final booksStillRunning = previous.backupdataModel?.booksAnimation !=
              current.backupdataModel?.booksAnimation;
          return booksStillRunning;
        },
        listener: (context, state) {
          // _updateAnimationStatus(state);
        },
        child: BlocBuilder<DatabaseBloc, DatabaseState>(
            buildWhen: (previous, current) {
          final booksStillRunning = previous.backupdataModel?.booksAnimation !=
              current.backupdataModel?.booksAnimation;
          // return booksStillRunning;
          final listLengthChanged = previous.listOfBookDataModel?.length !=
              current.listOfBookDataModel?.length;
          return listLengthChanged || booksStillRunning;
        }, builder: (context, state) {
          int? unsentBooksCountText = state.listOfBookDataModel?.length;
          bool booksAnimation = state.backupdataModel?.booksAnimation ?? false;
          const iconSize = 24.0;
          // String unsentBooksCountText;
          if (state.listOfBookDataModel == null) {
            debugPrint(
                'MIKEPAMPA BEFORE ${state.listOfBookDataModel.toString()}');
            context
                .read<DatabaseBloc>()
                .add(const ListBooksTesting(isPending: true));
            // context.read<DatabaseBloc>().add(const DbCountSurveyEvent());
          } else {
            unsentBooksCountText = state.listOfBookDataModel?.length;
          }
          return ListTile(
            title: const Text("Books"),
            leading: const Icon(
              Icons.menu_book,
            ),
            subtitle: Text('${unsentBooksCountText ?? '..'} to be uploaded'),
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
                : const Icon(Icons.sync, size: iconSize, weight: 1),
            onTap: () {
              // Show dialog to choose backup frequency
            },
          );
        }));
  }
}
