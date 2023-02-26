import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_maps/maps.dart';

import '../../models/map_event_model.dart';
import '../../services/event_services.dart';

class EventDetailPage extends StatefulWidget {
  final MapEvent eventData;
  final int lengthList;
  
  const EventDetailPage({
    Key? key,
    required this.eventData,
    required this.lengthList,
  }) : super(key: key);
  
  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
  
}

class _EventDetailPageState extends State<EventDetailPage> {

  bool _isReady = false;
  
  late PageController _pageViewController;
  late MapTileLayerController _mapController;

  late MapZoomPanBehavior _zoomPanBehavior;

  late List<MapEvent> _listedMapEvents;

  late List<MapEvent> _mapEvents;

  late List<MapEvent> _mapEvent;

  late int _lengList;

  final eventService = EventService();

  
   
  @override
  void initState() {
    super.initState();
    fetchEvents();
    

    _mapController = MapTileLayerController();
    _listedMapEvents = <MapEvent>[];
    _mapEvents = <MapEvent>[];
    _mapEvent = <MapEvent>[];
    _lengList = widget.lengthList;
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
        type: widget.eventData.type,
        more: widget.eventData.more,
        list: widget.eventData.list     
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


  Future fetchEvents() async {
    final events = await eventService.getEvents();
    for (final event in events['data']) {
      _mapEvent.add(MapEvent(
          id: event['id'],
          date: event['date'],
          status: event['status'],
          time: event['time'],
          zoneCode: event['zone'],
          latitude: event['location'][0],
          longitude: event['location'][1],
          description: "",
          comment: event['comment'], 
          direction: '', 
          kind: 0, 
          phone: '', 
          icon: '',
          type: event['typeEmergency'],
          more: [],
          list: []
          ));
    } 
    
    _listedMapEvents.addAll(_mapEvents);

    if (widget.eventData.list.isNotEmpty){
    for (String id in widget.eventData.list) {
      for (MapEvent event in _mapEvent){
        if (id == event.id){
          _listedMapEvents.add(event);
        } 
      }
    } }
    _isReady = true;
    setState(() {});
  }



  @override
  void dispose() {
    _pageViewController.dispose();
    _mapController.dispose();
    _mapEvents.clear();
    _listedMapEvents.clear();
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

  Widget eventDetail({required double gap, required int index}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          propDetail(title: 'Tipo de evento:', content: '${_listedMapEvents[index].type}'),
          SizedBox(height: gap),
          propDetail(
              title: 'Fecha:',
              content: '${_listedMapEvents[index].date} ${_listedMapEvents[index].time}'),
          SizedBox(height: gap),
          propDetail(
              title: 'Descripción:',
              content: _listedMapEvents[index].description != ''
                  ? _listedMapEvents[index].description
                  : 'Sin descripción'),
          SizedBox(height: gap),
          propDetail(title: 'Comentario:', content: _listedMapEvents[index].comment),
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
                  initialMarkersCount: 1,
                  tooltipSettings: const MapTooltipSettings(
                    color: Colors.transparent,
                  ),
                  markerBuilder: (BuildContext context, int index) {
                    const double markerSize = 25;
                    return MapMarker(
                      latitude: _listedMapEvents[index].latitude,
                      longitude:_listedMapEvents[index].longitude,
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




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          foregroundColor: Theme.of(context).primaryColorDark,
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          leadingWidth: 200,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: const [
                  Icon(Icons.arrow_back_ios_new),
                  Text("Regresar")
                ],),),),),
      body: ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _lengList,      
      itemBuilder: (BuildContext context, int index) {
        return _isReady ? 
          Container(
            margin: const EdgeInsets.only(top: 20),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(width: 2)
              ),),
            child: eventDetail(gap: 30 ,index: index)): 
            const Center(child: CircularProgressIndicator());
     }));}}



    
    
    //final args =  (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;

