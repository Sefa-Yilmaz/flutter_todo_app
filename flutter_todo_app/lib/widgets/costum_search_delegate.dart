import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/data/local_storage.dart';
import 'package:flutter_todo_app/main.dart';
import 'package:flutter_todo_app/models/task_model.dart';
import 'package:flutter_todo_app/widgets/task_list_item.dart';

class CostumSearchDelegate extends SearchDelegate {
  final List<Task> allTasks;

  CostumSearchDelegate({required this.allTasks});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query.isEmpty ? null : query = '';
          },
          icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
      onTap: () {
        close(context, null);
      },
      child: const Icon(
        Icons.arrow_back_ios,
        color: Colors.black,
        size: 24,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> filteredList = allTasks
        .where(
            (gorev) => gorev.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return filteredList.length > 0
        ? ListView.builder(
            itemBuilder: (context, index) {
              var _oankiListeElemani = filteredList[index];
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
                onDismissed: (direction) async {
                  filteredList.removeAt(index);
                  await locator<LocalStorge>()
                      .deleteTask(task: _oankiListeElemani);
                },
                child: TaskItem(task: _oankiListeElemani),
              );
            },
            itemCount: filteredList.length,
          )
        : Center(
            child: const Text(
              'search_not_found',
              style: TextStyle(fontSize: 24),
            ).tr(),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
