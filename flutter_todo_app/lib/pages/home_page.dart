// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_todo_app/data/local_storage.dart';
import 'package:flutter_todo_app/helper/translations_helper.dart';
import 'package:flutter_todo_app/main.dart';
import 'package:flutter_todo_app/models/task_model.dart';
import 'package:flutter_todo_app/widgets/costum_search_delegate.dart';
import 'package:flutter_todo_app/widgets/task_list_item.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTasks;
  late LocalStorge _localStorge;

  @override
  void initState() {
    super.initState();
    _localStorge = locator<LocalStorge>();
    _allTasks = <Task>[];
    _getAllTaskFromDb();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            _showAddTaskBottomSheet();
          },
          child: const Text(
            'title',
            style: TextStyle(color: Colors.black),
          ).tr(),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              _showSearchPage();
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              _showAddTaskBottomSheet();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _allTasks.isNotEmpty
          ? ListView.builder(
              itemBuilder: (context, index) {
                var _oankiListeElemani = _allTasks[index];
                return Dismissible(
                  background: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.delete,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 10),
                      const Text('remove_task').tr(),
                    ],
                  ),
                  key: Key(_oankiListeElemani.id),
                  onDismissed: (direction) {
                    _allTasks.removeAt(index);
                    _localStorge.deleteTask(task: _oankiListeElemani);
                    setState(() {});
                  },
                  child: TaskItem(task: _oankiListeElemani),
                );
              },
              itemCount: _allTasks.length,
            )
          : Center(
              child: const Text(
                'empty_task_list',
                style: TextStyle(fontSize: 24),
              ).tr(),
            ),
    );
  }

  void _showAddTaskBottomSheet() {
    showBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          width: MediaQuery.of(context).size.width,
          child: ListTile(
            title: TextField(
              autofocus: true,
              style: const TextStyle(fontSize: 20),
              decoration: InputDecoration(
                  hintText: 'add_task'.tr(), border: InputBorder.none),
              onSubmitted: (value) {
                Navigator.of(context).pop();
                if (value.length > 3) {
                  DatePicker.showTimePicker(context,
                    locale: TranslationsHelper.getDeviceLanguage(context),
                    showSecondsColumn: false,
                    onConfirm: (time) async {
                      var yeniEkelnecekGorev =
                          Task.create(name: value, createdAt: time);
                      _allTasks.insert(0, yeniEkelnecekGorev);
                      await _localStorge.addTask(task: yeniEkelnecekGorev);
                      setState(() {});
                    },
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  void _getAllTaskFromDb() async {
    _allTasks = await _localStorge.getAllTask();
    setState(() {});
  }

  void _showSearchPage() async {
    await showSearch(
        context: context, delegate: CostumSearchDelegate(allTasks: _allTasks));
    _getAllTaskFromDb();
  }
}
