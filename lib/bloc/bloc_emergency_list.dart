import 'dart:async';

import '../models/events_model.dart';
import '../services/event_services.dart';

class EmergencyListBloc {
  static final EmergencyListBloc _instancia = EmergencyListBloc._internal();

  factory EmergencyListBloc() {
    return _instancia;
  }

  EmergencyListBloc._internal();

  StreamController<List<ListEventModel>> controllerList =
      StreamController<List<ListEventModel>>.broadcast();

  List<ListEventModel> listEvents = [];

  Future<void> getEmergencyList() async {
    EventService eventService = EventService();
    List result = await eventService.getListEvents();
    for (var mapa in result) {
      listEvents.add(ListEventModel.fromJson(mapa));
    }
    controllerList.add(listEvents);
  }
}
