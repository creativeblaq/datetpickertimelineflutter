import 'package:date_picker_timeline/models/event_model.dart';
import 'package:date_picker_timeline/utils/utils.dart';
import 'package:date_picker_timeline/widgets/widgets.dart';
import 'package:flutter/material.dart';

class EventsViewer extends StatefulWidget {
  final TextStyle? titleStyle;

  final Color unselectedColor;

  final Color selectionColor;

  final double? itemWidth;

  final double? itemHeight;

  final int daysCount;

  final bool? showMonth;

  final bool? showIndicators;

  final DateWidgetType? type;

  final TextStyle? monthTextStyle;

  final TextStyle? dateTextStyle;

  final TextStyle? dayTextStyle;

  final List<EventModel> events;

  final EdgeInsets? bodyPadding;

  final TextStyle? timeSeparatorStyle;

  final Color? selectedTextColor;

  final bool showAddEventBtn;

  final Color? addEventButtonColor;

  final IconData? addEventIcon;

  final Color? addEventIconColor;

  final Function(DateTime date) onDateChanged;

  final Future<EventModel>? Function(DateTime date) onAddEvent;
  final Function(EventModel event, int index) onEventTap;

  final Color? bodyBackgroundColor;
  final Color? headerBackgroundColor;
  final double? height;
  final double? width;
  final double borderRadius;
  final double headerElevation;
  final double elevation;

  final DateTime? startDate;

  EventsViewer({
    Key? key,
    this.titleStyle,
    required this.unselectedColor,
    required this.selectionColor,
    this.itemWidth,
    this.itemHeight,
    this.daysCount = 1000,
    this.showMonth,
    this.showIndicators,
    this.type,
    this.monthTextStyle,
    this.dateTextStyle,
    this.dayTextStyle,
    this.startDate,
    required this.events,
    this.bodyPadding,
    this.timeSeparatorStyle,
    this.selectedTextColor,
    required this.showAddEventBtn,
    this.addEventButtonColor,
    this.addEventIcon,
    this.addEventIconColor,
    required this.onDateChanged,
    required this.onEventTap,
    required this.onAddEvent,
    this.bodyBackgroundColor,
    this.headerBackgroundColor,
    this.height,
    this.width,
    this.borderRadius = 16,
    this.headerElevation = 6,
    this.elevation = 8,
  }) : super(key: key);

  @override
  _EventsViewerState createState() => _EventsViewerState();
}

class _EventsViewerState extends State<EventsViewer> {
  DatePickerController _controller = DatePickerController();

  DateTime _selectedValue = DateTime.now();

  @override
  void initState() {
    _lastDate = DateTime.now().add(Duration(days: widget.daysCount));
    super.initState();
  }

  int _selectedMonth = DateTime.now().month;
  late DateTime _lastDate;
  DateTime _titleDate = DateTime.now();
  bool _canGoBack = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    //height = size.height * 0.7;

    return Container(
      margin: EdgeInsets.all(8.0),
      height: widget.height ?? size.height,
      width: widget.width ?? size.width,
      decoration: BoxDecoration(
        //color: headerBackgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: Stack(
        fit: StackFit.loose,
        children: [
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius)),
            elevation: widget.elevation,
            color: widget.bodyBackgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius)),
                  elevation: widget.headerElevation,
                  color: widget.headerBackgroundColor,
                  margin: EdgeInsets.zero,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 16.0, right: 8, top: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${_titleDate.formatDateToDDMY()}",
                                style: widget.titleStyle ??
                                    TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (!_canGoBack) {
                                  return;
                                }
                                if (_selectedMonth <= 12 &&
                                    _selectedMonth > 1) {
                                  setState(() {
                                    _selectedMonth--;
                                    _titleDate = DateTime(
                                        _titleDate.year, _selectedMonth, 1);

                                    if (_titleDate.year ==
                                            DateTime.now().year &&
                                        _titleDate.month ==
                                            DateTime.now().month) {
                                      _titleDate = DateTime.now();
                                    }

                                    _selectedValue = _titleDate;
                                    _controller.setDateAndAnimate(_titleDate);
                                  });
                                } else if (_selectedMonth == 1) {
                                  setState(() {
                                    _selectedMonth = 12;
                                    final year = _titleDate.year - 1;
                                    _titleDate =
                                        DateTime(year, _selectedMonth, 1);

                                    _selectedValue = _titleDate;
                                    _controller.setDateAndAnimate(_titleDate);
                                  });
                                } else {
                                  setState(() {
                                    _selectedMonth = 1;
                                    final year = _titleDate.year - 1;
                                    _titleDate =
                                        DateTime(year, _selectedMonth, 1);

                                    _selectedValue = _titleDate;
                                    _controller.setDateAndAnimate(_titleDate);
                                  });
                                }
                                if ((_titleDate.month == DateTime.now().month &&
                                    _titleDate.year == DateTime.now().year)) {
                                  setState(() {
                                    _canGoBack = false;
                                  });
                                  return;
                                }
                              },
                              icon: Icon(Icons.chevron_left),
                              iconSize: 24,
                              splashRadius: 18,
                              color: !_canGoBack
                                  ? widget.unselectedColor
                                  : widget.titleStyle != null
                                      ? widget.titleStyle!.color
                                      : Colors.white,
                            ),
                            IconButton(
                              onPressed: () {
                                final tempDate = DateTime(
                                    _titleDate.year, _selectedMonth + 1, 1);
                                if (tempDate.isAfter(_lastDate)) {
                                  return;
                                }
                                if (_selectedMonth < 12) {
                                  setState(() {
                                    _selectedMonth++;

                                    _titleDate = DateTime(
                                        _titleDate.year, _selectedMonth, 1);

                                    _selectedValue = _titleDate;
                                    _controller.setDateAndAnimate(_titleDate);
                                  });
                                } else {
                                  setState(() {
                                    _selectedMonth = 1;
                                    final year = _titleDate.year + 1;
                                    _titleDate =
                                        DateTime(year, _selectedMonth, 1);

                                    _selectedValue = _titleDate;
                                    _controller.setDateAndAnimate(_titleDate);
                                  });
                                }

                                if ((_titleDate.isAfter(DateTime.now()))) {
                                  setState(() {
                                    _canGoBack = true;
                                  });
                                  return;
                                }
                              },
                              icon: Icon(Icons.chevron_right),
                              iconSize: 24,
                              splashRadius: 18,
                              color: DateTime(_titleDate.year,
                                          _selectedMonth + 1, 1)
                                      .isAfter(_lastDate)
                                  ? widget.unselectedColor
                                  : widget.titleStyle != null
                                      ? widget.titleStyle!.color
                                      : Colors.white,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 4),
                        child: DatePicker(
                          widget.startDate ?? DateTime.now(),
                          width: widget.itemWidth ?? 48,
                          height: widget.itemHeight ?? 55,
                          controller: _controller,
                          initialSelectedDate: DateTime.now(),
                          daysCount: widget.daysCount,
                          showMonth: widget.showMonth,
                          showEventsIndicators: widget.showIndicators,
                          selectionColor: widget.selectionColor,
                          unSelectedColor: widget.unselectedColor,
                          type: widget.type ?? DateWidgetType.circle_date,
                          selectedTextColor: widget.selectedTextColor,
                          monthTextStyle: widget.monthTextStyle ??
                              TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: widget.unselectedColor),
                          dateTextStyle: widget.dateTextStyle ??
                              TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white),
                          dayTextStyle: widget.dayTextStyle ??
                              TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: widget.unselectedColor),
                          //deactivatedColor: Colors.red,
                          events: widget.events,
                          onDateChange: (date) {
                            // New date selected
                            setState(() {
                              _selectedValue = date;
                              _titleDate = date;
                              widget.onDateChanged(date);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: EventsListView(
                  onEventTap: widget.onEventTap,
                  backgroundColor: widget.bodyBackgroundColor,
                  listPadding: widget.bodyPadding,
                  timeHeadingStyle: widget.timeSeparatorStyle,
                  events: widget.events
                      .where((element) => ((element.startDateTime
                              .compareDates(_selectedValue)) ||
                          (element.endDateTime.compareDates(_selectedValue))))
                      .toList()
                    ..sort((a, b) {
                      return a.endDateTime.compareTo(b.endDateTime);
                    }),
                )),
              ],
            ),
          ),
          Visibility(
            visible: widget.showAddEventBtn,
            child: Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton(
                  mini: false,
                  backgroundColor:
                      widget.addEventButtonColor ?? widget.selectionColor,
                  child: Icon(
                    widget.addEventIcon ?? Icons.add_task,
                    color: widget.addEventIconColor ?? widget.selectedTextColor,
                  ),
                  onPressed: () => widget.onAddEvent(_selectedValue) ?? () {},
                )),
          )
        ],
      ),
    );
  }
}
