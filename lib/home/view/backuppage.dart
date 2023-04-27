import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:he/home/home.dart';
import 'package:he/objects/blocs/hedata/bloc/database_bloc.dart';
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
  bool _isDisposed = false;
  late final WorkManagerService workManagerService;

  @override
  void initState() {
    super.initState();
    // workManagerService = GetIt.I<WorkManagerService>();
    // workManagerService.initialize();
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
    _backupScaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _backupController,
        curve: Curves.easeInOut,
      ),
    );
    _surveyRotationAnimation =
        Tween(begin: 0.0, end: 2 * pi).animate(_surveyController);
    _booksRotationAnimation =
        Tween(begin: 0.0, end: 2 * pi).animate(_booksController);
    context.read<DatabaseBloc>().add(
          LoadStateEvent(
            onLoadStateChanged: _handleLoadStateEvent,
          ),
        );
  }

  @override
  void dispose() {
    _isDisposed = true;
    _backupController.dispose();
    _surveyController.dispose();
    _booksController.dispose();
    _saveState();
    super.dispose();
  }

  void _toggleAnimation(String animationType) {
    setState(() {
      if (animationType == 'backup') {
        if (_backupController.isAnimating) {
          _backupController.stop();
        } else {
          _backupController.repeat(reverse: true);
        }
      } else if (animationType == 'survey') {
        if (_surveyController.isAnimating) {
          _surveyController.stop();
        } else {
          _surveyController.repeat(reverse: true);
        }
      } else if (animationType == 'books') {
        if (_booksController.isAnimating) {
          _booksController.stop();
        } else {
          _booksController.repeat(reverse: true);
        }
      }
    });
    // _saveState();
    debugPrint("TOGGLE BACKUP ${_backupController.isAnimating}");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<DatabaseBloc, DatabaseState>(
      listenWhen: (previous, current) {
        return previous.uploadProgress != current.uploadProgress ||
            previous.isUploadingData != current.isUploadingData;
      },
      listener: (context, state) {
        debugPrint("BEYONCY ${state.uploadProgress}");
      },
      child: BlocBuilder<DatabaseBloc, DatabaseState>(
        builder: (context, state) {
          // final stateA = context.watch<DatabaseBloc>().state.backupAnimation;
          bool backupAnimation =
              context.watch<DatabaseBloc>().state.backupAnimation ?? false;
          bool surveyAnimation = context.select(
              (DatabaseBloc bloc) => bloc.state.surveyAnimation ?? false);
          bool booksAnimation = context.select(
              (DatabaseBloc bloc) => bloc.state.booksAnimation ?? false);
          bool isUploadingData =
              context.watch<DatabaseBloc>().state.isUploadingData ?? false;
          double uploadProgress =
              context.watch<DatabaseBloc>().state.uploadProgress ?? 0.0;
          debugPrint(
              "_BackupPageState@BlocBuilder@build isUploadingData $isUploadingData uploadProgress $uploadProgress backupAnimation $backupAnimation\n");
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
                                  AnimatedBuilder(
                                    animation: _backupScaleAnimation,
                                    builder: (context, child) =>
                                        Transform.scale(
                                      scale: _backupScaleAnimation.value,
                                      child: Icon(
                                        Icons.backup_sharp,
                                        size: 75,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SingleSection(
                      title: "",
                      children: [
                        state.isUploadingData ?? false
                            ? LinearProgressIndicator(
                                value: state.uploadProgress ?? 0.0,
                                minHeight: 5,
                              )
                            : InkWell(
                                onTap: () async {
                                  _uploadData();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  child: const Text(
                                    "Upload Data",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ),
                              ),
                        const SizedBox(height: 5),
                        uploadProgress > 0
                            ? Text(
                                '${(uploadProgress * 100).toStringAsFixed(0)}%',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                    SingleSection(
                      title: "Data Statistics",
                      children: [
                        ListTile(
                          title: const Text("Surveys"),
                          leading: const Icon(
                            Icons.library_books,
                          ),
                          subtitle:
                              Text('${state.surveyTotalCount} to be uploaded'),
                          trailing: AnimatedBuilder(
                            animation: _surveyRotationAnimation,
                            builder: (context, child) => Transform.rotate(
                              angle: _surveyRotationAnimation.value,
                              child: const Icon(Icons.sync),
                            ),
                          ),
                        ),
                        ListTile(
                          title: const Text("Books"),
                          leading: const Icon(
                            Icons.menu_book,
                          ),
                          subtitle: const Text('12 GB to be uploaded'),
                          trailing: AnimatedBuilder(
                            animation: _booksRotationAnimation,
                            builder: (context, child) => Transform.rotate(
                              angle: _booksRotationAnimation.value,
                              child: const Icon(Icons.sync),
                            ),
                          ),
                          onTap: () {
                            // Show dialog to choose backup frequency
                          },
                        )
                      ],
                    ),
                    SingleSection(
                      title: "Control Animations",
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () => _toggleAnimation('backup'),
                              child: Text(
                                _backupController.isAnimating
                                    ? 'Stop Backup'
                                    : 'Start Backup',
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => _toggleAnimation('survey'),
                              child: Text(
                                _surveyController.isAnimating
                                    ? 'Stop Survey'
                                    : 'Start Survey',
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => _toggleAnimation('books'),
                              child: Text(
                                _booksController.isAnimating
                                    ? 'Stop Books'
                                    : 'Start Books',
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
        },
      ),
    );
  }

  void _handleLoadStateEvent(Map<String, dynamic> stateData) {
    debugPrint(
        "_BackupPageState@_handleLoadStateEvent ${stateData.toString()}");
    setState(() {
      if (stateData['backupAnimation'] ?? false) {
        _backupController.repeat(reverse: true);
      }
      if (stateData['surveyAnimation'] ?? false) {
        _surveyController.repeat(reverse: true);
      }
      if (stateData['booksAnimation'] ?? false) {
        _booksController.repeat(reverse: true);
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _saveState() async {
    debugPrint(
        '@_saveStateBefore backup ${_backupController.isAnimating} survey ${_surveyController.isAnimating}  book ${_booksController.isAnimating}\n');
    if (_isDisposed) return;
    debugPrint('@_saveStateAfter _isDisposed $_isDisposed ');
    BlocProvider.of<DatabaseBloc>(context).add(
      SaveStateEvent(
        isUploadingData: false,
        backupAnimation: _backupController.isAnimating,
        surveyAnimation: _surveyController.isAnimating,
        booksAnimation: _booksController.isAnimating,
      ),
    );
  }

  _uploadData() async {
    if (!mounted) return;
    final _dbBloc = context.read<DatabaseBloc>();
    final isUploadingData = _dbBloc.state.isUploadingData;
    final uploadProgress = _dbBloc.state.uploadProgress;
    debugPrint(
        '@_uploadData isUploadingData $isUploadingData uploadProgress $uploadProgress');
    // Replace the previous _dbBloc.add(...) with the following code
    await GetIt.I<WorkManagerService>().registerUploadDataTask(
      isUploadingData: isUploadingData ?? false,
      uploadProgress: uploadProgress ?? 0.0,
      simulateUpload: false,
    );
  }

  // _uploadData_originals() async {
  //   if (!mounted) return;
  //   // if (_isDisposed) return;
  //   // Get the current state values
  //   final _dbBloc = context.read<DatabaseBloc>();
  //   final isUploadingData = _dbBloc.state.isUploadingData;
  //   final uploadProgress = _dbBloc.state.uploadProgress;
  //
  //   debugPrint(
  //       '@_uploadData isUploadingData $isUploadingData uploadProgress $uploadProgress');
  //   _dbBloc.add(
  //     UploadDataEvent(
  //       isUploadingData: isUploadingData ?? false,
  //       uploadProgress: uploadProgress ?? 0.0,
  //       simulateUpload: true,
  //       onUploadStateChanged: (isUploading, progress) {
  //         debugPrint(
  //             '@REALTIME JIMMY isUploadingData $isUploading uploadProgress $progress');
  //         if (!mounted) return;
  //         if (_isDisposed) return;
  //         debugPrint(
  //             '@RYME isUploadingData $isUploading uploadProgress $progress');
  //         BlocProvider.of<DatabaseBloc>(context).add(
  //           SaveStateEvent(
  //             // isUploadingData: false,
  //             uploadProgress: progress,
  //             isUploadingData: isUploading,
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
}
