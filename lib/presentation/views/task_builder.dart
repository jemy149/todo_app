import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:todo_app/presentation/views/favorite_task_item.dart';

import '../styles/colors.dart';
import '../widgets/default_text.dart';
import 'completed_task_item.dart';
import 'uncompleted_task_item.dart';
import 'task_item.dart';

class TaskBuilder extends StatelessWidget {
  TaskBuilder({Key? key, required this.taskType, required this.noTasks, required this.tasks}) : super(key: key);

  List<Map> tasks;
  String noTasks;
  String taskType;


  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
      condition: tasks.isNotEmpty,
      builder: (context) =>  ListView.separated(
        itemBuilder: (context, index) {
          if(taskType == 'uncompleted') {
            return DoneTaskItem(model: tasks[index],);
          }else if(taskType == 'completed') {
            return CompletedTaskItem(model: tasks[index],);
          }else if(taskType == 'favourite') {
            return FavoriteTaskItem(model: tasks[index],);
          }else {
            return TaskItem(model: tasks[index]);
          }
        },
        separatorBuilder: (context, index) => const SizedBox(),
        itemCount: tasks.length,
      ),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.menu,
              size: 75.0,
              color: primaryColor,
            ),
            Flexible(
              child: DefaultText(
                text: noTasks,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );

  }
}
