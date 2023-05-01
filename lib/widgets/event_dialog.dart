import 'package:date_picker_timeline/models/models.dart';
import 'package:date_picker_timeline/utils/custom_rect_tween.dart';
import 'package:date_picker_timeline/utils/utils.dart';
import 'package:flutter/material.dart';

class EventDialog extends StatelessWidget {
  EventDialog(
      {Key? key,
      required this.event,
      required this.onMarkComplete,
      required this.onEdit,
      required this.onDelete, this.showEditButton = false})
      : super(key: key);

  final EventModel event;
  final Function(EventModel event) onMarkComplete;
  final Function(EventModel event) onEdit;
  final Function(EventModel event) onDelete;
  final bool showEditButton;

  show(cxt) {
    showDialog(
        context: cxt,
        builder: (builderCxt) {
          return build(builderCxt);
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Hero(
      tag: event.toString(),
      createRectTween: (begin, end) =>
          CustomRectTween(begin: begin!, end: end!),
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          constraints: BoxConstraints(
              maxHeight: size.height * 0.8, minHeight: size.height * 0.3),
          width: size.width,
          decoration: BoxDecoration(
            color: event.eventColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Flexible(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                    ),
                    splashRadius: 18,
                    color: event.eventColor
                        .getTextColor(Colors.black, Colors.white),
                  ),
                  //Spacer(),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Visibility(
                          visible: showEditButton,
                          child: IconButton(
                            onPressed: () {
                              onEdit(event);
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.edit,
                            ),
                            splashRadius: 18,
                            color: event.eventColor.getTextColor(),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            onDelete(event);
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.delete,
                          ),
                          splashRadius: 18,
                          color: event.eventColor.getTextColor(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Divider(
              indent: 8,
              endIndent: 8,
              color: event.eventColor
                  .getTextColor(Colors.black, Colors.white)
                  .withOpacity(0.5),
            ),
            Flexible(
              flex: 12,
              child: ListView(
                padding: EdgeInsets.only(left: 8, right: 8),
                shrinkWrap: true,
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  CircleAvatar(
                    radius: 40,
                    child: Icon(
                      event.icon,
                      color: event.eventColor,
                      size: 36,
                    ),
                    backgroundColor: event.eventColor.getTextColor(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(event.title,
                      style: getTextStyle(
                        event.eventColor,
                        20,
                        FontWeight.bold,
                      ),
                      textAlign: TextAlign.center),
                  SizedBox(
                    height: 4,
                  ),
                  Visibility(
                    visible: event.description.isNotEmpty,
                    child: Text(
                      event.description,
                      style:
                          getTextStyle(event.eventColor, 14, FontWeight.normal),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: iconLabelWidget(
                                  Icons.calendar_today,
                                  'Start: ${event.startDateTime.formatDateToDDMY()}',
                                  event.eventColor,
                                  10),
                            ),
                            Flexible(
                              child: iconLabelWidget(
                                  Icons.access_time,
                                  'Start: ${event.startDateTime.formatDateToTimeOnly()}',
                                  event.eventColor,
                                  10),
                            ),
                          ],
                        ),
                        Container(
                          height: 16,
                          child: VerticalDivider(
                            color: event.eventColor
                                .getTextColor()
                                .withOpacity(0.5),
                            width: 2,
                            thickness: 2,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: iconLabelWidget(
                                  Icons.calendar_today,
                                  'End: ${event.startDateTime.formatDateToDDMY()}',
                                  event.eventColor,
                                  10),
                            ),
                            Flexible(
                              child: iconLabelWidget(
                                  Icons.access_time,
                                  'End: ${event.endDateTime.formatDateToTimeOnly()}',
                                  event.eventColor,
                                  10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Visibility(
                    visible:
                        event.location != null && event.location!.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: iconLabelWidget(Icons.location_pin,
                          event.location ?? "", event.eventColor, 14),
                    ),
                  ),
                  Visibility(
                    visible: event.eventType.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: iconLabelWidget(
                          Icons.label, event.eventType, event.eventColor, 14),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: InkWell(
                onTap: () {
                  onMarkComplete(event);
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 40,
                  //constraints: BoxConstraints(maxHeight: 40),
                  margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                  decoration: BoxDecoration(
                      color: event.eventColor.getTextColor(),
                      borderRadius: BorderRadius.circular(24)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.done_all,
                        color: event.eventColor,
                        size: 16,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Mark as Complete",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: event.eventColor),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
