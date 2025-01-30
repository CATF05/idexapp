import 'package:flutter/material.dart';
import 'package:frontend/models/cours_model.dart';
import 'package:frontend/models/emploi_du_temps.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalandarWidget extends StatefulWidget {
  List<Evenement> evens;
  CalendarTapCallback? onTap;
  CalandarWidget({
    super.key,
    required this.evens,
    this.onTap,
  });

  @override
  State<CalandarWidget> createState() => _CalandarWidgetState();
}

class _CalandarWidgetState extends State<CalandarWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfCalendar(
        view: CalendarView.week,
        dataSource: MeetingDataSource(widget.evens),
        onTap: widget.onTap,
        // monthViewSettings: MonthViewSettings(
        //   appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        // ),
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Evenement> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].heureDebut;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].heureFin;
  }

  @override
  String getSubject(int index) {
    return appointments![index].description;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

// class Meeting {
//   Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

//   String eventName;
//   DateTime from;
//   DateTime to;
//   Color background;
//   bool isAllDay;
// }
