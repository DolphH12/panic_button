import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:panic_app/models/events_model.dart';
import 'package:panic_app/services/event_services.dart';
import 'package:panic_app/utils/preferencias_app.dart';
import 'package:panic_app/utils/utils.dart';
import 'select_button_emergency.dart';
import 'package:panic_app/widgets/camera_image_widget.dart';


class SelectEmergencyWidget extends StatelessWidget {
  const SelectEmergencyWidget({super.key});

  @override
  Widget build(BuildContext context) {

    List<ListEventModel> events = [];
    EventService eventService = EventService();
    PreferenciasUsuario prefs = PreferenciasUsuario();

    return FutureBuilder(
      future: eventService.getListEvents(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          for (var mapa in snapshot.data!) {
            events.add(ListEventModel.fromJson(mapa));
          }
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 50),
              itemCount: events.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 1, mainAxisSpacing: 10),
              itemBuilder: (context, index) => SelectButtonWidget(
                tipo: events[index].name,
                color: colors[index],
                icon: events[index].image,
                type: index + 2,
              ),
            ),
          );
        } else {
          return Center(
            child:
                CircularProgressIndicator(backgroundColor: prefs.colorButton),
          );
        }
      },
    );
  }
}
