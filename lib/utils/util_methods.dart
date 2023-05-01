import 'package:date_picker_timeline/utils/utils.dart';
import 'package:flutter/material.dart';

enum DateWidgetType {
  circle_date,
  rounded_rect,
}

TextStyle getTextStyle(Color eventColor, double size, FontWeight weight) {
  return TextStyle(
    color: eventColor.getTextColor(Colors.black, Colors.white),
    fontSize: size,
    fontWeight: weight,
  );
}

getFormatedTime(
  DateTime startTime,
  DateTime endTime,
) {
  String start = startTime.formatDateToTimeOnly();
  String end = endTime.formatDateToTimeOnly();
  return start + " - " + end;
}

getFormatedDates(
  DateTime startTime,
  DateTime endTime,
) {
  String start = startTime.formatDateToDDMY();
  String end = endTime.formatDateToDDMY();
  return start + " - " + end;
}

Row iconLabelWidget(IconData icon, String label, Color bgColor, double size) {
  return Row(
    children: [
      Row(
        children: [
          Icon(
            icon,
            size: size,
            color: bgColor.getTextColor(Colors.black, Colors.white),
          ),
          SizedBox(
            width: 4,
          ),
          Text(label, style: getTextStyle(bgColor, size, FontWeight.normal)),
        ],
      ),
    ],
  );
}

showCustomDialog(cxt, widget) {
  showDialog(
      context: cxt,
      builder: (builderCxt) {
        return widget;
      });
}
