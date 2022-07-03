import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_app/models/task_model.dart';
import 'package:flutter_crud_app/screens/task_editor.dart';
import 'package:flutter_crud_app/widgets/my_list_tile.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<Task>(TaskAdapter());
  await Hive.openBox<Task>('tasks');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Daily Ledger',
            style: TextStyle(
              color: Colors.black,
            )),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<Task>>(
          valueListenable: Hive.box<Task>('tasks').listenable(),
          builder: (context, box, _) {
            return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Today's Task",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 26,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(formatDate(DateTime.now(), [d, ", ", M, " ", yyyy]),
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 18,
                        )),
                    const Divider(height: 40, thickness: 1),
                    Expanded(
                        child: ListView.builder(
                            itemCount: box.values.length,
                            itemBuilder: (context, index) {
                              Task currentTask = box.getAt(index)!;
                              return MyListTile(
                                task: currentTask,
                                index: index,
                              );
                            }))
                  ],
                ));
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const TaskEditor()));
          },
          child: const Icon(Icons.add)),
    );
  }
}
