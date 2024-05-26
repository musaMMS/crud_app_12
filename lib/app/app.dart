
import 'package:device_preview_minus/device_preview_minus.dart';
import 'package:flutter/material.dart';

import '../themes/appbar-style.dart';
import '../themes/elevated_button_style.dart';
import '../utils/colors.dart';
import '../utils/routes.dart';
import 'app_scroll_behaviour.dart';

class CrudApp extends StatelessWidget {
  const CrudApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.homeScreen,
      onGenerateRoute: (routeSettings) => Routes.generateRoute(routeSettings),
      theme: ThemeData(
          appBarTheme: AppbarStyle.getAppbarStyle(),
          scaffoldBackgroundColor: whiteColor,
          elevatedButtonTheme: ElevatedButtonStyle.getElevatedButtonStyle()
      ),
      scrollBehavior: AppScrollBehaviour(),
    );
  }
}
