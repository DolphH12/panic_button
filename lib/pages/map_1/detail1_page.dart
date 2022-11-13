import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../services/event_services.dart';
import '../../widgets/audio_widget.dart';

class Detail1Page extends StatelessWidget {
  const Detail1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).primaryColorDark,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: const Detail1Widget(),
    );
  }
}

class Detail1Widget extends StatelessWidget {
  const Detail1Widget({super.key});

  @override
  Widget build(BuildContext context) {

    final args =  (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    final alerta = args['alerta'];
    final eventService = EventService();

    String userId =  alerta['id'];

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [

              Text(
                "Información del evento",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

             const SizedBox(height: 10,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Image.asset(
                      "assets/advertencia.png",
                      height : 30,
                      width  : 30,
                    ),
                  ),
                ],
              ),
            
              Column(
                children: [
                  Divider(color: Theme.of(context).primaryColorDark),

                  Text(
                    alerta['comment'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16
                    ),
                  ),
                ],
              ),

             const SizedBox(height: 10,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 
                  const Text("Día: ", ),
                  Text(
                    "${alerta['date']}",
                    style: const TextStyle(
                      fontStyle: FontStyle.italic
                    ),
                  ),
                  const SizedBox(width: 30),
                  const Text("Hora: ", ),
                  Text(
                    "${alerta['time']}",
                    style: const TextStyle(
                      fontStyle: FontStyle.italic
                    ),
                  ),
                ],
              ),
              
              Divider(color: Theme.of(context).primaryColorDark),
              
              const SizedBox(height: 10,),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Zona : "),
                  Text(
                    "${alerta['zone']}",
                    style: const TextStyle(
                      fontStyle: FontStyle.italic
                    ),
                  ),
                ],
              ),

              Text(
                alerta['status'] == 1 ? 'Activo ' : alerta['status'] == 2 ? 'Inactivo' : 'Descartado',
                style: TextStyle(
                  color: alerta['status'] == 1 ? Colors.green : alerta['status'] == 2 ? Colors.yellow : Colors.red,
                  fontWeight: FontWeight.bold
                ),
              ),
              
              Divider(color: Theme.of(context).primaryColorDark),
              
              const SizedBox(height: 10,),

              FutureBuilder(
                future: eventService.eventMedia(userId),
                builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data!;
                    final fotos = data['photos'];
                    final audios = data['audios'];
                    if(!fotos.isEmpty && !audios.isEmpty){
                      return SafeArea(
                        child: Column(
                          children: [
                            _showPhotos(fotos, context),

                              const SizedBox(height: 12,),

                              Card(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10,),

                                    const Text(
                                      "Audio de lo ocurrido",
                                      style: TextStyle(
                                        fontSize: 17
                                      ),

                                    ),
                                    const SizedBox(height: 8),

                                    AudioWidget(audios: audios),

                                    const SizedBox(height: 10,),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      );
                    }else if (!fotos.isEmpty && audios.isEmpty){
                      return Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: _showPhotos(fotos, context)
                          ),

                          const SizedBox(height: 30,),
                        ]
                      );
                    } else if (fotos.isEmpty && !audios.isEmpty){
                      return Column(
                        children: [
                          const SizedBox(height: 12,),
                              Card(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10,),
                                    const Text(
                                      "Audio de lo ocurrido",
                                      style: TextStyle(
                                        fontSize: 17
                                      ),

                                    ),
                                    const SizedBox(height: 8,),
                                    AudioWidget(audios: audios),
                                    const SizedBox(height: 10,),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 30,),
                        ],
                      );
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "No hay archivos multimedia disponibles",
                            style: TextStyle(
                              color: Colors.black38,
                            ),
                          )
                        ],
                      );
                    }
                  } else {
                    return Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: Theme.of(context).primaryColorDark,
                          ),

                          const SizedBox(height: 15),

                          const Text("Cargando evidencias...")
                        ],
                      ),
                    );
                  }
                }
              )
            ]
          ),
        ),
      ),
    );
  }

  Widget _showPhotos(List<dynamic> fotos, BuildContext context) {
    for (var foto in fotos) {
      //convert Base64 string to Uint8List
      Uint8List image = const Base64Decoder().convert(foto);

      return SizedBox(
        width: 300,
        height: 400,
        child: FittedBox(
          fit: BoxFit.fill,
          child: Image.memory(
            image,
          ),
        ),
      );
    }
    return const Text("No hay fotos disponibles");
  }
  

}