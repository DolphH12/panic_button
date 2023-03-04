import 'dart:convert';
import 'dart:math';


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:geolocator/geolocator.dart';

import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/map_event_model.dart';
import '../../models/map_zone_model.dart';
import '../../services/event_services.dart';
import '../../widgets/cupertino_list_tile_widget.dart';
import 'package:flutter/cupertino.dart';
import 'event_detail_page.dart';


class VisualizerPage extends StatefulWidget {
  const VisualizerPage({super.key});

  @override
  State<VisualizerPage> createState() => _MainScreenState();
}

class _MainScreenState extends State<VisualizerPage> {
  final eventService = EventService();

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
                ],
              ),
            ),
          ),
        ),
      body: ProgressHUD(
        backgroundRadius: const Radius.circular(100),
        barrierColor: Colors.black26,
        borderColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
          child: SafeArea(
            child: Column(
              children: [mapEvents()],
            ),
          ),
        ),
      ),
    );
  }

  bool showZones = false;
  bool showEvents = true;
  bool showCards = true;
  bool activateDateFilterButton = false;
  bool showChangeMap = true;
  bool showEmergency = true;
  bool typeOfMap = true;
  bool _isloading = false;
  DateTimeRange filterDateRange = DateTimeRange(
    start: DateTime(2022, 1, 1),
    end: DateTime(2023, 12, 31),
  );

  late PageController _pageViewController;
  late MapTileLayerController _mapController;

  late MapZoomPanBehavior _zoomPanBehavior;

  late List<MapEvent> _mapEvents;
  late List<MapEvent> _filteredEvents;
  late List<MapZone> _mapZones;
  late List<MapEvent> _mapEmergencys;

  late int _currentSelectedIndex;
  late int _previousSelectedIndex;
  late int _tappedMarkerIndex;
  late MapLatLng _currentPosition;

  late double _cardHeight;

  late bool _canUpdateFocalLatLng;

  Color getZoneColor(MapZone zone) {
    int cantEvents = zone.events.length;
    return zone.color.withAlpha(((cantEvents * ((255 - 50) / 3)) + 50).toInt());
  }

  double getZoneRadius(MapZone zone) {
    int cantEvents = zone.events.length;
    return ((cantEvents * ((50 - 10) / 10)) + 10);
  }

  String getFormattedDate(DateTime date) {
    String month = '';

    switch (date.month) {
      case 1:
        month = 'Ene';
        break;
      case 2:
        month = 'Feb';
        break;
      case 3:
        month = 'Mar';
        break;
      case 4:
        month = 'Abr';
        break;
      case 5:
        month = 'May';
        break;
      case 6:
        month = 'Jun';
        break;
      case 7:
        month = 'Jul';
        break;
      case 8:
        month = 'Ago';
        break;
      case 9:
        month = 'Sep';
        break;
      case 10:
        month = 'Oct';
        break;
      case 11:
        month = 'Nov';
        break;
      case 12:
        month = 'Dic';
        break;
    }

    return '${date.day} $month ${date.year} ';
  }

  Widget getIconMarker(String image64,int index, double markerSize){
    Uint8List image = base64Decode(image64);


    if (image64 != ''){
      return SizedBox(
        width: markerSize + 30,
        height: markerSize + 30,
        child: FittedBox(
          fit: BoxFit.fill,
          child: Image.memory(
            image,
          ),
        ),
      );}
      else {
        return Icon(
          Icons.location_on,
          color: _currentSelectedIndex == index
          ? Colors.blue : Colors.red,
          size: markerSize);
      }
  }

  Widget propDetail({required String title, String? content}) {
    
    return Row(
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
                    color: Color.fromARGB(248, 16, 16, 18)),
              )
            : const SizedBox()
      ],
    );
  }

  Future fetchEvents() async {
    final events = await eventService.getEvents();
    for (final event in events['data']) {
      _mapEvents.add(MapEvent(
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
  }

  

  Future fetchZones() async {
    final zones = await eventService.getZones();

    for (final zone in zones['data']) {
      _mapZones.add(MapZone(
        code: zone['zoneCode'],
        center: MapLatLng(zone['location'][0], zone['location'][1]),
        color: Colors.red.shade300,
        events: zone['idEvents'],
        posts: zone['idPosts'],
        radius: 10,
      ));
    }
  }

  Future fetchEmergency() async{
    final emergencys = await eventService.getEmergency();
    double desplazar = 0;
    for (final emergency in emergencys['data']) {
      
      _mapEmergencys.add(MapEvent(
      id: emergency['name'], 
      latitude: 6.27296 - desplazar,//emergency['location'][0], 
      longitude: -75.59059 + desplazar,//emergency['location'], 
      description: 'Policia',//emergency['description'], 
      phone: emergency['phone'], 
      direction: 'direction', //emergency['direction']
      comment: '', 
      date: '', 
      kind: 1, 
      status: 0, 
      time: '', 
      zoneCode: 100, 
      icon: emergency['image'],
      type: 1,
      more: [],
      list: []
      )); 
      desplazar = desplazar + 0.01;    
    }
    desplazar = 0;
  }


  

  Future<Position> determinePosition() async {
  Position position;
  bool serviceEnabled;
  LocationPermission permission;
  MapLatLng location;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  position = await Geolocator.getCurrentPosition();
  location = MapLatLng(position.latitude, position.longitude);
  setState(() {
      _currentPosition = location;
    });
  _isloading = true;
  return await Geolocator.getCurrentPosition();
  
}

  String tarjetDescription(MapEvent item){

    if (item.comment.isEmpty && item.list.isEmpty){
      return "Sin descripción";
    } else if (item.list.isNotEmpty) {
      return "Compilación de eventos";
    } else {
      return item.comment;
    }
  }

  void loadFilteredEvents() {
    _mapController.clearMarkers();
    _filteredEvents.clear();
    if (showEvents) {
      int markersCount = 0;
      bool initMarker = true;
      double distanceMarkers = 0.001;
      bool agregar = false;
      

      for (MapEvent mapEvent in _mapEvents) {

        final eventDate = DateTime.parse('${mapEvent.date} ${mapEvent.time}');
            eventDate.isBefore(filterDateRange.end);
        if ( initMarker &&eventDate.isAfter(filterDateRange.start) &&
            eventDate.isBefore(filterDateRange.end)){
            _filteredEvents.add(mapEvent);
            _mapController.insertMarker(markersCount);
            initMarker = false;

        } else{
          if (initMarker){
            continue;
          }

        for (MapEvent filtEvent in _filteredEvents) {
          double a = mapEvent.latitude - filtEvent.latitude;
          double b = mapEvent.longitude - filtEvent.longitude;
          double distancia = sqrt(pow(a,2) + pow(b,2));



          if (distancia < distanceMarkers /*&& mapEvent.type == filtEvent.type*/){
            filtEvent.list.add(mapEvent.id); 
                    
            agregar = false;
            break;
          } else{
            if(eventDate.isAfter(filterDateRange.start) &&
            eventDate.isBefore(filterDateRange.end)){
            agregar = true;
            }
          }          
        }
        if (agregar){
            markersCount++;
            _filteredEvents.add(mapEvent);
            _mapController.insertMarker(_filteredEvents.length-1);            
          }
        } 

      }
    } 


    if (showEmergency){
      int totalMarkers = _filteredEvents.length;
      _filteredEvents.addAll(_mapEmergencys);      
      for (MapEvent map in _mapEmergencys){
        _mapController.insertMarker(totalMarkers);
        totalMarkers++;        
      }
    }
    //setState(() {});

    //List<MapCircle>.generate para generar todos los marcadores.
  }

  void _handlePageChange(int index) {
    if (!_canUpdateFocalLatLng) {
      if (_tappedMarkerIndex == index) {
        _updateSelectedCard(index);
      }
    } else if (_canUpdateFocalLatLng) {
      _updateSelectedCard(index);
    }
  }

  void _updateSelectedCard(int index) {
    setState(() {
      _previousSelectedIndex = _currentSelectedIndex;
      _currentSelectedIndex = index;
    });

    if (_canUpdateFocalLatLng) {
      _zoomPanBehavior.focalLatLng = MapLatLng(
          _filteredEvents[_currentSelectedIndex].latitude,
          _filteredEvents[_currentSelectedIndex].longitude);
    }

    _mapController
        .updateMarkers(<int>[_currentSelectedIndex, _previousSelectedIndex]);
    _canUpdateFocalLatLng = true;
  }

  @override
  void initState() {
    super.initState();
    _currentSelectedIndex = 0;                   //El evento seleccionado al iniciar el mapa es el 0
    _canUpdateFocalLatLng = true;
    _mapController = MapTileLayerController();
    _mapEvents = <MapEvent>[];
    _filteredEvents = <MapEvent>[];
    _mapZones = <MapZone>[];
    _mapEmergencys = <MapEvent>[];

    Future.delayed(const Duration(seconds: 0), () async {
      await fetchEvents();
      await fetchZones();
      await fetchEmergency();
      loadFilteredEvents();
      await determinePosition();

    });

    _zoomPanBehavior = MapZoomPanBehavior(
        zoomLevel: 17,
        minZoomLevel: 3,
        maxZoomLevel: 19,
        //focalLatLng: MapLatLng(_initLat,_initLong),
        enableDoubleTapZooming: true,
        toolbarSettings: const MapToolbarSettings(direction: Axis.vertical));

    _cardHeight = 80;

    _pageViewController = PageController(
        initialPage: _currentSelectedIndex, viewportFraction: 0.8);
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _mapController.dispose();
    _mapEvents.clear();
    _filteredEvents.clear();
    super.dispose();
  }

  

  Widget mapFiltersButton() {
    return Stack(
      children: [               
        Container(
          margin: const EdgeInsets.only(top: 8, left: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
          ),
          child: PhysicalModel(
            borderRadius: BorderRadius.circular(100),
            color: Colors.white,
            elevation: 4,
            shadowColor: const Color(0x55000000),
            child: CupertinoButton(
              borderRadius: BorderRadius.circular(100),
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              onPressed: () {
                filtersDialog(context);
              },
              child: const SizedBox(
                child: Text(
                  "Filtros",
                  style: TextStyle(
                    fontSize: 18,
                    color: CupertinoColors.secondaryLabel                    
                  ),
                ),                
              )
            ),
          )
        ),
        actualPosition()
      ],
    );
  }

  void filtersDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
        return CupertinoAlertDialog(
          title: 
          Text('Filtros',
            style: TextStyle( fontSize: 23, color: Theme.of(context).primaryColorDark
              ),
            ),          
            content: Container(
            margin: const EdgeInsets.fromLTRB(0, 30, 0, 8),
            child: Column(
              children: [                
                CupertinoListTileWidget(
                  text: "Eventos",
                  color: Colors.transparent,
                  onPressed: () {
                    setModalState(() {
                      showEvents = !showEvents;
                    });
                    loadFilteredEvents();
                  },
                  child: CupertinoSwitch(
                    value: showEvents,
                    thumbColor: CupertinoColors.white,
                    trackColor: CupertinoColors.extraLightBackgroundGray,
                    onChanged: (bool? value) {
                      setModalState(() {
                        showEvents = value!;
                      });
                      loadFilteredEvents();
                    },
                  ),
                ),
                CupertinoListTileWidget(
                  text: "Emergencias",
                  color: Colors.transparent,
                  onPressed: () {
                    setModalState(() {
                      showEmergency = !showEmergency;
                    });
                    loadFilteredEvents();
                  },
                  child: CupertinoSwitch(
                    value: showEmergency,
                    thumbColor: CupertinoColors.white,
                    trackColor: CupertinoColors.extraLightBackgroundGray,
                    onChanged: (bool? value) {
                      setModalState(() {
                        showEmergency = value!;
                      });
                      loadFilteredEvents();
                    },
                  ),
                ),
                CupertinoListTileWidget(
                  text: "Zonas calientes",
                  color: Colors.transparent,
                  onPressed: () {
                    setModalState(() {
                      showZones = !showZones;
                    });
                  },
                  child: CupertinoSwitch(
                    value: showZones,
                    thumbColor: CupertinoColors.white,
                    trackColor: CupertinoColors.extraLightBackgroundGray,
                    onChanged: (bool? value) {
                      setModalState(() {
                        showZones = value!;
                      });
                      setState(() {
                      });
                    },
                  ),
                ),
                CupertinoListTileWidget(
                  text: "Filtro de fecha",
                  color: Colors.transparent,
                  onPressed: () {
                    setModalState(() {
                      activateDateFilterButton = !activateDateFilterButton;
                    });
                  },
                  child: CupertinoSwitch(
                    value: activateDateFilterButton,
                    thumbColor: CupertinoColors.white,
                    trackColor: CupertinoColors.extraLightBackgroundGray,
                    onChanged: (bool? value) {
                      setModalState(() {
                        activateDateFilterButton = !activateDateFilterButton;
                        filterDateRange = DateTimeRange(
                          start: DateTime(2022, 1, 1),
                          end: DateTime(2023, 12, 31),
                        );
                      });
                    },
                  ),
                ),
                activateDateFilterButton ? dateFilterButton() : const SizedBox()
              ],
            ),
          ),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Atrás',
                style: TextStyle(color: Theme.of(context).primaryColorDark),
              ),
            ),
          ],
        );
      }),
    );
  }

    Widget dateFilterButton() {
    final filterStartDate = filterDateRange.start;
    final filterEndDate = filterDateRange.end;

    return Container(           
      width: MediaQuery.of(context).size.width / 1.75,
      margin: const EdgeInsets.only(top: 15, left: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
      ),
      child: PhysicalModel(
        borderRadius: BorderRadius.circular(100),
        color: Colors.white,
        elevation: 4,
        shadowColor: const Color(0x55000000),
        child: CupertinoButton(
          borderRadius: BorderRadius.circular(100),
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          onPressed: () {
            pickDateRange();
          },
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.calendar_today,
                  color: CupertinoColors.secondaryLabel,
                  size: 18,
                ),
                Expanded(
                  child: Text(
                    getFormattedDate(filterStartDate),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.secondaryLabel),
                  ),
                ),
                const VerticalDivider(),
                Expanded(
                  child: Text(
                    getFormattedDate(filterEndDate),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.secondaryLabel),
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }

  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: filterDateRange,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (newDateRange == null) return;

    setState(() {
      filterDateRange = newDateRange;
      loadFilteredEvents();
    });
  }

  MapMarker drawMarkers(BuildContext context, int index){
    final double markerSize = _currentSelectedIndex == index ? 40 : 25;
    return MapMarker(
      latitude: _filteredEvents[index].latitude,
      longitude: _filteredEvents[index].longitude,
      alignment: Alignment.bottomCenter,
      child: GestureDetector(     //funcion al presionar un marcador
        onTap: () {
          final progress = ProgressHUD.of(context);
          progress!.show();
          if (_currentSelectedIndex != index) {
            _canUpdateFocalLatLng = false;
            _tappedMarkerIndex = index;
            _pageViewController.animateToPage(   //se cambia la tarjeta de evento por la presionada
              index,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,);}
          if(_filteredEvents[index].kind == 0){                          
          Future.delayed(const Duration(seconds: 1), () { //ingresamos a los detalles de un evento o emergency
            progress.dismiss();                              
              Navigator.push(                                
              context,
              MaterialPageRoute(
                builder: (context) => EventDetailPage(
                    eventData: _filteredEvents[index],
                    lengthList: _filteredEvents[index].list.length+1
                    ),),);});
          }else {
            Future.delayed(const Duration(milliseconds: 100), () {
              progress.dismiss();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog( 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),                                                                       
                  content: emergencyDetails(index),
                  actions: [ 
                    ElevatedButton(onPressed: (){
                    Navigator.pop(context);}, 
                    child: const Text('Cerrar')),                                           
                  ]);});});}},
        child: AnimatedContainer(         //se redibuja el marcador cambiando color y tamaño 
          duration: const Duration(milliseconds: 250),
          height: markerSize,
          width: markerSize,
          child: getIconMarker(_filteredEvents[index].icon,index,markerSize)                          
        ),),);
  }

  MapSublayer drawZones() {
    return MapCircleLayer(
        circles: List<MapCircle>.generate(
          _mapZones.length,
          (int index) {
            return MapCircle(
              center: _mapZones[index].center,
              radius: getZoneRadius(_mapZones[index]),
              color: getZoneColor(_mapZones[index]),
              strokeColor: _mapZones[index].color,
            );
          },
        ).toSet(),
      );
  }


  Widget drawTarjets(BuildContext context) {
    if(showCards && showEvents) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: _cardHeight,    //tamaño de la tarjeta
          padding: const EdgeInsets.only(bottom: 8), //distancia de la parte inferior de la tarjeta
          child: PageView.builder(
            itemCount: _filteredEvents.length,      //numero de tarjetas a crear
            onPageChanged: _handlePageChange,
            controller: _pageViewController,
            itemBuilder: (BuildContext context, int index) {
              final MapEvent item = _filteredEvents[index];   //
              return Transform.scale(
                scale: index == _currentSelectedIndex ? 1 : 0.85,  //tamaño tarjeta dependiendo de seleccionado
                child: Stack(
                  children: <Widget>[
                    tarjetContent(item),                           // Adding splash to card while tapping.
                    splashTarjet(index, context)
                  ],
                ),
              );
            },
          ),
        ),
      );
    } else {
      return widget;
    }
  }

  Widget emergencyDetails(int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,                                      
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          width: double.infinity,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 2.0, color: Colors.black38),
            ),
          ),
          child: Text(_filteredEvents[index].id,
            style: TextStyle(
            color: Theme.of(context).primaryColorDark,
            fontWeight: FontWeight.bold,  
            fontSize: 40,                                     
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        
        getIconMarker(_filteredEvents[index].icon,index,100),
        const SizedBox(height: 20),
        propDetail(title: 'Nombre :  ',content: _filteredEvents[index].id),
        const SizedBox(height: 22),
        propDetail(title: 'Descripción :  ', content: _filteredEvents[index].description),
        const SizedBox(height: 22),
        propDetail(title: 'Ubicación :  ', content: _filteredEvents[index].direction),
        const SizedBox(height: 7),
        Row(
          children: [
            propDetail(title: 'Telefono :  ' , content: _filteredEvents[index].phone),
            const SizedBox(width: 20,),
            FloatingActionButton(
              heroTag: null,
              backgroundColor: Colors.white,
              child: const Icon(Icons.call, color: Colors.green),
              onPressed: () async {
                final call = Uri.parse('tel:${_filteredEvents[index].phone}');
                if (await canLaunchUrl(call)) {
                  launchUrl(call);
                } else {
                  throw 'Could not launch $call';
                }                
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget actualPosition(){
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: const EdgeInsets.only(right: 20, top: 580),
        child: PhysicalModel(
          borderRadius: BorderRadius.circular(100),
          color: Colors.white,
          elevation: 4,
          shadowColor: const Color(0x99000000),
          child: Tooltip(
            message: "Actual Position",
            child: MaterialButton(
              padding: EdgeInsets.zero,
              minWidth: 20,
              height: 20,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              child:  Icon(
                CupertinoIcons.scope,
                size: 25,
                color: Theme.of(context).primaryColorDark,
              ),
              onPressed: () {
                _zoomPanBehavior.zoomLevel = 17;                   
                _zoomPanBehavior.focalLatLng = _currentPosition;
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget tarjetContent(MapEvent item) {
    return Container(
      padding: const EdgeInsets.all(10.0),    //margenes internas tarjeta
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(190),
        border: Border.all(
          color: Colors.transparent,    //tarjeta sin borde
          width: 0,
        ),
        boxShadow: const [
          BoxShadow(              //sombra de la tarjeta
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset.zero)
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(children: <Widget>[  // Adding title and description for card.
        Expanded(
            child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.center,
          children: <Widget>[
            Text(tarjetDescription(item),
                maxLines: 2,        //maximo dos lineas de mensaje en la tarjeta
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
                textAlign: TextAlign.start),
            const SizedBox(height: 4),
            Expanded(                   //Aqui se agrega la descripcion.
                child: Text(
                  item.description,       //descripcion.  
              style:
                  const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            )),
          ],
        )),
      ]),
    );
  }

  Widget splashTarjet(int index, BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: const BorderRadius.all(
            Radius.elliptical(8, 8)),
        onTap: () {
          if (_currentSelectedIndex != index) {
            _pageViewController.animateToPage(
              index,
              duration: const Duration(
                  milliseconds: 500),
              curve: Curves.easeInOut,
            );
          } else {
            final progress =
                ProgressHUD.of(context);
            progress!.show();

            Future.delayed(
                const Duration(seconds: 1), () {
              progress.dismiss();
              Navigator.push(         //navegacion a 
                context,
                MaterialPageRoute(
                  builder: (context) =>
                    EventDetailPage(
                    eventData: _filteredEvents[index],
                    lengthList: _filteredEvents[index].list.length+1,
                  ),
                ),
              );
            });
          }
        },
      ),
    );
  }

  Future <dynamic> emergengyDialog(index){
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog( 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)),                                                                       
        content: Column(
      mainAxisSize: MainAxisSize.min,                                      
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          width: double.infinity,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 2.0, color: Colors.black38),
            ),
          ),
          child: Text(_filteredEvents[index].id,
            style: TextStyle(
            color: Theme.of(context).primaryColorDark,
            fontWeight: FontWeight.bold,  
            fontSize: 40,                                     
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        
        getIconMarker(_filteredEvents[index].icon,index,100),
        const SizedBox(height: 20),
        propDetail(title: 'Nombre :  ',content: _filteredEvents[index].id),
        const SizedBox(height: 22),
        propDetail(title: 'Descripción :  ', content: _filteredEvents[index].description),
        const SizedBox(height: 22),
        propDetail(title: 'Ubicación :  ', content: _filteredEvents[index].direction),
        const SizedBox(height: 7),
        Row(
          children: [
            propDetail(title: 'Telefono :  ' , content: _filteredEvents[index].phone),
            const SizedBox(width: 20,),
            FloatingActionButton(
              heroTag: null,
              backgroundColor: Colors.white,
              child: const Icon(Icons.call, color: Colors.green),
              onPressed: () async {
                final call = Uri.parse('tel:${_filteredEvents[index].phone}');
                if (await canLaunchUrl(call)) {
                  launchUrl(call);
                } else {
                  throw 'Could not launch $call';
                }                
              },
            ),
          ],
        ),
      ],
    ),
    actions: [ 
      ElevatedButton(onPressed: (){
      Navigator.pop(context);}, 
      child: const Text('Cerrar')),                                           
    ]);});
  }

  Widget mapEvents() {
    return Flexible(
      child: _isloading ?Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
          ),
          child: Stack(
            children: <Widget>[
              SfMaps(
                layers: <MapLayer>[
                  MapTileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    zoomPanBehavior: _zoomPanBehavior,
                    initialFocalLatLng: _currentPosition,
                    controller: _mapController,
                    initialMarkersCount: _filteredEvents.length,
                    tooltipSettings: const MapTooltipSettings(
                      color: Colors.transparent),                    
                    markerBuilder: (BuildContext context, int index) {
                      final double markerSize = _currentSelectedIndex == index ? 40 : 25;
                      return MapMarker(
                        latitude: _filteredEvents[index].latitude,
                        longitude: _filteredEvents[index].longitude,
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(     //funcion al presionar un marcador
                          onTap: () {
                            final progress = ProgressHUD.of(context);
                            progress!.show();
                            if (_currentSelectedIndex != index) {
                              _canUpdateFocalLatLng = false;
                              _tappedMarkerIndex = index;
                              _pageViewController.animateToPage(   //se cambia la tarjeta de evento por la presionada
                                index,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut,);}
                            if(_filteredEvents[index].kind == 0){                          
                            Future.delayed(const Duration(seconds: 1), () { //ingresamos a los detalles de un evento o emergency
                              progress.dismiss();                              
                                Navigator.push(                                
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EventDetailPage(                                  
                                      eventData: _filteredEvents[index],
                                      lengthList: _filteredEvents[index].list.length+1
                                      ),),);});
                            }else {
                              Future.delayed(const Duration(milliseconds: 100), () {
                                progress.dismiss();
                                emergengyDialog(index);});}},
                          child: AnimatedContainer(         //se redibuja el marcador cambiando color y tamaño 
                            duration: const Duration(milliseconds: 250),
                            height: markerSize,
                            width: markerSize,
                            child: getIconMarker(_filteredEvents[index].icon,index,markerSize)                          
                          ),),);},                 
                    sublayers: showZones ? [drawZones()] : [],
                  ),],),
              showCards && showEvents ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: _cardHeight,    //tamaño de la tarjeta
                        padding: const EdgeInsets.only(bottom: 8), //distancia de la parte inferior de la tarjeta
                        child: PageView.builder(
                          itemCount: _filteredEvents.length - _mapEmergencys.length,      //numero de tarjetas a crear
                          onPageChanged: _handlePageChange,
                          controller: _pageViewController,
                          itemBuilder: (BuildContext context, int index) {
                            final MapEvent item = _filteredEvents[index];   //
                            return Transform.scale(
                              scale: index == _currentSelectedIndex ? 1 : 0.85,  //tamaño tarjeta dependiendo de seleccionado
                              child: Stack(
                                children: <Widget>[
                                  tarjetContent(item),                           // Adding splash to card while tapping.
                                  splashTarjet(index, context)
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ) : widget,
              mapFiltersButton()
            ],
          )
        ) : const Center(
              child: CircularProgressIndicator(),
        )
    );
  }
}


