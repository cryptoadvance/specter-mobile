import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'LightButton.dart';

class DateSelector extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DateSelectorState();
  }
}

class DateSelectorState extends State<DateSelector> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  Widget build(BuildContext context) {
    final kToday = DateTime.now();
    final kFirstDay = DateTime(kToday.year - 10, kToday.month, kToday.day);
    final kLastDay = DateTime(kToday.year, kToday.month, kToday.day);
    
    var tableCalendar = TableCalendar(
      firstDay: kFirstDay,
      lastDay: kLastDay,
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      rangeStartDay: _rangeStart,
      rangeEndDay: _rangeEnd,
      calendarFormat: _calendarFormat,
      rangeSelectionMode: _rangeSelectionMode,
      headerStyle: HeaderStyle(
        formatButtonVisible: false
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Colors.white),
        weekendStyle: TextStyle(color: Colors.white)
      ),
      calendarStyle: CalendarStyle(
        rangeHighlightColor: Color(0xFF6699FF),
        todayDecoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle)
      ),
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            _rangeStart = null; // Important to clean those
            _rangeEnd = null;
            _rangeSelectionMode = RangeSelectionMode.toggledOff;
          });
        }
      },
      onRangeSelected: (start, end, focusedDay) {
        setState(() {
          _selectedDay = null;
          _focusedDay = focusedDay;
          _rangeStart = start;
          _rangeEnd = end;
          _rangeSelectionMode = RangeSelectionMode.toggledOn;
        });
      },
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
    );

    var selectButton = LightButton(
        child: Container(
            width: double.infinity,
            child: Text('Select', textAlign: TextAlign.center, style: TextStyle(color: Colors.white))
        ),
        isInline: true,
        onTap: () {
        }
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        tableCalendar,
        Container(
          margin: EdgeInsets.only(top: 15),
          child: selectButton
        )
      ]
    );
  }
}