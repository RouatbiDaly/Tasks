import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tasks/app/model/task_model.dart';
import 'package:tasks/app/utils/helper/database_helper.dart';
import 'package:tasks/app/utils/widgets/calendar_widget.dart';
import 'package:tasks/app/utils/widgets/custom_appbar.dart';
import 'package:tasks/app/utils/widgets/custom_floating_button.dart';
import 'package:tasks/app/utils/widgets/empty_widget.dart';
import 'package:tasks/app/utils/widgets/task_title.dart';
import 'package:tasks/app/view/add_task_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final ValueNotifier<List<Task>> _selectedEvents;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isLoading = true;

  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier([]);
    _loadTasksForSelectedDay(_selectedDay!);
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  Future<void> _loadTasksForSelectedDay(DateTime day) async {
    setState(() {
      _isLoading = true;
    });
    final tasks = await _dbHelper.getTasksForDay(day);
    _selectedEvents.value = tasks;
    setState(() {
      _isLoading = false;
    });
  }

  Future<List<Task>> _getAllTasks() async {
    return await _dbHelper.getTasks();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _loadTasksForSelectedDay(selectedDay);
    }
  }

  void _navigateToAddTaskScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTaskScreen(),
      ),
    ).then((_) {
      setState(() {});
      _loadTasksForSelectedDay(_focusedDay);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: const CustomAppBar(),
          body: TabBarView(
            children: [
              //! Monthly view
              Column(
                children: [
                  CalendarWidget(
                    focusedDay: _focusedDay,
                    onDaySelected: _onDaySelected,
                    selectedDay: _selectedDay,
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: ValueListenableBuilder<List<Task>>(
                      valueListenable: _selectedEvents,
                      builder: (context, value, _) {
                        if (_isLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (value.isEmpty) {
                          return const EmptyWidget();
                        }

                        return ListView.builder(
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            return TaskTile(task: value[index]);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              //! Today view
              Stack(
                children: [
                  FutureBuilder<List<Task>>(
                    future: _getAllTasks(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const EmptyWidget();
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return TaskTile(task: snapshot.data![index]);
                        },
                      );
                    },
                  ),
                  CustomFloatingButton(onPressed: _navigateToAddTaskScreen),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
