/// ***
/// This class consists of the DateWidget that is used in the ListView.builder
///
/// Author: Vivek Kaushik <me@vivekkasuhik.com>
/// github: https://github.com/iamvivekkaushik/
/// ***

import 'package:date_picker_timeline/utils/extensions.dart';
import 'package:date_picker_timeline/gestures/tap.dart';
import 'package:date_picker_timeline/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateWidget extends StatelessWidget {
  final double? width;
  final DateTime date;
  final TextStyle? monthTextStyle, dayTextStyle, dateTextStyle;
  final Color selectionColor;
  final DateSelectionCallback? onDateSelected;
  final String? locale;
  final bool showEventsIndicators;
  final List<Color> eventIndicatorColors;
  final bool showMonth;
  final DateWidgetType type;

  DateWidget({
    required this.date,
    required this.monthTextStyle,
    required this.dayTextStyle,
    required this.dateTextStyle,
    required this.selectionColor,
    this.width,
    this.onDateSelected,
    this.locale,
    required this.showEventsIndicators,
    required this.eventIndicatorColors,
    required this.showMonth,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: width,
        margin: EdgeInsets.all(3.0),
        decoration: type == DateWidgetType.rounded_rect
            ? BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                color: selectionColor,
              )
            : null,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Visibility(
                visible: showMonth,
                child: Text(
                    new DateFormat("MMM", locale)
                        .format(date)
                        .toUpperCase(), // Month
                    style: monthTextStyle),
              ),
              SizedBox(
                height: 2,
              ),
              Visibility(
                visible: type == DateWidgetType.rounded_rect,
                replacement: Container(
                  //padding: EdgeInsets.all(width != null ? width! / 8 : 8),
                  height: dateTextStyle != null
                      ? dateTextStyle!.fontSize! * 2.15
                      : 10,
                  width: dateTextStyle != null
                      ? dateTextStyle!.fontSize! * 2.15
                      : 10,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: selectionColor, shape: BoxShape.circle),
                  child: Text(
                    date.day.toString(), // Date
                    style: dateTextStyle, textAlign: TextAlign.center,
                  ),
                ),
                child: Text(date.day.toString(), // Date
                    style: dateTextStyle),
              ),
              Visibility(
                visible: showEventsIndicators,
                child: Column(
                  children: [
                    SizedBox(
                      height: dateTextStyle!.fontSize! * 0.1,
                    ),
                    Wrap(
                      spacing: 2,
                      runSpacing: 2,
                      clipBehavior: Clip.hardEdge,
                      alignment: WrapAlignment.center,
                      children: [
                        ...eventIndicatorColors.unique().map((e) => Container(
                              height: width != null ? width! * 0.08 : 4,
                              width: width != null ? width! * 0.08 : 4,
                              decoration: BoxDecoration(
                                color: e,
                                shape: BoxShape.circle,
                              ),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: dateTextStyle!.fontSize! * 0.1,
                    ),
                  ],
                ),
              ),
              Text(date.weekdayName(locale: locale), // WeekDay
                  style: dayTextStyle)
            ],
          ),
        ),
      ),
      onTap: () {
        // Check if onDateSelected is not null
        if (onDateSelected != null) {
          // Call the onDateSelected Function
          onDateSelected!(this.date);
        }
      },
    );
  }
}
