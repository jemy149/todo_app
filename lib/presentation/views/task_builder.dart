import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:todo_app/presentation/views/all_tasks_item.dart';
import '../styles/colors.dart';
import '../widgets/default_text.dart';

class EmptyScreen extends StatelessWidget {
  EmptyScreen({Key? key, required this.taskType, required this.noTasks, required this.tasks}) : super(key: key);

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
            return AllTasksItem(model: tasks[index],);
          }else if(taskType == 'completed') {
            return AllTasksItem(model: tasks[index],);
          }else if(taskType == 'favourite') {
            return AllTasksItem(model: tasks[index],);
          }else {
            return AllTasksItem(model: tasks[index],);
          }
        },
        // itemBuilder: (context, index) {
        //   if(taskType == 'uncompleted') {
        //     return DoneTaskItem(model: tasks[index],);
        //   }else if(taskType == 'completed') {
        //     return CompletedTaskItem(model: tasks[index],);
        //   }else if(taskType == 'favourite') {
        //     return FavoriteTaskItem(model: tasks[index],);
        //   }else {
        //     return TaskItem(model: tasks[index]);
        //   }
        // },
        separatorBuilder: (context, index) => const SizedBox(),
        itemCount: tasks.length,
      ),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.menu,color: primaryColor,size: 50,),
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
