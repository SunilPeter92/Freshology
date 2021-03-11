// To parse this JSON data, do
//
//     final timeSlots = timeSlotsFromJson(jsonString);

import 'dart:convert';

TimeSlot timeSlotsFromJson(String str) => TimeSlot.fromJson(json.decode(str));

String timeSlotsToJson(TimeSlot data) => json.encode(data.toJson());

class TimeSlot {
  TimeSlot({this.id, this.dateTime, this.available, this.isFree, this.checked});

  int id;
  String dateTime;
  String available;
  String isFree;
  bool checked;

  factory TimeSlot.fromJson(Map<String, dynamic> json) => TimeSlot(
        id: json["id"] == null ? null : json["id"],
        dateTime: json["date_time"] == null ? null : json["date_time"],
        available: json["available"] == null ? null : json["available"],
        isFree: json["is_free"] == null ? null : json["is_free"],
        checked: false,
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "date_time": dateTime == null ? null : dateTime,
        "available": available == null ? null : available,
        "is_free": isFree == null ? null : isFree,
      };
}
