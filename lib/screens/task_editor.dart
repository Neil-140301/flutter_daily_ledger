import 'package:flutter/material.dart';
import 'package:flutter_crud_app/main.dart';
import 'package:flutter_crud_app/models/task_model.dart';
import 'package:hive_flutter/adapters.dart';

class TaskEditor extends StatefulWidget {
  final Task? task;

  const TaskEditor({super.key, this.task});

  @override
  State<TaskEditor> createState() => _TaskEditorState();
}

class _TaskEditorState extends State<TaskEditor> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController taskTitle = TextEditingController(
        text: widget.task == null ? null : widget.task?.title ?? '');
    final TextEditingController taskNote = TextEditingController(
        text: widget.task == null ? null : widget.task?.note ?? '');

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(widget.task == null ? 'Add a new task' : 'Edit task',
              style: const TextStyle(
                color: Colors.black,
              )),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Your Task\'s Title',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: taskTitle,
                  decoration: InputDecoration(
                      fillColor: Colors.blue.shade100.withAlpha(75),
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(8)),
                      hintText: 'Task Title'),
                ),
                const SizedBox(
                  height: 40,
                ),
                const Text('Your Task\'s Note',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  keyboardType: TextInputType.multiline,
                  minLines: 5,
                  maxLines: 25,
                  controller: taskNote,
                  decoration: InputDecoration(
                      fillColor: Colors.blue.shade100.withAlpha(75),
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(8)),
                      hintText: 'Task Note'),
                ),
                Expanded(
                    child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: RawMaterialButton(
                        onPressed: () async {
                          Task newTask = Task(
                              title: taskTitle.text,
                              note: taskNote.text,
                              createdAt: DateTime.now(),
                              done: false);

                          Box<Task> taskBox = Hive.box<Task>('tasks');
                          if (widget.task != null) {
                            widget.task!.title = newTask.title;
                            widget.task!.note = newTask.note;
                            widget.task!.save();
                          } else {
                            await taskBox.add(newTask);
                          }

                          if (!mounted) return;
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                        },
                        fillColor: Colors.blueAccent.shade700,
                        child: Text(
                          widget.task == null ? 'Add Task' : 'Update Task',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        )),
                  ),
                ))
              ]),
        ));
  }
}
