import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:flutter/material.dart';

class MapZone {
  final MapLatLng center;
  final double radius;
  final Color color;
  final int code;
  final List events;
  final List posts;

  MapZone(
      {required this.center,
      required this.color,
      required this.radius,
      required this.code,
      required this.events,
      required this.posts});
}
