import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tasks/app/model/task_model.dart';

class ApiService {
  final String apiUrl = 'https://6731ee4f7aaf2a9aff12c577.mockapi.io/tasks';

  Future<bool> sendTasksToApi(List<Task> tasks) async {
    try {
      List<Map<String, dynamic>> taskData = tasks.map((task) => task.toJson()).toList();

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(taskData),
      );

      if (response.statusCode == 201) {
        print('Tasks successfully sent!');
        return true;
      } else {
        print('Failed to send tasks. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error occurred while sending tasks: $e');
      return false;
    }
  }
}