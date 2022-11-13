import 'package:flutter/material.dart';

class SelectMapPage extends StatelessWidget {
  const SelectMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColorDark,
        leadingWidth: 200,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: const [
                Icon(Icons.arrow_back_ios_new),
                Text("Regresar")
              ],
            ),
          ),
        ),
      ) ,
      body: const OptionsMap(),
    );
  }
}

class OptionsMap extends StatelessWidget {
  const OptionsMap({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 15,bottom: 15),
            child: Text(
                "Seleccione un visualizador",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
          ),
          ListView(
            shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  title: const Text(
                    "Visualizador 1",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  subtitle: const Text(
                    "Opción 1 de visualizador (flutter map)",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  leading: const Icon(Icons.map),
                  onTap: () => Navigator.pushNamed(context, 'map2'),
                ),
               

                const Divider(height: 10,),

                ListTile(
                  title: const Text(
                    "Visualizador 2",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  subtitle: const Text(
                    "Opción 2 de visualizador (google map)",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  leading: const Icon(Icons.map),
                  onTap: () => Navigator.pushNamed(context, 'map1'),
                ),
              ]
          )
        ],
      ),
    );
  }
}