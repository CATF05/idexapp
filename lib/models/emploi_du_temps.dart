// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';
// import 'dart:ui';

// class EmploiDuTemps {
//   // String salle;
//   String eventName;
//   DateTime from;
//   DateTime to;
//   Color background;
//   bool isAllDay;
//   EmploiDuTemps({
//     required this.eventName,
//     required this.from,
//     required this.to,
//     required this.background,
//     required this.isAllDay,
//   });

//   EmploiDuTemps copyWith({
//     String? eventName,
//     DateTime? from,
//     DateTime? to,
//     Color? background,
//     bool? isAllDay,
//   }) {
//     return EmploiDuTemps(
//       eventName: eventName ?? this.eventName,
//       from: from ?? this.from,
//       to: to ?? this.to,
//       background: background ?? this.background,
//       isAllDay: isAllDay ?? this.isAllDay,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'eventName': eventName,
//       'from': from.millisecondsSinceEpoch,
//       'to': to.millisecondsSinceEpoch,
//       'background': background.value,
//       'isAllDay': isAllDay,
//     };
//   }

//   factory EmploiDuTemps.fromMap(Map<String, dynamic> map) {
//     return EmploiDuTemps(
//       eventName: map['eventName'] as String,
//       from: DateTime.fromMillisecondsSinceEpoch(map['from'] as int),
//       to: DateTime.fromMillisecondsSinceEpoch(map['to'] as int),
//       background: Color(map['background'] as int),
//       isAllDay: map['isAllDay'] as bool,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory EmploiDuTemps.fromJson(String source) => EmploiDuTemps.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() {
//     return 'EmploiDuTemps(eventName: $eventName, from: $from, to: $to, background: $background, isAllDay: $isAllDay)';
//   }
// }
