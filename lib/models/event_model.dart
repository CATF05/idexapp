// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:ui';

class EventModel {
  String idEvent;
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  EventModel({
    required this.idEvent,
    required this.eventName,
    required this.from,
    required this.to,
    required this.background,
  });

  EventModel copyWith({
    String? idEvent,
    String? eventName,
    DateTime? from,
    DateTime? to,
    Color? background,
  }) {
    return EventModel(
      idEvent: idEvent ?? this.idEvent,
      eventName: eventName ?? this.eventName,
      from: from ?? this.from,
      to: to ?? this.to,
      background: background ?? this.background,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idEvent': idEvent,
      'eventName': eventName,
      'from': from.millisecondsSinceEpoch,
      'to': to.millisecondsSinceEpoch,
      'background': background.value,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      idEvent: map['idEvent'] as String,
      eventName: map['eventName'] as String,
      from: DateTime.fromMillisecondsSinceEpoch(map['from'] as int),
      to: DateTime.fromMillisecondsSinceEpoch(map['to'] as int),
      background: Color(map['background'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) => EventModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EventModel(idEvent: $idEvent, eventName: $eventName, from: $from, to: $to, background: $background)';
  }

  @override
  bool operator ==(covariant EventModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.idEvent == idEvent &&
      other.eventName == eventName &&
      other.from == from &&
      other.to == to &&
      other.background == background;
  }

  @override
  int get hashCode {
    return idEvent.hashCode ^
      eventName.hashCode ^
      from.hashCode ^
      to.hashCode ^
      background.hashCode;
  }
}
