class MapEmergency {
  final String id;
  final double latitude;
  final double longitude;
  final String description;
  final String phone;
  final String direction;



  const MapEmergency(
    {required this.id,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.phone,
    required this.direction }
  );
}