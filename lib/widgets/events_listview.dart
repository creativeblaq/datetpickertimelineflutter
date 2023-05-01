import 'package:date_picker_timeline/models/event_model.dart';
import 'package:date_picker_timeline/utils/custom_rect_tween.dart';
import 'package:date_picker_timeline/utils/utils.dart';
import 'package:flutter/material.dart';

class EventsListView extends StatelessWidget {
  EventsListView(
      {Key? key,
      required this.events,
      this.listPadding,
      required this.backgroundColor,
      this.timeHeadingStyle,
      required this.onEventTap})
      : super(key: key);
  final List<EventModel> events;
  final Function(EventModel event, int index) onEventTap;

  final EdgeInsets? listPadding;
  final Color? backgroundColor;
  TextStyle? timeHeadingStyle;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (timeHeadingStyle == null) {
      timeHeadingStyle = TextStyle(fontSize: 12, color: Colors.grey[500]);
    }
    return Container(
      width: size.width,
      child: ListView.builder(
          itemCount: 24,
          clipBehavior: Clip.hardEdge,
          padding: listPadding ??
              const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 100),
          itemBuilder: (context, index) {
            int hour = index;
            int minute = 0;
            String suffix = 'AM';
            if (index > 11) {
              hour = index - 12;
              suffix = 'PM';
            }
            if (hour == 0) {
              hour = 12;
            }

            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text("$hour:${minute}0 $suffix",
                                style: timeHeadingStyle)),
                        Expanded(
                            flex: 9,
                            child: Divider(
                              color: timeHeadingStyle != null
                                  ? timeHeadingStyle!.color
                                  : backgroundColor != null
                                      ? backgroundColor!.getTextColor(
                                          Colors.black, Colors.white)
                                      : Colors.grey[500],
                            )),
                      ],
                    ),
                  ),
                  ...events
                      .asMap()
                      .map((i, element) {
                        bool show = (element.startDateTime.hour == index);
                        return MapEntry(
                            i,
                            //e.startDateTime.hour < index;
                            show
                                ? Hero(
                                    tag: events[i].toString(),
                                    createRectTween: (begin, end) =>
                                        CustomRectTween(
                                            begin: begin!, end: end!),
                                    child: Material(
                                      elevation: 0,
                                      color: Colors.transparent,
                                      child: Container(
                                        width: size.width,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: SizedBox(),
                                            ),
                                            Expanded(
                                              flex: 9,
                                              child: InkWell(
                                                onTap: () =>
                                                    onEventTap(events[i], i),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    Card(
                                                      color: element.eventColor,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12)),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 2,
                                                              child:
                                                                  CircleAvatar(
                                                                maxRadius: 30,
                                                                child: Icon(
                                                                  element.icon,
                                                                  color: element
                                                                      .eventColor,
                                                                ),
                                                                backgroundColor:
                                                                    element
                                                                        .eventColor
                                                                        .getTextColor(),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 8,
                                                            ),
                                                            Expanded(
                                                              flex: 9,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      element
                                                                          .title,
                                                                      style: getTextStyle(
                                                                          element
                                                                              .eventColor,
                                                                          14,
                                                                          FontWeight
                                                                              .bold)),
                                                                  SizedBox(
                                                                    height: 2,
                                                                  ),
                                                                  iconLabelWidget(
                                                                      Icons
                                                                          .access_time,
                                                                      getFormatedTime(
                                                                          element
                                                                              .startDateTime,
                                                                          element
                                                                              .endDateTime),
                                                                      element
                                                                          .eventColor,
                                                                      12),
                                                                  SizedBox(
                                                                    height: 2,
                                                                  ),
                                                                  iconLabelWidget(
                                                                      Icons
                                                                          .calendar_month,
                                                                      getFormatedDates(
                                                                          element
                                                                              .startDateTime,
                                                                          element
                                                                              .endDateTime),
                                                                      element
                                                                          .eventColor,
                                                                      12),
                                                                  SizedBox(
                                                                    height: 2,
                                                                  ),
                                                                  iconLabelWidget(
                                                                      Icons
                                                                          .label_outline,
                                                                      element
                                                                          .eventType,
                                                                      element
                                                                          .eventColor,
                                                                      12),
                                                                  Visibility(
                                                                      visible: element
                                                                          .description
                                                                          .isNotEmpty,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          SizedBox(
                                                                            height:
                                                                                6,
                                                                          ),
                                                                          Text(
                                                                            element.description,
                                                                            style: getTextStyle(
                                                                                element.eventColor,
                                                                                12,
                                                                                FontWeight.normal),
                                                                            maxLines:
                                                                                3,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        ],
                                                                      )),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink());
                      })
                      .values
                      .toList()
                ]);
          }),
    );
  }
}
