import 'package:flutter/material.dart';

import '../models/task_model.dart';

class UpdateTaskScreen extends StatefulWidget {
  final TaskModel taskModel;

  const UpdateTaskScreen({super.key, required this.taskModel});

  @override
  State<UpdateTaskScreen> createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  String selectedStatus = 'Progress';

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.taskModel.title ?? '');

    descriptionController = TextEditingController(
      text: widget.taskModel.description ?? '',
    );

    selectedStatus = widget.taskModel.status ?? 'Progress';
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  // ================= UPDATE =================

  void updateTask() {
    final String title = titleController.text.trim();
    final String description = descriptionController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter task title')));
      return;
    }

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter task description')),
      );
      return;
    }

    // পরে এখানে Update API call হবে

    print('Task ID: ${widget.taskModel.sId}');
    print('Title: $title');
    print('Description: $description');
    print('Status: $selectedStatus');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Task')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= TITLE =================
            const Text(
              'Task Title',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Enter task title',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // ================= DESCRIPTION =================
            const Text(
              'Description',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Enter task description',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // ================= STATUS =================
            const Text(
              'Status',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: selectedStatus,

              decoration: const InputDecoration(border: OutlineInputBorder()),

              items: const [
                DropdownMenuItem(value: 'New', child: Text('New')),
                DropdownMenuItem(value: 'Progress', child: Text('Progress')),
                DropdownMenuItem(value: 'Completed', child: Text('Completed')),
                DropdownMenuItem(value: 'Cancelled', child: Text('Cancelled')),
              ],

              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedStatus = value;
                  });
                }
              },
            ),

            const SizedBox(height: 30),

            // ================= UPDATE BUTTON =================
            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                onPressed: updateTask,

                child: const Text(
                  'Update Task',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
