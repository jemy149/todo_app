import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:todo_app/data/local/flutter_local_notifications.dart';
import 'package:todo_app/presentation/router/app_router.dart';
import 'business_logic/cubit/cubit.dart';
import 'package:timezone/data/latest.dart' as time_zone;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  NotificationService().requestIOSPermissions();
  BlocOverrides.runZoned(
        () {
      runApp(MyApp());
    },

  );

}

class MyApp extends StatefulWidget {

  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRouter appRouter = AppRouter();

  @override
  void initState() {
    super.initState();
    setState(() {
      time_zone.initializeTimeZones();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: appRouter.onGenerateRoute,
        ),
    );
    },
  );
}
}