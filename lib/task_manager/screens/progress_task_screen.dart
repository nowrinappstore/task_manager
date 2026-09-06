import 'package:flutter/material.dart';
import 'package:task_manager/task_manager/models/task_status_count_model.dart';
import 'package:task_manager/task_manager/screens/add_task_screen.dart';
import 'package:task_manager/task_manager/service/api_caller.dart';
import 'package:task_manager/task_manager/utils/urls.dart';

import '../models/api_response.dart';
import '../models/task_model.dart';
import '../widgets/task_card.dart';
import '../widgets/task_card_Count.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  List<TaskStatusCountModel> taskCountByStatus = [];

  List<TaskModel> taskList = [];

  String _currentStatus = 'Progress';
  bool _isLoadingTasks = false;

  @override
  void initState() {
    super.initState();

    getAllTaskCount();
    getTask(_currentStatus);
  }

  // ================= GET TASK BY STATUS =================

  Future<void> getTask(String status) async {
    if (mounted) {
      setState(() {
        _isLoadingTasks = true;
        _currentStatus = status;
      });
    }

    final ApiResponse response = await ApiCaller.getRequest(
      url: TMUrls.listTaskByStatus,
    );

    if (!mounted) return;

    if (response.isSuccess) {
      final List<dynamic> data = response.responseData['data'] ?? [];

      final List<TaskModel> tList = data
          .whereType<Map<String, dynamic>>()
          .map((jsonData) => TaskModel.fromJson(jsonData))
          .toList();

      setState(() {
        taskList = tList;
        _isLoadingTasks = false;
      });
    } else {
      setState(() {
        _isLoadingTasks = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.errorMessage ?? 'Failed to load tasks'),
        ),
      );
    }
  }

  // ================= GET TASK COUNT =================

  Future<void> getAllTaskCount() async {
    final ApiResponse response = await ApiCaller.getRequest(
      url: TMUrls.taskStatusCountURL,
    );

    if (!mounted) return;

    if (response.isSuccess) {
      final List<dynamic> data = response.responseData['data'] ?? [];

      final List<TaskStatusCountModel> taskCount = data
          .whereType<Map<String, dynamic>>()
          .map((jsonData) => TaskStatusCountModel.fromJson(jsonData))
          .toList();

      setState(() {
        taskCountByStatus = taskCount;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.errorMessage ?? 'Failed to load task counts'),
        ),
      );
    }
  }

  // ================= REFRESH =================

  Future<void> _refreshAll() async {
    await Future.wait([getAllTaskCount(), getTask(_currentStatus)]);
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,

      body: Column(
        children: [
          // ================= TASK COUNT =================
          SizedBox(
            height: 100,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              scrollDirection: Axis.horizontal,
              itemCount: taskCountByStatus.length,

              itemBuilder: (context, index) {
                final taskCount = taskCountByStatus[index];

                final String status = taskCount.sId ?? '';

                return SizedBox(
                  width: 100,

                  child: GestureDetector(
                    onTap: () {
                      if (status.isNotEmpty) {
                        getTask(status);
                      }
                    },

                    child: TaxCardCount(
                      title: status,
                      count: taskCount.sum?.toInt() ?? 0,
                    ),
                  ),
                );
              },

              separatorBuilder: (context, index) {
                return const SizedBox(width: 5);
              },
            ),
          ),

          // ================= TASK LIST =================
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshAll,

              child: _isLoadingTasks
                  ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(
                    height: 400,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ],
              )
                  : taskList.isEmpty
                  ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: 400,
                    child: Center(
                      child: Text(
                        'No $_currentStatus Task Found',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              )
                  : ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),

                itemCount: taskList.length,

                itemBuilder: (context, index) {
                  final task = taskList[index];

                  return TaskCard(
                    taskModel: task,
                    cardColor: Colors.blue,

                    onEdit: () {
                      print('Edit clicked');
                    },

                    onDelete: () {
                      print('Delete clicked');
                    },

                    refreshParent: () async {
                      await getAllTaskCount();
                      await getTask('New');
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNewTaskScreen(),
            ),
          );

          // Task successfully added হলে list refresh হবে
          if (result == true) {
            await _refreshAll();
          }
        },
        child: const Icon(Icons.add),
      ),

    );
  }
}
