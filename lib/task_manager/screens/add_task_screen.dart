import 'package:flutter/material.dart';

import 'package:task_manager/task_manager/models/api_response.dart';
import 'package:task_manager/task_manager/screens/main_nav_screen.dart';
import 'package:task_manager/task_manager/service/api_caller.dart';
import 'package:task_manager/task_manager/utils/urls.dart';
import 'package:task_manager/task_manager/widgets/screen_bg.dart';
import 'package:task_manager/task_manager/widgets/tm_appbar.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController =
  TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  // Add New Task
  Future<void> addNewTask() async {
    // Validate form
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final ApiResponse response = await ApiCaller.postRequest(
        url: TMUrls.addNewTaskURL,
        body: {
          "title": titleController.text.trim(),
          "description": descriptionController.text.trim(),
          "status": "New",
        },
      );

      if (!mounted) return;

      if (response.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task added successfully'),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainNavScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.errorMessage ?? 'Failed to add task',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TmAppBar(),

      body: ScreenBG(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 120),

                  Text(
                    'Add New Task',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height: 25),

                  // Title
                  TextFormField(
                    controller: titleController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: 'Title',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please Enter Title';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 25),

                  // Description
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      hintText: 'Description',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please Enter Description';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  // Add Task Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : addNewTask,
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Add Task'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}