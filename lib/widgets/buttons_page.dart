import 'package:flutter/material.dart';
import 'package:panic_app/bloc/bloc_emergency_list.dart';
import 'package:panic_app/models/events_model.dart';
import 'package:panic_app/services/event_services.dart';
import 'package:panic_app/utils/preferencias_app.dart';
import 'package:panic_app/utils/utils.dart';
import 'select_button_emergency.dart';

class SelectEmergencyWidget extends StatelessWidget {
  const SelectEmergencyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<ListEventModel> events = [];
    EventService eventService = EventService();
    PreferenciasUsuario prefs = PreferenciasUsuario();
    EmergencyListBloc emergencyListBloc = EmergencyListBloc();

    return emergencyListBloc.listEvents.isEmpty
        ? StreamBuilder(
            stream: emergencyListBloc.controllerList.stream,
            builder: (BuildContext context,
                AsyncSnapshot<List<ListEventModel>> snapshot) {
              if (snapshot.hasData) {
                return GeneratorEmergency(events: snapshot.data!);
              } else {
                return Center(
                  child: CircularProgressIndicator(
                      backgroundColor: prefs.colorButton),
                );
              }
            },
          )
        : GeneratorEmergency(events: emergencyListBloc.listEvents);
  }
}

class GeneratorEmergency extends StatelessWidget {
  const GeneratorEmergency({
    super.key,
    required this.events,
  });

  final List<ListEventModel> events;

  @override
  Widget build(BuildContext context) {
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
  }
}
