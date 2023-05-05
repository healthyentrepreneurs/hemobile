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
  bool _taskRegistered = false;

  @override
  void initState() {
    super.initState();
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
    bool? isUploadingData = context.watch<DatabaseBloc>().state.isUploadingData;
    double? uploadProgress = context.watch<DatabaseBloc>().state.uploadProgress;
    return BlocListener<DatabaseBloc, DatabaseState>(
      listener: (context, state) {
        _updateAnimationStatus(state);
      },
      child: Scaffold(
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
                _buildProgressWidget(isUploadingData, uploadProgress),
                SingleSection(
                  title: "Data Statistics",
                  children: [
                    _buildSurveyIconWidget(),
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
                          onPressed: () => _uploadData(),
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
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  _uploadData() async {
    if (!mounted || _taskRegistered) return;
    debugPrint('@_uploadData isUploadingData');
    final workManagerService = GetIt.I<WorkManagerService>();
    await workManagerService.cancelUploadDataTask();
    await workManagerService.registerUploadDataTask();
    _taskRegistered = true;
  }

  void _updateAnimationStatus(DatabaseState state) {
    bool backupAnimation = state.backupAnimation ?? false;
    bool surveyAnimation = state.surveyAnimation ?? false;
    bool booksAnimation = state.booksAnimation ?? false;

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

  Widget _buildProgressWidget(bool? isUploadingData, double? uploadProgress) {
    double _uploadProgress = uploadProgress ?? 0.0;
    return SingleSection(
      title: "",
      children: [
        isUploadingData ?? false
            ? LinearProgressIndicator(
                value: uploadProgress ?? 0.0,
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
        _uploadProgress > 0
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
    return BlocBuilder<DatabaseBloc, DatabaseState>(
        buildWhen: (previous, current) {
      return previous.backupAnimation != current.backupAnimation;
    }, builder: (context, state) {
      return RepaintBoundary(
        child: TickerMode(
          enabled: state.backupAnimation ?? false,
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
      );
    });
  }

  Widget _buildSurveyIconWidget() {
    return ListTile(
      title: const Text("Surveys"),
      leading: const Icon(
        Icons.library_books,
      ),
      subtitle: const Text('20 to be uploaded'), //${state.surveyTotalCount}
      trailing: BlocBuilder<DatabaseBloc, DatabaseState>(
          buildWhen: (previous, current) {
        debugPrint(
            "Build Upload Anima previous ${previous.surveyAnimation} and current ${current.surveyAnimation}");
        return previous.surveyAnimation != current.surveyAnimation;
      }, builder: (context, state) {
        return RepaintBoundary(
          child: AnimatedBuilder(
            animation: _surveyRotationAnimation,
            builder: (context, child) => Transform.rotate(
              angle: _surveyRotationAnimation.value,
              child: const Icon(Icons.sync),
            ),
          ),
        );
// return widget here based on BlocA's state
      }),
    );
  }
}
