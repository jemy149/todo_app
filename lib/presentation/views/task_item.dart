import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:todo_app/presentation/views/edit_task_title_dialog.dart';

import '../../business_logic/cubit/cubit.dart';
import '../styles/colors.dart';
import '../widgets/default_text.dart';

class TaskItem extends StatelessWidget {
  TaskItem({Key? key, required this.model}) : super(key: key);

  Map model;

  @override
  Widget build(BuildContext context) {

    return Dismissible(
      key: Key(model['id'].toString()),
      child: InkWell(
        splashColor: primaryColor,
        highlightColor: primaryColor,
        onTap: (){
          Fluttertoast.showToast(
              msg: "Long touch to edit, Swipe to delete",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: black,
              textColor: lightBlue,
              fontSize: 14.sp
          );
        },
        onLongPress: (){
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return EditTaskTitleDialog(model: model,);
            },
          );
        },
        child: Padding(

          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),

          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                  height: 5.h,
                  width: 90.w,
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 1.h),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(start: 2.w),
                            child: DefaultText(
                              text: '${model['title']}',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              maxLines: 3,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        DefaultText(
                          text: '${model['date']}',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: lightBlue,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [


                        Flexible(
                          child: DefaultText(
                            text: 'Starts at: ${model['startTime']}',
                            fontSize: 12.sp,
                            color: gray!,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Flexible(
                          child: DefaultText(
                            text: 'Ends at: ${model['endTime']}',
                            fontSize: 12.sp,
                            color: gray!,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.alarm, color: Colors.red,),
                          DefaultText(
                            text: '${model['reminder']}',
                            fontSize: 10.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          model['status'] == 'completed' ? const SizedBox()
                              : IconButton(
                            onPressed: (){

                            AppCubit.get(context).changeStatus(

                              status: 'completed',

                              id: model['id'],

                            );},

                            icon: const Icon(

                              Icons.check_circle,

                              color: primaryColor,

                            ),

                          ),

                          model['status'] == 'uncompleted' ? const SizedBox()
                              : IconButton(
                            onPressed: (){

                            AppCubit.get(context).changeStatus(

                              status: 'uncompleted',

                              id: model['id'],

                            );},

                            icon: const Icon(

                              Icons.close_outlined,

                              color: primaryColor,

                            ),

                          ),

                          model['status'] == 'favorite' ? const SizedBox()
                              : IconButton(
                            onPressed: (){

                            AppCubit.get(context).changeStatus(

                              status: 'favorite',

                              id: model['id'],

                            );},

                            icon: const Icon(

                              Icons.favorite,

                              color: Colors.red,

                            ),

                          ),
                        ],
                      ),
                    ],
                  ),

                ],

              ),
            ],
          ),

        ),
      ),
      onDismissed: (direction){
        AppCubit.get(context).deleteData(id: model['id'],);
        Fluttertoast.showToast(
            msg: "Task deleted successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: primaryColor,
            fontSize: 14.sp
        );
      },
    );
  }
}
