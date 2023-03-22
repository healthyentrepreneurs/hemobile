import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/home/datawidgets/datawidget.dart';

import '../../objects/blocs/henetwork/bloc/henetwork_bloc.dart';
import 'package:flutter/services.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'dart:async';
// import 'dart:developer' as developer;
import 'dart:io';
// import 'package:flutter/foundation.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: HomePage());
  // static Route<void> route() {
  //   return MaterialPageRoute<void>(builder: (_) => const HomePage());
  // }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _connectionStatus = 'Unknown';
  final NetworkInfo _networkInfo = NetworkInfo();

  @override
  void initState() {
    super.initState();
    _initNetworkInfo();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Lilwyne $_connectionStatus");
    return BlocBuilder<HenetworkBloc, HenetworkState>(
        buildWhen: (previous, current) {
      debugPrint(
          'Nabada previous ${previous.gstatus} current ${current.gstatus} ');
      return previous.gconnectivityResult != current.gconnectivityResult;
    }, builder: (context, state) {
      if (state.gconnectivityResult == ConnectivityResult.none) {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          final networkBloc = BlocProvider.of<HenetworkBloc>(context);
          networkBloc.add(const HeNetworkNetworkStatus());
          debugPrint(
              "HomePage@InitState  ${state.gconnectivityResult} and ${state.gstatus}");
        });
      }
      debugPrint(
          "HomePage@ConnectionState  ${state.gconnectivityResult} and GStatus ${state.gstatus} VS ${state.status}");
      return const MainScaffold();
    });
  }

  Future<void> _initNetworkInfo() async {
    String? wifiName,
        wifiBSSID,
        wifiIPv4,
        wifiIPv6,
        wifiGatewayIP,
        wifiBroadcast,
        wifiSubmask;

    try {
      if (!kIsWeb && Platform.isAndroid) {
        wifiName = await _networkInfo.getWifiName();
      }
    } on PlatformException catch (e) {
      debugPrint('Failed to get Wifi Name ${e.message}');
      wifiName = 'Failed to get Wifi Name';
    }

    try {
      if (!kIsWeb && Platform.isAndroid) {
        wifiBSSID = await _networkInfo.getWifiBSSID();
      }
    } on PlatformException catch (e) {
      debugPrint('Failed to get Wifi BSSID ${e.message}');
      wifiBSSID = 'Failed to get Wifi BSSID';
    }
    try {
      wifiIPv4 = await _networkInfo.getWifiIP();
    } on PlatformException catch (e) {
      debugPrint('Failed to get Wifi IPv4 ${e.message}');
      wifiIPv4 = 'Failed to get Wifi IPv4';
    }
    try {
      if (!Platform.isWindows) {
        wifiIPv6 = await _networkInfo.getWifiIPv6();
      }
    } on PlatformException catch (e) {
      debugPrint('Failed to get Wifi IPv6 ${e.message}');
      wifiIPv6 = 'Failed to get Wifi IPv6';
    }

    try {
      if (!Platform.isWindows) {
        wifiSubmask = await _networkInfo.getWifiSubmask();
      }
    } on PlatformException catch (e) {
      debugPrint('Failed to get Wifi submask address ${e.message}');
      wifiSubmask = 'Failed to get Wifi submask address';
    }

    try {
      if (!Platform.isWindows) {
        wifiBroadcast = await _networkInfo.getWifiBroadcast();
      }
    } on PlatformException catch (e) {
      debugPrint('Failed to get Wifi broadcast ${e.message}');
      wifiBroadcast = 'Failed to get Wifi broadcast';
    }

    try {
      if (!Platform.isWindows) {
        wifiGatewayIP = await _networkInfo.getWifiGatewayIP();
      }
    } on PlatformException catch (e) {
      debugPrint('Failed to get Wifi gateway address ${e.message}');
      wifiGatewayIP = 'Failed to get Wifi gateway address';
    }

    setState(() {
      _connectionStatus = 'Wifi Name: $wifiName\n'
          'Wifi BSSID: $wifiBSSID\n'
          'Wifi IPv4: $wifiIPv4\n'
          'Wifi IPv6: $wifiIPv6\n'
          'Wifi Broadcast: $wifiBroadcast\n'
          'Wifi Gateway: $wifiGatewayIP\n'
          'Wifi Submask: $wifiSubmask\n';
    });
  }
}
