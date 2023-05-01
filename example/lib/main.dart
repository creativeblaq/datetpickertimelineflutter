import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: const [
        FormBuilderLocalizations.delegate,
      ],
      home: MyHomePage(title: 'Date Picker Timeline Demo'),
    );
  }
}

List<EventModel> testEvents = [/* 
  EventModel(
    title: "The event in 5 days",
    icon: Icons.monetization_on_outlined,
    description:
        "This is some description for testing. Let us make it loneger so we can see what it actuallu looks like when it is in multiple lines.",
    startDateTime: DateTime.now().add(Duration(days: 5)),
    endDateTime: DateTime.now().add(Duration(days: 5, minutes: 5)),
    eventType: 'eventType',
    eventColor: Colors.redAccent,
    location: '2356 Mareka Street, Sharpeveille',
    repeats: EventRepeats.never,
  ),
  EventModel(
      title: "1",
      startDateTime: DateTime.now().add(Duration(days: 6, hours: 18)),
      endDateTime: DateTime.now().add(Duration(days: 10)),
      eventType: 'eventType',
      eventColor: Colors.blueAccent),
  EventModel(
      title: "1",
      startDateTime: DateTime.now().add(Duration(days: 1, hours: 13)),
      endDateTime: DateTime.now().add(Duration(days: 1)),
      eventType: 'eventType',
      eventColor: Colors.orangeAccent),
  EventModel(
      title: "1",
      startDateTime: DateTime.now().add(Duration(days: 10, hours: 9)),
      endDateTime: DateTime.now().add(Duration(days: 12)),
      eventType: 'eventType',
      eventColor: Colors.blueGrey),
  EventModel(
      title: "1",
      startDateTime: DateTime.now().add(Duration(days: 10)),
      endDateTime: DateTime.now().add(Duration(days: 12)),
      eventType: 'eventType',
      eventColor: Colors.black),
  EventModel(
      title: "1",
      startDateTime: DateTime.now().add(Duration(days: 10)),
      endDateTime: DateTime.now().add(Duration(days: 12)),
      eventType: 'eventType',
      eventColor: Colors.purple),
  EventModel(
      title: "1",
      startDateTime: DateTime.now().add(Duration(days: 10)),
      endDateTime: DateTime.now().add(Duration(days: 12)),
      eventType: 'eventType',
      eventColor: Colors.red),
  EventModel(
      title: "1",
      startDateTime: DateTime.now().add(Duration(days: 10)),
      endDateTime: DateTime.now().add(Duration(days: 12)),
      eventType: 'eventType',
      eventColor: Colors.brown),
  EventModel(
      title: "1",
      startDateTime: DateTime.now().add(Duration(days: 3)),
      endDateTime: DateTime.now().add(Duration(days: 5)),
      eventType: 'eventType',
      repeats: EventRepeats.daily,
      eventColor: Colors.purpleAccent),
  EventModel(
      title: "1",
      startDateTime: DateTime.now().add(Duration(days: 31)),
      endDateTime: DateTime.now().add(Duration(days: 32)),
      eventType: 'eventType',
      eventColor: Colors.redAccent), */
];

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatePickerController _controller = DatePickerController();

  DateTime _selectedValue = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  final listBackgroundColor = Colors.grey[800];
  final headerBackgroundColor = Colors.grey[800];
  double? height;
  double? width;
  double borderRadius = 16;
  double headerElevation = 6;
  double elevation = 6;
  Color selectionColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    height = size.height * 0.7;

    return Scaffold(
      body: Center(
        child: EventsViewer(
            height: height,
            headerBackgroundColor: headerBackgroundColor,
            bodyBackgroundColor: listBackgroundColor,
            unselectedColor: Colors.grey[500]!,
            selectionColor: selectionColor,
            events: testEvents,
            onEventTap: (EventModel event, int index) {
              //print(event);
              //TODO: Show Dialog
              EventDialog(
                onMarkComplete: (EventModel e) {
                  print(
                      "\n===================\n" + e.toString() + "\nComplete");
                      setState(() {
                    testEvents.remove(e);
                  });
                },
                event: event,
                onDelete: (EventModel event) {
                  setState(() {
                    testEvents.remove(event);
                  });
                },
                onEdit: (EventModel event) {},
              ).show(context);
            },
            showAddEventBtn: true,
            onDateChanged: (date) {},
            onAddEvent: (date) {
              showCustomDialog(
                  context,
                  EventActionView(
                    defaultTextStyle: TextStyle(fontSize: 14),
                    hintStyle: TextStyle(fontSize: 14),
                    labelStyle: TextStyle(fontSize: 12),
                    eventStates: EventState.values.map((e) => e.name).toList(),
                    eventTypes: ['general'],
                    repeatTypes:
                        EventRepeats.values.map((e) => e.name).toList(),
                    onCreateEvent: (EventModel event) {
                      setState(() {
                        testEvents.add(event);
                      });
                    },
                  ));
            }),
      ),
    );
  }
}
