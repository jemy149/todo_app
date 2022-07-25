import 'package:flutter/material.dart';
import 'package:todo_app/constants/screens.dart' as screen_routes;

import '../screens/home/home_layout.dart';

class AppRouter{
  late Widget startWidget;

  Route? onGenerateRoute(RouteSettings settings){

    startWidget = HomeLayout();

    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (_) => startWidget);
      case screen_routes.HOME_SCREEN:
        return MaterialPageRoute(builder: (_) => HomeLayout());
      default:
        return null;
    }
  }
}