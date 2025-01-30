import 'package:frontend/models/event_model.dart';
import 'package:frontend/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/widgets/side_bar.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

class EmploiDuTemps extends StatelessWidget {
  Widget home;
  EmploiDuTemps({super.key, required this.home});

  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          ExampleSidebarX(
            controller: _controller,
            home: home,
          ),
          const Expanded(
            child: EmploiDuTempsHome(),
          ),
        ],
      ),
    );
  }
}

class EmploiDuTempsHome extends ConsumerStatefulWidget {
  const EmploiDuTempsHome({super.key});

  @override
  ConsumerState<EmploiDuTempsHome> createState() => _EmploiDuTempsHomeState();
}

class _EmploiDuTempsHomeState extends ConsumerState<EmploiDuTempsHome> {
  List<EventModel> events = <EventModel>[];
  late Color dialogPickerColor;

  @override
  void initState() {
    super.initState();
    dialogPickerColor = Colors.green;
  }

  // @override
  // void initState() {
  //   super.initState();
  //   fetchData();
  // }

  Future<void> _getDataSource() async {
    events = [];

    try {
      final querySnapshot2 =
          await FirebaseFirestore.instance.collection('events').get();
      for (var f in querySnapshot2.docs) {
        events.add(EventModel.fromMap(f.data()));
      }
      setState(() {});
    } catch (e) {
      debugPrint('Erreur: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getDataSource();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planifier des Événements',
            style: TextStyle(color: Colors.white)),
        backgroundColor: canvasColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              // height: 65,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 1,
                    color: Color(0x33000000),
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const Text(
                          "Événements de la journée",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          events
                              .where((e) =>
                                  (e.from.year == DateTime.now().year &&
                                      e.from.month == DateTime.now().month &&
                                      e.from.day == DateTime.now().day))
                              .length
                              .toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          "Événements planifiés",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          events.length.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        TextButton(
                          onPressed: () {},
                          style: const ButtonStyle(
                            fixedSize: WidgetStatePropertyAll(Size(200, 30)),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                side: BorderSide(width: 1),
                              ),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.filter_alt_outlined,
                                color: Colors.black,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Filtrer",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextButton(
                          onPressed: ajouterModifierEvenement,
                          style: const ButtonStyle(
                            fixedSize: WidgetStatePropertyAll(Size(200, 30)),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                side: BorderSide(width: 1),
                              ),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.black,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Ajouter un Événement",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: CalandarSecretaire(
                evens: events,
                onTap: (calendarTapDetails) {
                  ajouterModifierEvenement(
                    calendarTapDetails: calendarTapDetails,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void ajouterModifierEvenement(
      {CalendarTapDetails? calendarTapDetails}) async {
    final formKey = GlobalKey<FormState>();
    DateTime selectedDate = calendarTapDetails == null
        ? DateTime.now()
        : calendarTapDetails.appointments!.first.from;
    TimeOfDay selectedTimeStart = calendarTapDetails == null
        ? TimeOfDay.now()
        : TimeOfDay.fromDateTime(calendarTapDetails.appointments!.first.from);
    TimeOfDay selectedTimeEnd = calendarTapDetails == null
        ? TimeOfDay.now()
        : TimeOfDay.fromDateTime(calendarTapDetails.appointments!.first.to);
    TextEditingController descriptionController = TextEditingController(
        text: calendarTapDetails == null
            ? ""
            : calendarTapDetails.appointments!.first.eventName);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
          return AlertDialog(
            title: calendarTapDetails == null
                ? const Text("Ajouter un Événement")
                : Text(calendarTapDetails.appointments!.first.eventName),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: descriptionController,
                    validator: validationNotNull,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Déscription',
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                    controller: TextEditingController(
                      text: selectedDate.toString().split(' ')[0],
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setModalState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Démarre à',
                            border: OutlineInputBorder(),
                          ),
                          readOnly: true,
                          controller: TextEditingController(
                              text: selectedTimeStart.format(context)),
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (pickedTime != null) {
                              setModalState(() {
                                selectedTimeStart = pickedTime;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Arréte à',
                            border: OutlineInputBorder(),
                          ),
                          readOnly: true,
                          controller: TextEditingController(
                              text: selectedTimeEnd.format(context)),
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (pickedTime != null) {
                              setModalState(() {
                                selectedTimeEnd = pickedTime;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: colorPickerDialog,
                    style: ButtonStyle(
                      fixedSize: const WidgetStatePropertyAll(Size(180, 30)),
                      backgroundColor: WidgetStatePropertyAll(
                        calendarTapDetails == null
                            ? dialogPickerColor
                            : calendarTapDetails.appointments!.first.background,
                      ),
                      shape: const WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Ajouter une couleur",
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              if (calendarTapDetails != null)
                TextButton(
                  onPressed: () async {
                    setState(() {
                      events.removeWhere((e) =>
                          e.idEvent ==
                          calendarTapDetails.appointments!.first.idEvent);
                    });
                    await FirebaseFirestore.instance
                        .collection('events')
                        .doc(calendarTapDetails.appointments!.first.idEvent)
                        .delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Événement Supprimé")),
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Supprimer',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () async {
                  if (formKey.currentState?.validate() ?? false) {
                    EventModel eventModel = EventModel(
                      idEvent: calendarTapDetails == null
                          ? generateIdStudent('EV', 5)
                          : calendarTapDetails.appointments!.first.idEvent,
                      eventName: descriptionController.text,
                      from: selectedDate.add(Duration(
                        hours: selectedTimeStart.hour,
                        minutes: selectedTimeStart.minute,
                      )),
                      to: selectedDate.add(Duration(
                        hours: selectedTimeEnd.hour,
                        minutes: selectedTimeEnd.minute,
                      )),
                      background: dialogPickerColor,
                    );
                    if (calendarTapDetails != null) {
                      setState(() {
                        events.removeWhere((e) =>
                            e.idEvent ==
                            calendarTapDetails.appointments!.first.idEvent);
                      });
                    }
                    setState(() {
                      events.add(eventModel);
                    });

                    await FirebaseFirestore.instance
                        .collection('events')
                        .doc(eventModel.idEvent)
                        .set(eventModel.toMap());

                    Navigator.of(context).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Événement ajouté")),
                    );
                  }
                },
                child: const Text('Confirmer'),
              ),
            ],
          );
        });
      },
    );
  }

  Future<bool> colorPickerDialog() async {
    return ColorPicker(
      // Use the dialogPickerColor as start and active color.
      color: dialogPickerColor,
      // Update the dialogPickerColor using the callback.
      onColorChanged: (Color color) =>
          setState(() => dialogPickerColor = color),
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorCodeTextStyle: Theme.of(context).textTheme.bodySmall,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: false,
        ColorPickerType.custom: true,
        ColorPickerType.wheel: true,
      },
      customColorSwatchesAndNames: Constants.colorsNameMap,
    ).showPickerDialog(
      context,
      // New in version 3.0.0 custom transitions support.
      transitionBuilder: (BuildContext context, Animation<double> a1,
          Animation<double> a2, Widget widget) {
        final double curvedValue =
            Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: widget,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
      constraints: const BoxConstraints(
        minHeight: 460,
        minWidth: 300,
        maxWidth: 320,
      ),
    );
  }
}

class CalandarSecretaire extends StatefulWidget {
  List<EventModel> evens;
  CalendarTapCallback? onTap;
  CalandarSecretaire({
    super.key,
    required this.evens,
    this.onTap,
  });

  @override
  State<CalandarSecretaire> createState() => _CalandarSecretaireState();
}

class _CalandarSecretaireState extends State<CalandarSecretaire> {
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
  MeetingDataSource(List<EventModel> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  // @override
  // bool isAllDay(int index) {
  //   return appointments![index].isAllDay;
  // }
}
