

import 'package:crud_app_12/app/app.dart';
import 'package:device_preview_minus/device_preview_minus.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(DevicePreview(enabled: true, builder: (BuildContext context) => const CrudApp()));
}