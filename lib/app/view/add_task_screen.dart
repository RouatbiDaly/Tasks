import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tasks/app/model/task_model.dart';
import 'package:tasks/app/utils/helper/database_helper.dart';
import 'package:tasks/app/utils/widgets/input_filed.dart';
import 'package:tasks/app/utils/helper/notification_helper.dart';
import 'package:tasks/app/utils/widgets/notification_switch.dart';
import 'package:tasks/app/utils/widgets/saved_button.dart';
import 'package:timezone/timezone.dart' as tz;

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool notificationValue = false;

  final DatabaseHelper _dbHelper = DatabaseHelper();
  final _notificationService = NotificationHelper();

  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
    _notificationService.initializeNotification();
  }

  Future<void> _scheduleNotification(Task task) async {
    if (notificationValue && _startTime != null) {
      final DateTime scheduledTime = DateTime(
        task.startTime.year,
        task.startTime.month,
        task.startTime.day,
        _startTime!.hour,
        _startTime!.minute,
      );

      final tz.TZDateTime tzScheduledTime =
          tz.TZDateTime.from(scheduledTime, tz.local);

      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      print('Current time: $now');
      print('Scheduled time: $tzScheduledTime');
      print('Is scheduled time in the future? ${tzScheduledTime.isAfter(now)}');

      if (tzScheduledTime.isAfter(now)) {
        print('Scheduling notification for: $tzScheduledTime');

        await _notificationService.scheduleNotification(
          task.id ?? 0,
          'Task Reminder: ${task.title}',
          task.description,
          tzScheduledTime,
        );
        print('Notification scheduled successfully');
      } else {
        print('Scheduled time is in the past. Notification not scheduled.');
      }
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? _startTime ?? TimeOfDay.now()
          : _endTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> _saveTask() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _startTime == null ||
        _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields.")),
      );
      return;
    }

    // Set currentDate with only the year, month, and day
    DateTime currentDate = DateTime.now();
    currentDate =
        DateTime(currentDate.year, currentDate.month, currentDate.day);

    // Convert TimeOfDay to DateTime
    final DateTime startDateTime = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      _startTime!.hour,
      _startTime!.minute,
    );

    final DateTime endDateTime = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      _endTime!.hour,
      _endTime!.minute,
    );

    final task = Task(
      title: _titleController.text,
      description: _descriptionController.text,
      date: currentDate,
      startTime: startDateTime,
      endTime: endDateTime,
      notification: notificationValue,
    );

    // Insert the task into the database
    final taskId = await _dbHelper.insertTask(task);

    // Update task with ID for notification scheduling
    final savedTask = task.copyWith(id: taskId);

    // Schedule notification if enabled
    if (notificationValue) {
      await _scheduleNotification(savedTask);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Task saved successfully!")),
      );
      Navigator.pop(context);
    }

    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      _startTime = null;
      _endTime = null;
      notificationValue = false;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputField(
                title: "Title",
                hint: "Enter task title",
                controller: _titleController,
              ),
              const SizedBox(height: 10),
              InputField(
                title: "Description",
                hint: "Enter task description",
                maxLines: 3,
                controller: _descriptionController,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: "Start Time",
                      hint: "Select start time",
                      icon: Icons.access_time,
                      displayText:
                          _startTime != null ? _startTime!.format(context) : '',
                      onTap: () => _selectTime(context, true),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InputField(
                      title: "End Time",
                      hint: "Select end time",
                      icon: Icons.access_time,
                      displayText:
                          _endTime != null ? _endTime!.format(context) : '',
                      onTap: () => _selectTime(context, false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              NotificationSwitch(
                onChanged: (value) {
                  setState(() {
                    notificationValue = value;
                  });
                },
                notificationValue: notificationValue,
              ),
              const SizedBox(height: 20),
              SavedButton(onPressed: _saveTask),
            ],
          ),
        ),
      ),
    );
  }
}
