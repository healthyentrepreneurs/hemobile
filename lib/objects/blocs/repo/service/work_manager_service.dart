import 'package:workmanager/workmanager.dart';

class WorkManagerService {
  static const workManagerTask = "workManagerTask";

  static final WorkManagerService _singleton = WorkManagerService._internal();

  factory WorkManagerService() {
    return _singleton;
  }

  WorkManagerService._internal();

  Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher);
    print("Workmanager initialized");
  }

  Future<void> startPeriodicTask() async {
    await Workmanager().registerPeriodicTask(
      "1",
      workManagerTask,
      frequency: Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
    print("Periodic task registered");
  }

  Future<void> cancelAllTasks() async {
    await Workmanager().cancelAll();
    print("Cancelled all tasks");
  }
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case WorkManagerService.workManagerTask:
        print("Executing work manager task");
        // Put your task logic here
        break;
      default:
        print("Unknown task executed");
    }
    return Future.value(true);
  });
}
