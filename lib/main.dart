import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:window_manager/window_manager.dart';
import 'package:window_size/window_size.dart';

import 'route.dart';

void main() async {
  await Future.wait([resetWindowsSize(), GetStorage.init()]);
  runApp(const MainApp());
}

Future resetWindowsSize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  windowManager.setMaximizable(false);
  windowManager.setResizable(false);
  windowManager.setTitle("原神分辨率助手");
  const size = Size(320, 400);
  const windowOptions = WindowOptions(
    size: size,
    minimumSize: size,
    maximumSize: size,
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Platform.isWindows ? ThemeData(fontFamily: '微软雅黑') : null;
    return GetMaterialApp(
      enableLog: true,
      initialRoute: Routes.main,
      getPages: Routes.pages,
      theme: theme,
    );
  }
}
