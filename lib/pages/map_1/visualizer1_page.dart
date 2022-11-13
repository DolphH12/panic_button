import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../services/event_services.dart';

class Visualizer1Page extends StatefulWidget {
  const Visualizer1Page({super.key});

  @override
  State<Visualizer1Page> createState() => _VisualizerPageState();
}

class _VisualizerPageState extends State<Visualizer1Page> {

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
      body: const MapaWidget(),
    );
  }
}

class MapaWidget extends StatefulWidget {
  const MapaWidget({super.key});

  @override
  State<MapaWidget> createState() => _MapaWidgetState();
}

class _MapaWidgetState extends State<MapaWidget> with SingleTickerProviderStateMixin {
  
  Set<Marker> markers = {};
  final eventsServices = EventService();

  late TabController _tabController;
  late List<dynamic> allEvents;
  String zona = "Selecciona una zona";
  int contId = 0;
  bool inicializar = true;
  bool tab = false;

  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 10);
    _handleTabSelection();
  }

  Future<void> _handleTabSelection() async {
    if (_tabController.indexIsChanging || inicializar || tab) {
      inicializar = false;
      tab = false;
      markers = {};
      contId = 0;

      // BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
      //     const ImageConfiguration(),
      //     "assets/marker.png",
      // );

      switch (_tabController.index) {
        case 0:
            allEvents = await eventsServices.allEvents();
            setState(() {
              for (var element in allEvents) {
                contId++;
                markers.add(Marker(
                  markerId: MarkerId(contId.toString()),
                  onDrag: null,
                  onDragStart: null,
                  onTap: () {
                    Navigator.pushNamed(context, "detail1", arguments: {'alerta' : element});
                  },
                  position: LatLng(double.parse(element["location"][0].toString()), double.parse(element["location"][1].toString())),
                ));
              }
            });
          break;
        case 1:
          final AlertDialog dialog = AlertDialog(
            title: const Text('Lista de zonas'),
            contentPadding: EdgeInsets.zero,
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i <= 25; i++)
                    ListTile(
                      title: Text(
                        'Zona $i',
                      ),
                      onTap: () async {
                          allEvents = await eventsServices.zoneEvents(i.toString());
                          setState(() {
                            tab = true;
                            zona = "Zona $i";
                            for (var element in allEvents) {
                              contId++;
                              markers.add(Marker(
                                markerId: MarkerId(contId.toString()),
                                onDrag: null,
                                onDragStart: null,
                                onTap: () {
                                  Navigator.pushNamed(context, "detail1", arguments: {'alerta' : element});
                                },
                                position: LatLng(double.parse(element["location"][0].toString()), double.parse(element["location"][1].toString())),
                              ));
                            }
                          });
                          if(!mounted) return;
                          Navigator.pop(context);
                      },
                    ),
                ],
              ),
            ),
          );

          showDialog<void>(context: context, builder: (context) => dialog);

          break;

          case 2:
          allEvents = await eventsServices.statusEvents("1");
            setState(() {
              for (var element in allEvents) {
                contId++;
                markers.add(Marker(
                  markerId: MarkerId(contId.toString()),
                  onDrag: null,
                  onDragStart: null,
                  onTap: () {
                    Navigator.pushNamed(context, "detail1", arguments: {'alerta' : element});
                  },
                  position: LatLng(double.parse(element["location"][0].toString()), double.parse(element["location"][1].toString())),
                ));
              }
            });
          break;

          case 3:
          allEvents = await eventsServices.statusEvents("2");
            setState(() {
              for (var element in allEvents) {
                contId++;
                markers.add(Marker(
                  markerId: MarkerId(contId.toString()),
                  onDrag: null,
                  onDragStart: null,
                  onTap: () {
                    Navigator.pushNamed(context, "detail1", arguments: {'alerta' : element});
                  },
                  position: LatLng(double.parse(element["location"][0].toString()), double.parse(element["location"][1].toString())),
                ));
              }
            });
          break;

          case 4:
          allEvents = await eventsServices.statusEvents("3");
            setState(() {
              for (var element in allEvents) {
                contId++;
                markers.add(Marker(
                  markerId: MarkerId(contId.toString()),
                  onDrag: null,
                  onDragStart: null,
                  onTap: () {
                    Navigator.pushNamed(context, "detail1", arguments: {'alerta' : element});
                  },
                  position: LatLng(double.parse(element["location"][0].toString()), double.parse(element["location"][1].toString())),
                ));
              }
            });
          break;
          
          

          default: 
            markers = {};
            setState(() {
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Categoría sin implementar..."), behavior: SnackBarBehavior.floating, margin: EdgeInsets.only(bottom: 50), duration: Duration(seconds: 1),)
            );
          break;
      } 
    } else {
        markers = {};
        contId  = 0;
      }
  }

  @override
  void dispose() {
      _tabController.dispose();
      super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // _determinePosition();
    return FutureBuilder(
      future: _loadLocation(),
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.hasData) {
          
        final data = snapshot.data!;

        return Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition : CameraPosition(
                target:  LatLng(double.parse(data['lat']), double.parse(data['lon'])),
                zoom: 12
              ),
              myLocationButtonEnabled: true,
              myLocationEnabled :true,
              markers : markers,
              
            ),
          ),

          SizedBox(
            height: 45,  
            child: AppBar(
              backgroundColor: Colors.white,
              bottom: TabBar(
                indicator: const BoxDecoration(
                  color: Color.fromARGB(97, 0, 74, 124),
                ),
                controller: _tabController,
                isScrollable: true,
                onTap: (value) {
                  _handleTabSelection();
                },
                tabs: [
                  Tab(
                    height: 43,
                    child: Container(
                      margin: const EdgeInsets.only(top:5, bottom: 5),
                      child: Image.asset(
                        'assets/all.png',
                      ),
                    ),
                  ),
                  Tab(
                    height: 43,
                    child: Container(
                      margin: const EdgeInsets.only(top:5, bottom: 5),
                      child: Image.asset(
                        'assets/zona_1.png',
                      ),
                    ),
                  ),
                  Tab(
                    height: 36,
                    child: Container(
                      margin: const EdgeInsets.only(top:5, bottom: 5),
                      child: Image.asset(
                        'assets/activo.png',
                      ),
                    ),
                  ),
                  Tab(
                    height: 36,
                    child: Container(
                      margin: const EdgeInsets.only(top:5, bottom: 5),
                      child: Image.asset(
                        'assets/inactivo.png',
                      ),
                    ),
                  ),
                  Tab(
                    height: 36,
                    child: Container(
                      margin: const EdgeInsets.only(top:5, bottom: 5),
                      child: Image.asset(
                        'assets/descartado.png',
                      ),
                    ),
                  ),

                  Tab(
                    height: 43,
                    child: Container(
                      margin: const EdgeInsets.only(top:5, bottom: 5),
                      child: Image.asset(
                        'assets/futuro.png',
                      ),
                    ),
                  ),

                  Tab(
                    height: 43,
                    child: Container(
                      margin: const EdgeInsets.only(top:5, bottom: 5),
                      child: Image.asset(
                        'assets/futuro.png',
                      ),
                    ),
                  ),

                  Tab(
                    height: 43,
                    child: Container(
                      margin: const EdgeInsets.only(top:5, bottom: 5),
                      child: Image.asset(
                        'assets/futuro.png',
                      ),
                    ),
                  ),

                  Tab(
                    height: 43,
                    child: Container(
                      margin: const EdgeInsets.only(top:5, bottom: 5),
                      child: Image.asset(
                        'assets/futuro.png',
                      ),
                    ),
                  ),

                  Tab(
                    height: 43,
                    child: Container(
                      margin: const EdgeInsets.only(top:5, bottom: 5),
                      child: Image.asset(
                        'assets/futuro.png',
                      ),
                    ),
                  ),

                  
                ],
              ),
            ),
          ),
        ],
      );
        } else {
          return Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Theme.of(context).primaryColorDark,
                ),
              ],
            ),
          );
        }
      } 
    );
  }

  _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permisos de localización denegados.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Permisos de localización degenados, no es posible solicatar permisos.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<Map<String, dynamic>> _loadLocation() async {
    
    Position location = await _determinePosition();
    Map<String, dynamic> loc = {};
    
    loc['lat'] = location.latitude.toString();
    loc['lon'] = location.longitude.toString();

    return loc;
  }
}
