import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:todo_app/presentation/widgets/default_text.dart';

import '../../../business_logic/cubit/cubit.dart';
import '../../../business_logic/cubit/states.dart';
import '../../styles/colors.dart';
import '../../widgets/default_form_field.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var startTimeController = TextEditingController();
  var endTimeController = TextEditingController();
  var dateController = TextEditingController();
  TimeOfDay initialStartTime = TimeOfDay.now();
  TimeOfDay initialEndTime =
      TimeOfDay.fromDateTime(DateTime.now().add(const Duration(minutes: 1)));
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {
        if (state is AppInsertTaskState) {
          Navigator.pop(context);
        }
      },
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);

        return SafeArea(
          child: Scaffold(
            backgroundColor: lightBlue,
            key: scaffoldKey,
            body: ConditionalBuilder(
              condition: state is! AppGetDBLoadingState,
              builder: (BuildContext context) =>
                  cubit.screens[cubit.currentIndex],
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                      title: titleController.text,
                      startTime: startTimeController.text,
                      endTime: endTimeController.text,
                      date: dateController.text,
                      reminder: cubit.dropDownValue,
                    );
                    cubit.settingReminder(titleController.text, selectedDate!,
                        selectedStartTime!, cubit.dropDownValue);
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Wrap(
                          children: [
                            Container(
                              color: primaryColor,
                              padding: EdgeInsets.symmetric(
                                  vertical: 2.h, horizontal: 3.w),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DefaultFormField(
                                      controller: titleController,
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Title must not be empty';
                                        }
                                        return null;
                                      },
                                      labelText: 'Task Title',
                                      textColor: white,
                                      prefixIcon: const Icon(
                                        Icons.title_outlined,
                                        color: lightBlue,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2.h),
                                      child: DefaultFormField(
                                        controller: dateController,
                                        keyboardType: TextInputType.datetime,
                                        onTap: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2024-01-07'),
                                          ).then((value) {
                                            selectedDate = value;
                                            dateController.text =
                                                DateFormat.yMMMd()
                                                    .format(value!)
                                                    .toString();
                                          });
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Date must not be empty';
                                          }
                                          return null;
                                        },
                                        labelText: 'Task Date',
                                        textColor: white,
                                        prefixIcon: const Icon(
                                          Icons.date_range_outlined,
                                          color: lightBlue,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsetsDirectional.only(
                                                end: 2.w),
                                            child: DefaultFormField(
                                              controller: startTimeController,
                                              onTap: () {
                                                showTimePicker(
                                                  context: context,
                                                  initialTime: initialStartTime,
                                                ).then((value) {
                                                  selectedStartTime = value;
                                                  startTimeController.text =
                                                      selectedStartTime!
                                                          .format(context)
                                                          .toString();
                                                });
                                              },
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Start Time must not be empty';
                                                }
                                                return null;
                                              },
                                              labelText: 'Start Time',
                                              textColor: white,
                                              prefixIcon: const Icon(
                                                Icons.timer,
                                                color: lightBlue,
                                              ),
                                              keyboardType:
                                                  TextInputType.datetime,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: DefaultFormField(
                                            controller: endTimeController,
                                            onTap: () {
                                              showTimePicker(
                                                context: context,
                                                initialTime: initialEndTime,
                                              ).then((value) {
                                                if (value!.hour.toDouble() >
                                                    selectedStartTime!.hour
                                                        .toDouble()) {
                                                  selectedEndTime = value;
                                                  endTimeController.text =
                                                      selectedEndTime!
                                                          .format(context)
                                                          .toString();
                                                } else if (value.hour
                                                            .toDouble() ==
                                                        selectedStartTime!.hour
                                                            .toDouble() &&
                                                    value.minute.toDouble() >=
                                                        selectedStartTime!.minute
                                                            .toDouble()) {
                                                  selectedEndTime = value;
                                                  endTimeController.text =
                                                      selectedEndTime!
                                                          .format(context)
                                                          .toString();
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "End Time can't be before Start Time",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor: Colors.red,
                                                      textColor: primaryColor,
                                                      fontSize: 16.0);
                                                }
                                              });
                                            },
                                            labelText: 'End Time',
                                            textColor: white,
                                            prefixIcon: const Icon(
                                              Icons.timer_off_outlined,
                                              color: lightBlue,
                                            ),
                                            keyboardType: TextInputType.datetime,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 2.h),
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          border: Border.all(
                                              color: black, width: 0.3),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: BlocBuilder<AppCubit, AppStates>(
                                          builder: (BuildContext context, state) {
                                            return DropdownButton(
                                                isExpanded: true,
                                                dropdownColor: primaryColor,
                                                icon: Padding(
                                                  padding:
                                                      EdgeInsetsDirectional.only(
                                                          end: 3.w),
                                                  child: const Icon(
                                                    Icons.keyboard_arrow_down,
                                                    color: lightBlue,
                                                  ),
                                                ),
                                                value: cubit.dropDownValue,
                                                items: cubit.dropDownListItems
                                                    .map((String items) {
                                                  return DropdownMenuItem(
                                                      value: items,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .only(start: 3.w),
                                                        child: DefaultText(
                                                          text: items,
                                                          color: lightBlue,
                                                        ),
                                                      ));
                                                }).toList(),
                                                onChanged: (String? newValue) =>
                                                    cubit.changeDropDownListValue(
                                                        newValue!));
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        elevation: 20.0,
                      )
                      .closed
                      .then((value) {
                    cubit.changeBSState(
                      isShow: false,
                      icon: Icons.add_box,
                      color: Colors.teal
                    );
                  });
                  cubit.changeBSState(
                    isShow: true,
                    color: Colors.teal,
                    icon: Icons.add,
                  );
                }
              },
              child: Icon(
                cubit.fabIcon,
                color: lightBlue,
              ),
            ),
            bottomNavigationBar: BottomNavyBar(
              backgroundColor: primaryColor,
              showElevation: true,
              items: [
                BottomNavyBarItem(
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.tealAccent,
                    ),
                    title: const Text(
                      'Tasks',
                      style: TextStyle(
                        color: Colors.teal,
                      ),
                    )),
                BottomNavyBarItem(
                    icon: const Icon(
                      Icons.check_box_outline_blank_rounded,
                      color: Colors.tealAccent,
                    ),
                    title: const Text(
                      'Un-Done',
                      style: TextStyle(
                        color: Colors.teal,
                      ),
                    )),
                BottomNavyBarItem(
                    icon: const Icon(
                      Icons.check_box_rounded,
                      color: Colors.tealAccent,
                    ),
                    title: const Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.teal,
                      ),
                    )),
                BottomNavyBarItem(
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.tealAccent,
                    ),
                    title: const Text(
                      'Favourites',
                      style: TextStyle(
                        color: Colors.teal,
                      ),
                    )),
              ],
              onItemSelected: (index) {
                cubit.changeIndex(index);
              },
              selectedIndex: cubit.currentIndex,
            ),
          ),
        );
      },
    );
  }
}
