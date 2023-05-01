import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Serialization/iconDataSerialization.dart';

enum EventRepeats { never, daily, weekly, monthly, yearly }

enum EventReminder { none, onTime, hrBefore, dayBefore, custom }

enum EventReminderAlertType { notification, email }

enum EventState { todo, doing, complete, overdue }

eventRepeatFromString(String event) {
  return EventRepeats.values.firstWhere((element) => element.name == event);
}

eventStateFromString(String event) {
  return EventState.values.firstWhere((element) => element.name == event);
}

eventReminderAlertTypeFromString(String event) {
  return EventReminderAlertType.values
      .firstWhere((element) => element.name == event);
}

eventReminderFromString(String event) {
  return EventReminder.values.firstWhere((element) => element.name == event);
}

class EventModel {
  String? id;
  String title;
  String description;
  DateTime startDateTime;
  DateTime endDateTime;
  String? location;
  EventRepeats repeats;
  EventReminder? reminderTime;
  EventReminderAlertType? reminderAlertType;
  EventState? eventState;
  DateTime? customReminderDate;
  String eventType;
  Color eventColor;
  IconData icon;
  //TODO: Add ICON

  EventModel({
    this.id,
    required this.title,
    this.description = "",
    required this.startDateTime,
    required this.endDateTime,
    this.location,
    this.repeats = EventRepeats.never,
    this.reminderTime,
    this.eventState = EventState.todo,
    this.reminderAlertType,
    this.customReminderDate,
    required this.eventType,
    required this.eventColor,
    this.icon = Icons.event,
  });

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startDateTime,
    DateTime? endDateTime,
    String? location,
    EventRepeats? repeats,
    EventReminder? reminderTime,
    EventState? eventState,
    EventReminderAlertType? reminderAlertType,
    DateTime? customReminderDate,
    String? eventType,
    Color? eventColor,
    IconData? icon,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      location: location ?? this.location,
      repeats: repeats ?? this.repeats,
      reminderTime: reminderTime ?? this.reminderTime,
      eventState: eventState ?? this.eventState,
      reminderAlertType: reminderAlertType ?? this.reminderAlertType,
      customReminderDate: customReminderDate ?? this.customReminderDate,
      eventType: eventType ?? this.eventType,
      eventColor: eventColor ?? this.eventColor,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDateTime': startDateTime.millisecondsSinceEpoch,
      'endDateTime': endDateTime.millisecondsSinceEpoch,
      'location': location,
      'repeats': repeats.name,
      'reminderTime': reminderTime != null ? reminderTime?.name : null,
      'eventState': eventState != null ? eventState?.name : null,
      'reminderAlertType':
          reminderAlertType != null ? reminderAlertType?.name : null,
      'customReminderDate': customReminderDate?.millisecondsSinceEpoch,
      'eventType': eventType,
      'eventColor': eventColor.value,
      'icon': serializeIcon(icon),
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      startDateTime: DateTime.fromMillisecondsSinceEpoch(map['startDateTime']),
      endDateTime: DateTime.fromMillisecondsSinceEpoch(map['endDateTime']),
      location: map['location'],
      repeats: eventRepeatFromString(map['repeats']),
      reminderTime: map['reminderTime'] != null
          ? eventReminderFromString(map['reminderTime'])
          : null,
      eventState: map['eventState'] != null
          ? eventStateFromString(map['eventState'])
          : null,
      reminderAlertType: map['reminderAlertType'] != null
          ? eventReminderAlertTypeFromString(map['reminderAlertType'])
          : null,
      customReminderDate: map['customReminderDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['customReminderDate'])
          : null,
      eventType: map['eventType'] ?? '',
      eventColor: Color(map['eventColor']),
      icon: deserializeIcon(map['icon']) ?? Icons.event,
    );
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) =>
      EventModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EventModel(id: $id,title: $title, description: $description, startDateTime: $startDateTime, endDateTime: $endDateTime, location: $location, repeats: ${repeats.name},eventState: ${eventState?.name}, reminderTime: ${reminderTime?.name}, reminderAlertType: ${reminderAlertType?.name}, customReminderDate: $customReminderDate, eventType: $eventType, eventColor: $eventColor, icon: ${serializeIcon(icon).toString()})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EventModel &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.startDateTime == startDateTime &&
        other.endDateTime == endDateTime &&
        other.location == location &&
        other.repeats == repeats &&
        other.reminderTime == reminderTime &&
        other.eventState == eventState &&
        other.reminderAlertType == reminderAlertType &&
        other.customReminderDate == customReminderDate &&
        other.eventType == eventType &&
        other.eventColor == eventColor &&
        other.icon == icon;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        startDateTime.hashCode ^
        endDateTime.hashCode ^
        location.hashCode ^
        repeats.hashCode ^
        reminderTime.hashCode ^
        eventState.hashCode ^
        reminderAlertType.hashCode ^
        customReminderDate.hashCode ^
        eventType.hashCode ^
        eventColor.hashCode ^
        icon.hashCode;
  }
}
