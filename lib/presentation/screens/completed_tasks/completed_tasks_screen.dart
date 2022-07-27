import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../business_logic/cubit/cubit.dart';
import '../../../../business_logic/cubit/states.dart';
import '../../views/task_builder.dart';

class CompletedTasksScreen extends StatelessWidget {
  const CompletedTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state){},
      builder: (context, state){

        var tasks = AppCubit.get(context).completedTasks;

        return EmptyScreen(tasks: tasks, noTasks: '', taskType: 'completed');
      },
    );
  }
}