import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_maps/maps.dart';

import '../../models/map_event_model.dart';
import '../../services/event_services.dart';

class EventDetailPage extends StatefulWidget {
  final MapEvent eventData;
  
  const EventDetailPage({
    Key? key,
    required this.eventData,
  }) : super(key: key);
  
  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
  
}

class _EventDetailPageState extends State<EventDetailPage> {
  
  late PageController _pageViewController;
  late MapTileLayerController _mapController;

  late MapZoomPanBehavior _zoomPanBehavior;

  late List<MapEvent> _mapEvents;

  final eventService = EventService();

  
   
  @override
  void initState() {
    super.initState();
    _mapController = MapTileLayerController();
    _mapEvents = <MapEvent>[];

    _mapEvents.add(MapEvent(
        id: widget.eventData.id,
        date: widget.eventData.date,
        status: widget.eventData.status,
        time: widget.eventData.time,
        zoneCode: widget.eventData.zoneCode,
        latitude: widget.eventData.latitude,
        longitude: widget.eventData.longitude,
        description: widget.eventData.description,
        comment: widget.eventData.comment, 
        direction: widget.eventData.direction, 
        kind: widget.eventData.kind, 
        phone: widget.eventData.phone, 
        icon: widget.eventData.icon,
        type: widget.eventData.type      
        ));

    _zoomPanBehavior = MapZoomPanBehavior(
        enablePanning: false,
        zoomLevel: 17,
        minZoomLevel: 10,
        maxZoomLevel: 20,
        focalLatLng:
            MapLatLng(widget.eventData.latitude, widget.eventData.longitude),
        enableDoubleTapZooming: true,
        toolbarSettings: const MapToolbarSettings(
            direction: Axis.horizontal,
            position: MapToolbarPosition.bottomRight));

    _pageViewController = PageController(initialPage: 0, viewportFraction: 0.8);
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _mapController.dispose();
    _mapEvents.clear();
    super.dispose();
  }

  Widget backButton(context) {
    return CupertinoButton(
        padding: const EdgeInsets.all(0),
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(CupertinoIcons.back));
  }

  Widget propDetail({required String title, String? content}) {
    print("IDDD ${widget.eventData.id}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: TextAlign.start,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        content != null
            ? Text(
                content,
                textAlign: TextAlign.start,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: CupertinoColors.secondaryLabel),
              )
            : const SizedBox()
      ],
    );
  }

  Widget multimediaPlayer(
      {required IconData icon,
      required String title,
      required String duration}) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      child: Container(
        color: CupertinoColors.lightBackgroundGray,
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(icon, size: 32),
            ),
            Flexible(
                fit: FlexFit.tight,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        duration,
                        style: const TextStyle(
                            color: CupertinoColors.secondaryLabel,
                            fontSize: 14),
                      )
                    ])),
            CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(
                  CupertinoIcons.play_fill,
                  color: CupertinoColors.activeBlue,
                ),
                onPressed: () {
                })
          ],
        ),
      ),
    );
  }

  Widget eventDetail({required double gap}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          propDetail(title: 'Tipo de evento:', content: '${widget.eventData.type}'),
          SizedBox(height: gap),
          propDetail(
              title: 'Fecha:',
              content: '${widget.eventData.date} ${widget.eventData.time}'),
          SizedBox(height: gap),
          propDetail(
              title: 'Descripción:',
              content: widget.eventData.description != ''
                  ? widget.eventData.description
                  : 'Sin descripción'),
          SizedBox(height: gap),
          propDetail(title: 'Comentario:', content: widget.eventData.comment),
          SizedBox(height: gap),
          propDetail(title: 'Ubicación:'),
          Container(
            margin: const EdgeInsets.only(top: 16),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            height: 200,
            child: SfMaps(
              layers: <MapLayer>[
                MapTileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  zoomPanBehavior: _zoomPanBehavior,
                  controller: _mapController,
                  initialMarkersCount: _mapEvents.length,
                  tooltipSettings: const MapTooltipSettings(
                    color: Colors.transparent,
                  ),
                  markerBuilder: (BuildContext context, int index) {
                    const double markerSize = 25;
                    return MapMarker(
                      latitude: _mapEvents[index].latitude,
                      longitude: _mapEvents[index].longitude,
                      alignment: Alignment.bottomCenter,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: markerSize,
                        width: markerSize,
                        child: const FittedBox(
                          child: Icon(CupertinoIcons.location_solid,
                              color: Colors.red, size: markerSize),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: gap),
        ],
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
  
  @override
  Widget build(BuildContext context) {
    
    final args =  (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;

    return Scaffold(
        body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                backButton(context),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Reporte",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      eventDetail(gap: 16),
                      const SizedBox(height: 32),
                    ],
                  ),
                )
              ],
            )));
  }
}
