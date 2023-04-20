import 'dart:math';

import 'package:flutter/material.dart';
import 'package:he/home/home.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

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
  bool _isUploadingData = false;
  bool _isDisposed = false;
  double _uploadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    // _saveStateXx();
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
    _loadState();
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
    _saveState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                              builder: (context, child) => Transform.scale(
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
              SingleSection(
                title: "",
                children: [
                  _isUploadingData
                      ? LinearProgressIndicator(
                          value: _uploadProgress,
                          minHeight: 5,
                        )
                      : InkWell(
                          onTap: _uploadData,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                            ),
                            child: const Text(
                              "Upload Data",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ),
                  const SizedBox(height: 5),
                  _uploadProgress > 0
                      ? Text(
                          '${(_uploadProgress * 100).toStringAsFixed(0)}%',
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
                    subtitle: const Text('10 GB to be uploaded'),
                    trailing: AnimatedBuilder(
                      animation: _surveyRotationAnimation,
                      builder: (context, child) => Transform.rotate(
                        angle: _surveyRotationAnimation.value,
                        child: const Icon(Icons.sync),
                      ),
                    ),
                    onTap: () {},
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
  }

  void _uploadData({bool simulateUpload = true}) async {
    if (!mounted) return;
    setState(() {
      _isUploadingData = true;
    });

    if (simulateUpload) {
      // Resume data upload from the last saved progress (use your own upload logic here)
      for (int i = (_uploadProgress * 100).toInt(); i <= 100; i++) {
        await Future.delayed(const Duration(milliseconds: 30));
        debugPrint('JOASH-CRAPY IMPL $i');
        if (!mounted) return;
        setState(() {
          _uploadProgress = i / 100;
        });
      }
      if (!mounted) return;
      setState(() {
        _isUploadingData = false;
        _uploadProgress = 0.0;
      });
    } else {
      // Restore saved state
      if (!mounted) return;
      setState(() {
        _isUploadingData = true;
        _uploadProgress = _uploadProgress;
      });
    }
    _saveState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isUploadingData = prefs.getBool('isUploadingData') ?? false;
      _uploadProgress = prefs.getDouble('uploadProgress') ?? 0.0;

      if (prefs.getBool('backupAnimation') ?? false) {
        _backupController.repeat(reverse: true);
      }
      if (prefs.getBool('surveyAnimation') ?? false) {
        _surveyController.repeat(reverse: true);
      }
      if (prefs.getBool('booksAnimation') ?? false) {
        _booksController.repeat(reverse: true);
      }
    });

    if (_isUploadingData) {
      _uploadData(simulateUpload: false);
    }
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _saveStateXx() async {
    if (_isDisposed) return;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isUploadingData', false);
    prefs.setDouble('uploadProgress', 0.0);
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('uploadProgress', _uploadProgress);
    if (_isDisposed) return;
    prefs.setBool('isUploadingData', _isUploadingData);
    prefs.setBool('backupAnimation', _backupController.isAnimating);
    prefs.setBool('surveyAnimation', _surveyController.isAnimating);
    prefs.setBool('booksAnimation', _booksController.isAnimating);
  }
}
