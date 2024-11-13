import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tasks/app/model/task_model.dart';

class CalendarWidget extends StatelessWidget {
  DateTime _focusedDay;
  final DateTime? _selectedDay;
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  final Function(DateTime, DateTime)? _onDaySelected;
  CalendarWidget({super.key, required focusedDay, selectedDay, onDaySelected})
      : _focusedDay = focusedDay,
        _selectedDay = selectedDay,
        _onDaySelected = onDaySelected;

  @override
  Widget build(BuildContext context) {
    return TableCalendar<Task>(
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
      firstDay: DateTime.utc(2000, 1, 1),
      lastDay: DateTime.utc(2100, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      calendarFormat: _calendarFormat,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          shape: BoxShape.circle,
        ),
        outsideDaysVisible: false,
        selectedDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
      ),
      onDaySelected: _onDaySelected,
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
    );
  }
}
