import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../../models/map_event_model.dart';
import '../../models/map_zone_model.dart';
import '../../services/event_services.dart';
import '../../widgets/cupertino_list_tile_widget.dart';
import 'event_detail_page.dart';


class VisualizerPage extends StatefulWidget {
  const VisualizerPage({super.key});

  @override
  State<VisualizerPage> createState() => _MainScreenState();
}

class _MainScreenState extends State<VisualizerPage> {
  final eventService = EventService();

  bool showZones = false;
  bool showEvents = true;
  bool showCards = true;
  bool showDateFilter = false;
  bool showChangeMap = false;
  bool showEmergency = true;
  bool typeOfMap = true;
  DateTimeRange filterDateRange = DateTimeRange(
    start: DateTime(2022, 1, 1),
    end: DateTime(2022, 12, 31),
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

  Widget getImage64(String image64,int index, double markerSize){
    Uint8List image = base64Decode(image64);


    if (image64 != ''){
      return SizedBox(
        width: markerSize + 20,
        height: markerSize + 20,
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
          icon: '' 
          ));
          _mapEvents.add(MapEvent(
          id: event['id'],
          date: event['date'],
          status: event['status'],
          time: event['time'],
          zoneCode: event['zone'],
          latitude: 6.272622, 
          longitude: -75.608296,
          description: "",
          comment: 'evento fake', 
          direction: '', 
          kind: 0, 
          phone: '', 
          icon: ''
          ));
    } 
    print("cargando eventos");  
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
      icon: emergency['image']
      )); 
      desplazar = desplazar + 0.01;    
    }
    desplazar = 0;
  }

  void loadFilteredEvents() {
    _mapController.clearMarkers();
    _filteredEvents.clear();
    print("Switching");

    if (showEvents) {
      int markersCount = 0;

      for (MapEvent mapEvent in _mapEvents) {
        final eventDate = DateTime.parse('${mapEvent.date} ${mapEvent.time}');

          _filteredEvents.add(mapEvent);
          _mapController.insertMarker(markersCount);
          markersCount++;
      }
    } else {
      print("disabled");
    }

    if (showEmergency){
      int totalMarkers = _filteredEvents.length;
      _filteredEvents.addAll(_mapEmergencys);      
      for (MapEvent map in _mapEmergencys){
        _mapController.insertMarker(totalMarkers);
        totalMarkers++;
        
      }
    }
    setState(() {});
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

    });

    _zoomPanBehavior = MapZoomPanBehavior(
        zoomLevel: 12,
        minZoomLevel: 3,
        maxZoomLevel: 15,
        focalLatLng: const MapLatLng(6.217, -75.567),
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

  Widget mapFilters() {
    final filterStartDate = filterDateRange.start;
    final filterEndDate = filterDateRange.end;

    return Stack(
      children: [
        
        showDateFilter ? Container(
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
                ))
            : const SizedBox(),
        showChangeMap ? Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: const EdgeInsets.only(right: 8, top: 128),
            child: PhysicalModel(
              borderRadius: BorderRadius.circular(100),
              color: Colors.white,
              elevation: 4,
              shadowColor: const Color(0x99000000),
              child: Tooltip(
                message: "Map style",
                child: MaterialButton(
                  padding: EdgeInsets.zero,
                  minWidth: 40,
                  height: 40,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  child: const Icon(
                    CupertinoIcons.map,
                    size: 16,
                    color: CupertinoColors.secondaryLabel,
                  ),
                  onPressed: () {
                    
                    setState(() { 
                      typeOfMap = !typeOfMap;
                    });
                  },
                ),
              ),
            ),
          ),
        ) : const SizedBox()
      ],
    );
  }

  Widget mapEvents() {
    return Flexible(
      child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
          ),
          child: Stack(
            children: <Widget>[
              SfMaps(
                layers: <MapLayer>[
                  MapTileLayer(
                    urlTemplate: typeOfMap
                        ? 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'
                        : 'https://b.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
                    zoomPanBehavior: _zoomPanBehavior,
                    controller: _mapController,
                    //_filteredEvents = _filteredEvents.addAll(_mapEmergencys),
                    initialMarkersCount: _filteredEvents.length,
                    tooltipSettings: const MapTooltipSettings(
                      color: Colors.transparent,
                    ),
                    
                    markerBuilder: (BuildContext context, int index) {   //cambio entre marcadores
                      final double markerSize =
                          _currentSelectedIndex == index ? 40 : 25;
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
                                curve: Curves.easeInOut,
                              );
                            }

                            if(_filteredEvents[index].kind == 0){                          
                            Future.delayed(const Duration(seconds: 1), () { //ingresamos a los detalles de un evento o emergency
                              progress.dismiss();
                              
                                Navigator.push(                                
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EventDetailPage(
                                      eventData: _filteredEvents[index],
                                      ),
                                ),
                              );
                              }                              
                            );
                            }else {
                              Future.delayed(const Duration(milliseconds: 100), () {
                                progress.dismiss();

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog( 
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)
                                    ),                                                                       
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
                                        
                                        getImage64(_filteredEvents[index].icon,index,100),
                                        const SizedBox(height: 20),
                                        propDetail(title: 'Nombre :  ',content: _filteredEvents[index].id),
                                        const SizedBox(height: 10),
                                        propDetail(title: 'Descripción :  ', content: _filteredEvents[index].description),
                                        const SizedBox(height: 10),
                                        propDetail(title: 'Ubicación :  ', content: _filteredEvents[index].direction),
                                        const SizedBox(height: 10),
                                        propDetail(title: 'Telefono :  ' , content: _filteredEvents[index].phone),
                                        const SizedBox(height: 10),

                                      ],
                                    ),
                                    actions: [
                                       ElevatedButton(onPressed: (){
                                          Navigator.pop(context);
                                          }, 
                                          child: const Text('Cerrar')
                                          ),                                        
                                      ]                                  
                                    );
                                  }
                                  );
                              });
                            }

                          },
                          child: AnimatedContainer(         //se redibuja el marcador cambiando color y tamaño 
                            duration: const Duration(milliseconds: 250),
                            height: markerSize,
                            width: markerSize,
                            child: getImage64(_filteredEvents[index].icon,index,markerSize)
                            
                            
                          ),
                        ),
                      );
                    },
                    sublayers: showZones
                        ? [
                            MapCircleLayer(
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
                            ),
                          ]
                        : [],
                  ),
                ],
              ),
              mapFilters(),
              showCards && showEvents         //TARJETAS
                  ? Align(
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
                                  Container(
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
                                    child: Row(children: <Widget>[
                                      // Adding title and description for card.
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(_filteredEvents[index].comment,
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
                                      // Adding Image for card.
                                    ]),
                                  ),
                                  // Adding splash to card while tapping.
                                  Material(
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
                                                        eventData:
                                                            _filteredEvents[
                                                                index]),
                                              ),
                                            );
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          )),
    );
  }

  void filtersDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
        return CupertinoAlertDialog(
          title: const Text('Filtros adicionales'),
          content: Container(
            margin: const EdgeInsets.only(top: 8),
            child: Column(
              children: [
                CupertinoListTile(
                  text: "Zonas calientes",
                  color: Colors.transparent,
                  onPressed: () {
                    setModalState(() {
                      showZones = !showZones;
                    });
                    setState(() {});
                  },
                  child: CupertinoSwitch(
                    value: showZones,
                    thumbColor: CupertinoColors.white,
                    trackColor: CupertinoColors.extraLightBackgroundGray,
                    onChanged: (bool? value) {
                      setModalState(() {
                        showZones = value!;
                      });
                      setState(() {});
                    },
                  ),
                ),
                CupertinoListTile(
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
                CupertinoListTile(
                  text: "Filtro de fecha",
                  color: Colors.transparent,
                  onPressed: () {
                    setModalState(() {
                      showDateFilter = !showDateFilter;
                    });
                    setState(() {});
                  },
                  child: CupertinoSwitch(
                    value: showDateFilter,
                    thumbColor: CupertinoColors.white,
                    trackColor: CupertinoColors.extraLightBackgroundGray,
                    onChanged: (bool? value) {
                      setModalState(() {
                        showDateFilter = !showDateFilter;
                      });
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Atrás',
                style: TextStyle(color: CupertinoColors.link),
              ),
            ),
          ],
        );
      }),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          foregroundColor: Theme.of(context).primaryColorDark,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "Visualizador 1",
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontWeight: FontWeight.bold,
            ),
          ),
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
          padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 16),
          child: SafeArea(
            child: Column(
              children: [mapEvents()],
            ),
          ),
        ),
      ),
    );
  }
}
