import 'package:date_picker_timeline/models/models.dart';
import 'package:date_picker_timeline/utils/custom_rect_tween.dart';
import 'package:date_picker_timeline/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class EventActionView extends StatefulWidget {
  final TextStyle labelStyle;
  final TextStyle? dateTextStyle;

  final TextStyle hintStyle;
  final TextStyle? errorStyle;

  final TextStyle? dropdownTextStyle;

  final TextStyle defaultTextStyle;
  final List<Color> colors;

  final EventModel? event;
  //final Color? backgroundColor;
  //final Color? disabledColor;
  //final Color? enabledColor;

  final List<String> eventTypes;
  final List<String> repeatTypes;
  final List<String> eventStates;

  final EdgeInsets? insetPadding;

  final Function(EventModel event) onCreateEvent;

  EventActionView(
      {Key? key,
      this.event,
      //this.backgroundColor,
      required this.labelStyle,
      required this.hintStyle,
      this.errorStyle,
      this.colors = const [
        Colors.redAccent,
        Colors.orangeAccent,
        Colors.greenAccent,
        Colors.blueAccent
      ],
      this.dropdownTextStyle,
      required this.eventTypes,
      required this.defaultTextStyle,
      this.dateTextStyle,
      required this.repeatTypes,
      required this.eventStates,
      this.insetPadding,
      required this.onCreateEvent})
      : super(key: key);

  @override
  State<EventActionView> createState() => _EventActionViewState();
}

class _EventActionViewState extends State<EventActionView> {
  final _formKey = GlobalKey<FormBuilderState>();

  void _onChanged(dynamic val) => debugPrint(val.toString());

  bool autoValidate = true;

  IconData? _icon = Icons.event;
  late Color _eventColor;
  List<DateTime>? dateTimeList;

  _pickIcon() async {
    _icon = await FlutterIconPicker.showIconPicker(context,
        iconPackModes: [IconPack.material]);
    setState(() {});

    debugPrint('Picked Icon:  $_icon');
  }

  Future<List<DateTime>?> _pickDates() async {
    return await showOmniDateTimeRangePicker(
      context: context,
      primaryColor: _eventColor.getTextColor(
          _eventColor.changeColorLightness(0.3),
          _eventColor.changeColorLightness(0.1)),
      backgroundColor: _eventColor,
      calendarTextColor: _eventColor.getTextColor(),
      tabTextColor: _eventColor.getTextColor(),
      unselectedTabBackgroundColor: _eventColor.withOpacity(0.7),
      buttonTextColor: _eventColor.getTextColor(),
      timeSpinnerTextStyle:
          TextStyle(color: _eventColor.getTextColor(), fontSize: 14),
      timeSpinnerHighlightedTextStyle:
          TextStyle(color: _eventColor.getTextColor(), fontSize: 24),
      is24HourMode: false,
      isShowSeconds: false,
      startInitialDate: DateTime.now(),
      startFirstDate: DateTime.now(),
      startLastDate: DateTime.now().add(
        const Duration(days: 356 * 50),
      ),
      endInitialDate: DateTime.now(),
      endFirstDate: DateTime.now(),
      endLastDate: DateTime.now().add(
        const Duration(days: 356 * 50),
      ),
      borderRadius: const Radius.circular(24),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _eventColor = widget.colors[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Hero(
      tag: widget.event == null ? "ADD EVENT" : "EDIT EVENT",
      createRectTween: (begin, end) =>
          CustomRectTween(begin: begin!, end: end!),
      child: Dialog(
          insetPadding: widget.insetPadding ??
              EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            constraints: BoxConstraints(
                maxHeight: size.height * 0.9, minHeight: size.height * 0.5),
            width: size.width,
            decoration: BoxDecoration(
              color: _eventColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                    ),
                    splashRadius: 18,
                    iconSize: 24,
                    color: _eventColor.getTextColor(),
                  ),
                ),
                Divider(
                  indent: 8,
                  endIndent: 8,
                  color: _eventColor.getTextColor().withOpacity(0.7),
                ),
                Flexible(
                  flex: 12,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        FormBuilder(
                          key: _formKey,
                          // enabled: false,
                          autovalidateMode: AutovalidateMode.disabled,
                          skipDisabled: true,
                          child: Column(
                            children: <Widget>[
                              const SizedBox(height: 15),
                              //TODO: ICON PICKER
                              SizedBox(
                                height: 16,
                              ),
                              InkWell(
                                onTap: () {
                                  _pickIcon();
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Pick an icon for your event.',
                                        style: widget.hintStyle.copyWith(
                                            color: _eventColor
                                                .getTextColor()
                                                .withOpacity(0.7)),
                                        textAlign: TextAlign.center),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    CircleAvatar(
                                      radius: 40,
                                      child: Icon(
                                        _icon ?? Icons.event,
                                        color: _eventColor,
                                        size: 36,
                                      ),
                                      backgroundColor:
                                          _eventColor.getTextColor(),
                                    ),
                                  ],
                                ),
                              ),

                              //TODO: Title text field | Color picker
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: FormBuilderTextField(
                                      autovalidateMode: AutovalidateMode.always,
                                      name: 'title',
                                      decoration: InputDecoration(
                                        labelText: 'Title',
                                        labelStyle: widget.labelStyle.copyWith(
                                            color: _eventColor.getTextColor()),
                                        hintStyle: widget.hintStyle.copyWith(
                                            color: _eventColor
                                                .getTextColor()
                                                .withOpacity(0.7)),
                                        hintText: 'Collection day',
                                        errorStyle: widget.errorStyle,
                                        counter: SizedBox.shrink(),
                                      ),
                                      maxLength: 81,
                                      style: widget.defaultTextStyle.copyWith(
                                          color: _eventColor.getTextColor()),
                                      maxLengthEnforcement:
                                          MaxLengthEnforcement.enforced,
                                      onChanged: (val) {},
                                      // valueTransformer: (text) => num.tryParse(text),
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(),
                                        FormBuilderValidators.maxLength(80),
                                      ]),
                                      // initialValue: '12',
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: FormBuilderDropdown<String>(
                                      // autovalidate: true,
                                      name: 'color',
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                      // initialValue: 'Male',
                                      initialValue: widget.colors[0].toHex(),
                                      isExpanded: true,

                                      //allowClear: false,
                                      icon: SizedBox.shrink(),
                                      iconSize: 0,
                                      dropdownColor: _eventColor.getTextColor(),
                                      validator: FormBuilderValidators.compose(
                                          [FormBuilderValidators.required()]),
                                      items: widget.colors
                                          .map((color) => DropdownMenuItem(
                                                alignment:
                                                    AlignmentDirectional.center,
                                                value: color.toHex(),
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                  //alignment: Alignment.centerLeft,
                                                  decoration: BoxDecoration(
                                                    color: color,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        width: 2,
                                                        color: _eventColor
                                                            .getTextColor()),
                                                  ),
                                                ),
                                              ))
                                          .toList(),
                                      onChanged: (val) {
                                        setState(() {
                                          if (val != null) {
                                            _eventColor = val.toColor()!;
                                          }
                                        });
                                      },
                                      valueTransformer: (val) =>
                                          val?.toString(),
                                    ),
                                  ),
                                ],
                              ),

                              //TODO: DESC TEXTFIELD
                              FormBuilderTextField(
                                autovalidateMode: AutovalidateMode.always,
                                name: 'description',
                                decoration: InputDecoration(
                                  labelText: 'Description',
                                  labelStyle: widget.labelStyle.copyWith(
                                      color: _eventColor.getTextColor()),
                                  hintStyle: widget.hintStyle.copyWith(
                                      color: _eventColor
                                          .getTextColor()
                                          .withOpacity(0.7)),
                                  hintText: 'Do this today',
                                  errorStyle: widget.errorStyle,
                                  counter: SizedBox.shrink(),
                                ),
                                maxLength: 151,
                                style: widget.defaultTextStyle.copyWith(
                                    color: _eventColor.getTextColor()),
                                maxLengthEnforcement:
                                    MaxLengthEnforcement.enforced,
                                onChanged: (val) {},
                                // valueTransformer: (text) => num.tryParse(text),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.maxLength(150),
                                ]),
                                // initialValue: '12',
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.newline,
                              ),

                              //TODO: Read only textField for dates
                              InkWell(
                                onTap: () async {
                                  print("tapped");
                                  final result = await _pickDates();
                                  if (result != null) {
                                    setState(() {
                                      dateTimeList = result;
                                      _formKey.currentState?.fields['dates']
                                          ?.didChange("Start : " +
                                              dateTimeList![0]
                                                  .formatDateToDDMYTT() +
                                              "\n" +
                                              "End   : " +
                                              dateTimeList![1]
                                                  .formatDateToDDMYTT());
                                    });
                                  }
                                },
                                child: FormBuilderTextField(
                                  autovalidateMode: AutovalidateMode.always,
                                  name: 'dates',
                                  decoration: InputDecoration(
                                    labelText: 'Start - End',
                                    labelStyle: widget.labelStyle.copyWith(
                                        color: _eventColor
                                            .getTextColor()
                                            .withOpacity(0.7)),
                                    hintStyle: widget.hintStyle.copyWith(
                                        color: _eventColor
                                            .getTextColor()
                                            .withOpacity(0.7)),
                                    errorStyle: widget.errorStyle,
                                    //border: InputBorder.none,
                                    counter: SizedBox.shrink(),
                                    suffixIcon: Icon(
                                        Icons.calendar_month_outlined,
                                        color: _eventColor.getTextColor()),
                                  ),
                                  initialValue:
                                      DateTime.now().formatDateToDDMYTT(),
                                  //maxLength: 81,
                                  maxLines: null,
                                  maxLengthEnforcement:
                                      MaxLengthEnforcement.enforced,
                                  style: widget.dateTextStyle != null
                                      ? widget.dateTextStyle!.copyWith(
                                          color: _eventColor.getTextColor())
                                      : TextStyle(
                                          fontSize: 14,
                                          height: 1.5,
                                          color: _eventColor.getTextColor()),
                                  readOnly: true,
                                  enabled: false,
                                  onChanged: (val) {},
                                  // valueTransformer: (text) => num.tryParse(text),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.maxLength(80),
                                  ]),
                                  // initialValue: '12',
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.next,
                                ),
                              ),

                              //TODO: Location textfield
                              FormBuilderTextField(
                                autovalidateMode: AutovalidateMode.always,
                                name: 'location',
                                decoration: InputDecoration(
                                  labelText: 'Location',
                                  labelStyle: widget.labelStyle.copyWith(
                                      color: _eventColor
                                          .getTextColor()
                                          .withOpacity(0.7)),
                                  hintStyle: widget.hintStyle.copyWith(
                                      color: _eventColor
                                          .getTextColor()
                                          .withOpacity(0.7)),
                                  hintText:
                                      'Enter a location name or address...',
                                  errorStyle: widget.errorStyle,
                                  //border: InputBorder.none,
                                  suffixIcon: Icon(
                                    Icons.location_pin,
                                    color: _eventColor.getTextColor(),
                                  ),
                                  counter: SizedBox.shrink(),
                                ),
                                //maxLength: 81,
                                style: widget.defaultTextStyle.copyWith(
                                    color: _eventColor.getTextColor()),
                                onChanged: (val) {},
                                // valueTransformer: (text) => num.tryParse(text),
                                validator: FormBuilderValidators.compose([
                                  //FormBuilderValidators.required(),
                                  FormBuilderValidators.maxLength(150),
                                ]),
                                // initialValue: '12',
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                              ),

                              Row(
                                children: [
                                  //TODO: Dropdown Event type
                                  Expanded(
                                    flex: 8,
                                    child: FormBuilderDropdown<String>(
                                      // autovalidate: true,
                                      name: 'type',
                                      decoration: InputDecoration(
                                          labelText: 'Type',
                                          hintText: 'Event Type',
                                          labelStyle: widget.labelStyle
                                              .copyWith(
                                                  color: _eventColor
                                                      .getTextColor()
                                                      .withOpacity(0.7)),
                                          hintStyle: widget.hintStyle.copyWith(
                                              color: _eventColor
                                                  .getTextColor()
                                                  .withOpacity(0.7))),
                                      initialValue: widget.eventTypes.isNotEmpty
                                          ? widget.eventTypes[0]
                                          : null,
                                      //allowClear: false,
                                      icon: Icon(Icons.label,
                                          color: _eventColor.getTextColor()),

                                      style: widget.defaultTextStyle.copyWith(
                                          color: _eventColor.getTextColor()),

                                      dropdownColor: _eventColor,
                                      validator: FormBuilderValidators.compose(
                                          [FormBuilderValidators.required()]),
                                      items: widget.eventTypes
                                          .map((type) => DropdownMenuItem(
                                                alignment:
                                                    AlignmentDirectional.center,
                                                value: type,
                                                child: Text(
                                                  type,
                                                  style:
                                                      widget.dropdownTextStyle,
                                                ),
                                              ))
                                          .toList(),
                                      onChanged: (val) {},
                                      valueTransformer: (val) =>
                                          val?.toString(),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  //TODO: Repeats dropdown
                                  Expanded(
                                    flex: 4,
                                    child: FormBuilderDropdown<String>(
                                      // autovalidate: true,
                                      name: 'repeat',
                                      decoration: InputDecoration(
                                          labelText: 'Repeat',
                                          hintText: 'Repeats',
                                          labelStyle: widget.labelStyle
                                              .copyWith(
                                                  color: _eventColor
                                                      .getTextColor()
                                                      .withOpacity(0.7)),
                                          hintStyle: widget.hintStyle.copyWith(
                                              color: _eventColor
                                                  .getTextColor()
                                                  .withOpacity(0.7))),
                                      initialValue:
                                          widget.repeatTypes.isNotEmpty
                                              ? widget.repeatTypes[0]
                                              : null,
                                      //allowClear: false,
                                      icon: Icon(Icons.repeat_outlined,
                                          color: _eventColor.getTextColor()),
                                      style: widget.defaultTextStyle.copyWith(
                                          color: _eventColor.getTextColor()),
                                      dropdownColor: _eventColor,
                                      validator: FormBuilderValidators.compose(
                                          [FormBuilderValidators.required()]),
                                      items: widget.repeatTypes
                                          .map((type) => DropdownMenuItem(
                                                alignment:
                                                    AlignmentDirectional.center,
                                                value: type,
                                                child: Text(
                                                  type,
                                                  style:
                                                      widget.dropdownTextStyle,
                                                ),
                                              ))
                                          .toList(),
                                      onChanged: (val) {},
                                      valueTransformer: (val) =>
                                          val?.toString(),
                                    ),
                                  ),
                                ],
                              ),

                              //TODO: State dropdown

                              FormBuilderDropdown<String>(
                                // autovalidate: true,
                                name: 'state',
                                decoration: InputDecoration(
                                    labelText: 'State',
                                    hintText: 'Event State',
                                    labelStyle: widget.labelStyle.copyWith(
                                        color: _eventColor
                                            .getTextColor()
                                            .withOpacity(0.7)),
                                    hintStyle: widget.hintStyle.copyWith(
                                        color: _eventColor
                                            .getTextColor()
                                            .withOpacity(0.7))),
                                initialValue: widget.eventStates.isNotEmpty
                                    ? widget.eventStates[0]
                                    : null,
                                //allowClear: false,
                                icon: Icon(
                                  Icons.style,
                                  color: _eventColor.getTextColor(),
                                ),

                                style: widget.dropdownTextStyle != null
                                    ? widget.dropdownTextStyle!
                                        .copyWith(color: _eventColor)
                                    : widget.defaultTextStyle.copyWith(
                                        color: _eventColor.getTextColor()),

                                dropdownColor: _eventColor,
                                isExpanded: false,
                                isDense: false,
                                validator: FormBuilderValidators.compose(
                                    [FormBuilderValidators.required()]),
                                items: widget.eventStates
                                    .map((type) => DropdownMenuItem(
                                          alignment:
                                              AlignmentDirectional.center,
                                          value: type,
                                          child: Container(
                                            child: Text(
                                              type,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (val) {},
                                valueTransformer: (val) => val?.toString(),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Container(
                    height: 40,
                    margin: EdgeInsets.only(
                        top: 16.0, left: 12, right: 12, bottom: 8),
                    decoration: BoxDecoration(
                        color: _eventColor.getTextColor(),
                        borderRadius: BorderRadius.circular(24)),
                    child: InkWell(
                      onTap: () async {
                        //onMarkComplete(event);
                        //Navigator.of(context).pop();
                        if (_formKey.currentState == null) {
                          return await showErrorDialog(
                              context,
                              "Please enter all required fields",
                              widget.insetPadding ?? EdgeInsets.all(10));
                          //return;
                        }

                        if (_formKey.currentState!.saveAndValidate()) {
                          String title = _formKey.currentState?.value['title'];
                          String desc =
                              _formKey.currentState?.value['description'] ?? "";
                          String location =
                              _formKey.currentState?.value['location'] ?? "";
                          String type = _formKey.currentState?.value['type'];
                          String repeat =
                              _formKey.currentState?.value['repeat'];
                          String state = _formKey.currentState?.value['state'];

                          if (dateTimeList == null || dateTimeList!.isEmpty) {
                            return await showErrorDialog(
                                context,
                                "Please select start and end dates",
                                widget.insetPadding ?? EdgeInsets.all(10));
                          }

                          final EventModel event = EventModel(
                              title: title,
                              description: desc,
                              location: location,
                              startDateTime: dateTimeList![0],
                              endDateTime: dateTimeList![1],
                              icon: _icon ?? Icons.event,
                              eventType: type,
                              eventState: eventStateFromString(state),
                              repeats: eventRepeatFromString(repeat),
                              eventColor: _eventColor);

                          //TODO: Validate and create the event Model
                          print(event.toString());
                          widget.onCreateEvent(event);
                          Navigator.of(context).pop();
                        } else {
                          return await showErrorDialog(
                              context,
                              "Please enter all required fields",
                              widget.insetPadding ?? EdgeInsets.all(10));
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.upload,
                            color: _eventColor,
                            size: 16,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Submit",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: _eventColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
