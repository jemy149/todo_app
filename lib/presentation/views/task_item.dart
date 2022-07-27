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

          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.sp)),
            color: primaryColor,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                    width: 90.w,
                    padding: EdgeInsets.symmetric(horizontal: 1.w,vertical: 1.h),
                    child: Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.only(start: 2.w,bottom: 3.h,top: 1.h),
                                  child: DefaultText(
                                    text: '${model['title']}',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    maxLines: 3,
                                    color: Colors.teal,
                                  ),
                                ),
                              ),

                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: DefaultText(
                                          text: 'Starting: ${model['startTime']}',
                                          fontSize: 9.sp,
                                          color: lightBlue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      Flexible(
                                        child: DefaultText(
                                          text: 'Ending: ${model['endTime']}',
                                          fontSize: 9.sp,
                                          color: lightBlue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Flexible(child:   Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          DefaultText(
                                            text: '${model['reminder']}',
                                            fontSize: 8.sp,
                                            color: lightBlue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ],
                                      ),)
                                    ],
                                  ),
                                  height: 8.h,
                                ),
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  DefaultText(
                                    text: '${model['date']}',
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.bold,
                                    color: lightBlue,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
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
                                          color: Colors.tealAccent,

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

                                          Icons.close,

                                          color: Colors.teal,

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

                                          color: Colors.tealAccent,

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
                  ),],
                ),

              ],
            ),
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
