import 'package:flutter/material.dart';
import 'package:freshology/constants/styles.dart';
import 'package:freshology/provider/orderProvider.dart';
import 'package:provider/provider.dart';

class TimeSlotPicker extends StatefulWidget {
  final DateTime deliveryDay; // Day selected for delivery
  final int start; // Start time in firebase
  final int end; // End time in firebase

  TimeSlotPicker({
    @required this.deliveryDay,
    @required this.end,
    @required this.start,
  });

  @override
  _TimeSlotPickerState createState() => _TimeSlotPickerState();
}

class _TimeSlotPickerState extends State<TimeSlotPicker> {
  List<Slots> timeSlotsList = [
    Slots(
        displayText: '9 AM - 12 PM',
        isSelected: false,
        unavailable: false,
        value: TimeOfDay(hour: 9, minute: 0)),
    Slots(
        displayText: '2 PM - 5 PM',
        isSelected: false,
        unavailable: false,
        value: TimeOfDay(hour: 14, minute: 0)),
    Slots(
        displayText: '6 PM - 9 PM',
        isSelected: false,
        unavailable: false,
        value: TimeOfDay(hour: 18, minute: 0)),
  ];

  @override
  Widget build(BuildContext context) {
    DateTime _deliveryDay = widget.deliveryDay;
    final orderProvider = Provider.of<OrderProvider>(context);
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 15,
      ),
      height: 40,
      child: ListView.builder(
        itemBuilder: (context, index) {
          var timeSlot = timeSlotsList[index];
          if (_deliveryDay.day == DateTime.now().day) {
            TimeOfDay now = TimeOfDay.now();
            int nowInMinutes = now.hour * 60 + now.minute + 60;
            int timeSlotValueInMinutes =
                timeSlot.value.hour * 60 + timeSlot.value.minute;
            if (timeSlotValueInMinutes < nowInMinutes) {
              timeSlot.unavailable = true;
            }
          } else {
            timeSlot.unavailable = false;
          }
          if (_deliveryDay.day == DateTime.now().day) {
            if (timeSlot.value.hour <= widget.start) {
              timeSlot.unavailable = true;
            }
            if (timeSlot.value.hour >= widget.end) {
              timeSlot.unavailable = true;
            }
          }
          return InkWell(
            onTap: () {
              if (timeSlot.unavailable == false) {
                timeSlotsList.forEach((element) {
                  element.isSelected = false;
                });
                orderProvider.deliveryTime = timeSlot.value;
                orderProvider.updateTime();
                setState(() {
                  timeSlot.isSelected = true;
                });
              }
            },
            child: timeBox(
              timeSlot.displayText,
              timeSlot.isSelected,
              timeSlot.unavailable,
              timeSlot.value,
            ),
          );
        },
        itemCount: timeSlotsList.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

Widget timeBox(
    String time, bool selected, bool unavailable, TimeOfDay timeVal) {
  return Container(
    margin: EdgeInsets.symmetric(
      horizontal: 7,
      vertical: 0,
    ),
    padding: EdgeInsets.symmetric(
      vertical: 5,
      horizontal: 15,
    ),
    child: Center(
      child: Text(
        time,
        style: TextStyle(
          color: selected == true ? Colors.white : Colors.black,
        ),
      ),
    ),
    decoration: BoxDecoration(
      color: unavailable == true
          ? Colors.grey[400]
          : selected == true
              ? kDarkGreen
              : Colors.white,
      border: Border.all(
        width: 1,
        color: Colors.black,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
  );
}

class Slots {
  String displayText;
  bool unavailable;
  bool isSelected;
  TimeOfDay value;

  Slots({
    this.displayText,
    this.isSelected,
    this.unavailable,
    this.value,
  });
}
