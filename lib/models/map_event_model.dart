class MapEvent {
  final String id;
  final int zoneCode;
  final int status;
  final double latitude;
  final double longitude;
  final String date;
  final String time;
  final String description;
  final String comment;
  final String phone;
  final String direction;
  final int kind;
  final String icon;
  final int type;
  final List more;
  final List list;


  const MapEvent(
      {required this.description,
      required this.id,
      required this.comment,
      required this.latitude,
      required this.longitude,
      required this.date,
      required this.status,
      required this.time,
      required this.zoneCode,
      required this.phone,
      required this.direction,
      required this.kind,
      required this.icon,
      required this.type,
      required this.more,
      required this.list

      });
      

}