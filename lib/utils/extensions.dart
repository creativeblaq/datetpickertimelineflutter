import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = Set();
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}

extension DateExtendion on DateTime {
  bool compareDates(DateTime other) {
    return (this.day == other.day &&
        this.month == other.month &&
        this.year == other.year);
  }

  String weekdayName({String? locale}) {
    return new DateFormat("E", locale).format(this);
  }

  String formatDateToDDMY({String? locale}) {
    return new DateFormat('EEE, d MMM yyyy', locale).format(this);
  }

  String formatDateToDDMYTT({String? locale}) {
    return new DateFormat('d MMM yyyy hh:mm aaa', locale).format(this);
  }

  String formatDateToTimeOnly({String? locale}) {
    return new DateFormat('hh:mm aaa', locale).format(this);
  }
}

extension StringExtension on String {
  Color? toColor() {
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 3) {
      var car = hexColor.characters.map((e) => e + e).toList().toString();
      hexColor = "FF" +
          car
              .substring(1, car.length - 1)
              .replaceAll(',', '')
              .replaceAll(' ', '');
      //printInfo(info: hexColor);
    }

    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
      //printInfo(info: hexColor);
    }
    if (hexColor.length == 8) {
      return Color(int.parse(hexColor, radix: 16));
    }
  }
}

extension ColorExtensions on Color {
  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) {
    String value = '';
    value = '${leadingHashSign ? '#' : ''}'
        '${alpha.toRadixString(16).padLeft(2, '0')}'
        '${red.toRadixString(16).padLeft(2, '0')}'
        '${green.toRadixString(16).padLeft(2, '0')}'
        '${blue.toRadixString(16).padLeft(2, '0')}';

    var splitVal = value.split('#')[1];
    if (splitVal.length >= 8) {
      if (splitVal.toLowerCase().startsWith('ff')) {
        return "#" + splitVal.substring(2);
      }
    }
    return value;
  }

  Color getTextColor(
      [Color darkColor = Colors.black, Color lightColor = Colors.white]) {
    return computeLuminance() < 0.5 ? lightColor : darkColor;
  }

  Color changeColorLightness(double lightness) =>
      HSLColor.fromColor(this).withLightness(lightness).toColor();
}
