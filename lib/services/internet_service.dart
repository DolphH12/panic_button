import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:panic_app/main.dart';
import 'package:panic_app/utils/utils.dart';

checkInternet() async {
  InternetConnectionChecker().onStatusChange.listen((status) {
    switch (status) {
      case InternetConnectionStatus.connected:
        print('Data connection is available.');
        navigatorKey.currentState!.pushReplacementNamed('splash');
        break;
      case InternetConnectionStatus.disconnected:
        print('You are disconnected from the internet.');
        navigatorKey.currentState!.pushReplacementNamed('internet');
        break;
    }
  });
}
