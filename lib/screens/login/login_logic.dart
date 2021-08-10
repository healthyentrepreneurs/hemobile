import 'notifiers/login_statenotifier.dart';

class LoginManager {
  final loginStateNotifier = LoginStateNotifier();
  String? username;
  String? password;
  String? loginState;

  Future<int> initLoginState() async {
    return await loginStateNotifier.initialize();
  }

  signIn() {
    if (username == null && password == null) {
      loginStateNotifier.updateLoadingState(false);
      loginState = "Username/Password required";
    } else if (username == null || username == "") {
      loginState = "Username required";
      loginStateNotifier.updateLoadingState(false);
    } else if (password == null || password == "") {
      loginStateNotifier.updateLoadingState(false);
      loginState = "Password required";
    } else {
      loginStateNotifier.updateLoadingState(true);
      loginStateNotifier.loginCall(username!, password!);
      loginState = LoginStateNotifier.loginState;
      // loginStateNotifier.updateLoginState();
    }
  }

  signOut() {}

  int isSignedIn() {
    loginStateNotifier
        .initialize()
        .then((value) => {loginStateNotifier.updateLoginStatus(value)});
    return LoginStateNotifier.initialValue;
  }

  bool loading() {
    return LoginStateNotifier.isLoading;
    // print("What is my state $stateN");
    // return stateN;
  }

  void dispose() {
    loginStateNotifier.dispose();
  }
}

// enum LoginStatus { loading, notSignIn, signIn }
