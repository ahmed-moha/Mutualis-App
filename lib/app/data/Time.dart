import 'dart:convert';


class Time
{
  Time({
    required this.id,
    required this.doctor_id,
    required this.day,
    required this.start_times,
    this.created_at,
    this.updated_at
  });

  int id;
  String doctor_id;
  String day;
  String start_times;
  String? created_at;
  String? updated_at;

  List<Time> postFromJson(String str) =>
      List<Time>.from(json.decode(str).map((x) => Time.fromMap(x)));

  factory Time.fromMap(Map<String, dynamic> json) {
    return Time(
      id: json['id'],
      doctor_id: json['doctor_id'],
      day: json['day'],
      start_times: json['start_times'],
    );
  }
}