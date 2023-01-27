import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InternetFailedPage extends StatelessWidget {
  const InternetFailedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: ContainInternetFailed(),
      ),
    );
  }
}

class ContainInternetFailed extends StatelessWidget {
  const ContainInternetFailed({super.key});

  Future<bool> exitApp() async {
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: exitApp,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                "Botón de pánico",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "No tienes internet",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Image(
            image: AssetImage('assets/no-wifi.png'),
            width: 200,
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Asegurate estar conectado a una red que te permita disfrutar de la aplicación.",
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
