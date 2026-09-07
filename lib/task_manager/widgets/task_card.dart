import 'package:flutter/material.dart';
import 'package:task_manager/task_manager/models/api_response.dart';
import 'package:task_manager/task_manager/models/task_model.dart';
import 'package:task_manager/task_manager/service/api_caller.dart';
import 'package:task_manager/task_manager/utils/urls.dart';

class TaskCard extends StatefulWidget {
  final TaskModel taskModel;
  final Color cardColor;

  final VoidCallback refreshParent;

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;


  const TaskCard({
    super.key,
    required this.taskModel,
    required this.cardColor,
    required this.refreshParent,
    this.onEdit,
    this.onDelete,

  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {

  Future<void> deleteTask ()async{
    final ApiResponse response = await ApiCaller.getRequest(url: TMUrls.deleteTaskURL(widget.taskModel.sId.toString()));

    if(response.isSuccess){
      widget.refreshParent();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Task Deleted')));
      
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Something Wrong....!')));
    }
  }

  Future<void> changeStatusTask (String status)async{
    final ApiResponse response = await ApiCaller.getRequest(url:
    TMUrls.updateTaskStatusURL(widget.taskModel.sId.toString(),status));
setState(() {

});
    if(response.isSuccess){
      widget.refreshParent();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Task Updated ')));

    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Something Wrong....!')));
    }
  }

  Future<void> showChangeStatusDialog(BuildContext context, String currentStatus) async {
    String selectedStatus = currentStatus;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Change Status'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: ['New', 'Progress', 'Completed', 'Cancelled']
                    .map((status) => RadioListTile<String>(
                  title: Text(status),
                  value: status,
                  groupValue: selectedStatus,
                  onChanged: (value) {
                    setStateDialog(() {
                      selectedStatus = value!;
                    });
                  },
                ))
                    .toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // এখানে API call / status update logic দিন
                    changeStatusTask(selectedStatus);
                    Navigator.pop(context);
                  },
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        title: Text(
          widget.taskModel.title ?? '',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
        ),

        subtitle: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),

              Text(widget.taskModel.description ?? ''),

              const SizedBox(height: 4),

              Text('Date: ${widget.taskModel.createdDate ?? ''}'),

              const SizedBox(height: 4),

              Row(
                children: [
                  // Status
                  Chip(
                    label: Text(
                      widget.taskModel.status ?? '',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: widget.cardColor,
                  ),

                  const Spacer(),

                  // ================= EDIT =================
                  IconButton(
                    onPressed:(){
                      showChangeStatusDialog(context,widget.taskModel.status ?? 'NEW');


                    },

                    icon: const Icon(Icons.edit, color: Colors.orange),
                  ),

                  // ================= DELETE =================
                  IconButton(
                    onPressed: () {
                      _showDeleteDialog(context);
                      //deleteTask();
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),

        ),
      ),
    );
  }

  // ================= DELETE CONFIRMATION =================
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Confirm?'),

          content: const Text('Are you sure you want to delete this task?'),

          actions: [
            // Cancel
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),

            // Delete
            TextButton(
              onPressed: () {

                deleteTask();
                Navigator.pop(context);
                // Call delete callback only once
                //widget.onDelete?.call();
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
