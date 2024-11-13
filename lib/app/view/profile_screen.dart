import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tasks/app/model/task_model.dart';
import 'package:tasks/app/services/send_tasks.dart';
import 'package:tasks/app/utils/helper/database_helper.dart';
import 'package:tasks/app/utils/styles/constant_color.dart';
import 'package:tasks/app/utils/widgets/confirmation_alert.dart';
import 'package:tasks/app/utils/widgets/custom_list_title.dart';
import 'package:tasks/app/utils/widgets/success_alert.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  List<Task> _tasks = [];
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _loadTasks();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  Future<void> _loadTasks() async {
    List<Task> tasks = await DatabaseHelper().getTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _sendTasks() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult[0] == ConnectivityResult.none) {
      _showSnackBar(
          'No internet connection. Please check your connection and try again.');
    } else {
      final confirmed = await _showConfirmationDialog();
      if (confirmed) {
        final success = await _apiService.sendTasksToApi(_tasks);
        if (mounted) {
          if (success) {
            _showSuccessDialog();
          } else {
            _showSnackBar('Failed to send tasks. Please try again later.');
          }
        }
      }
    }
  }

  Future<bool> _showConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => const ConfirmationAlert(),
        ) ??
        false;
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const SuccessAlert(),
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(3.0),
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage("assets/logo.png"),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "AZUR TECH RESEARCH",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kSecondaryColor,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              Divider(
                height: 20,
                thickness: 2,
                indent: 20,
                endIndent: 20,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(height: 20),
              CustomListTitle(
                title: "Personal Information",
                icon: Icons.person,
                onTap: () {},
              ),
              const SizedBox(height: 20),
              CustomListTitle(
                title: "Synchronization",
                icon: Icons.sync_sharp,
                onTap: () => _sendTasks(),
              ),
              const SizedBox(height: 20),
              CustomListTitle(
                trailing: false,
                title: "Logout",
                icon: Icons.logout,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
