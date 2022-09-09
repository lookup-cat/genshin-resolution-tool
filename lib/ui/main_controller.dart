import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:win32_registry/win32_registry.dart';
import 'package:window_size/window_size.dart';

class ResolutionSize {
  int width;
  int height;

//<editor-fold desc="Data Methods">

  ResolutionSize({
    required this.width,
    required this.height,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is ResolutionSize &&
              runtimeType == other.runtimeType &&
              width == other.width &&
              height == other.height);

  @override
  int get hashCode => width.hashCode ^ height.hashCode;

  @override
  String toString() {
    return 'ResolutionSize{' + ' width: $width,' + ' height: $height,' + '}';
  }

  ResolutionSize copyWith({
    int? width,
    int? height,
  }) {
    return ResolutionSize(
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'width': this.width,
      'height': this.height,
    };
  }

  factory ResolutionSize.fromMap(Map<String, dynamic> map) {
    return ResolutionSize(
      width: map['width'] as int,
      height: map['height'] as int,
    );
  }

//</editor-fold>
}

class MainController extends GetxController {
  final sizes = RxList<ResolutionSize>();
  final heightController = TextEditingController();
  final widthController = TextEditingController();
  final storage = GetStorage();
  static const sizesKey = "sizes";
  static const registryPath = "Software\\miHoYo\\原神";
  static const heightKey = "Screenmanager Resolution Height_h2627697771";
  static const widthKey = "Screenmanager Resolution Width_h182942802";
  final registry = Registry.openPath(RegistryHive.currentUser,
      path: registryPath, desiredAccessRights: AccessRights.allAccess);

  Screen? screen;

  @override
  void onInit() {
    super.onInit();
    getCurrentScreen().then((value) {
      printInfo(info: 'screen: ${value?.frame.width} × ${value?.frame.height}');
      screen = value;
    });
    readSizeFromRegistry();
    readSizes();
    ever(sizes, (_) => saveSizes());
  }

  Future saveSizes() {
    final value = jsonEncode(sizes.toList(),
        toEncodable: (obj) => (obj as ResolutionSize).toMap());
    printInfo(info: 'saveSizes: $value');
    return storage.write(sizesKey, value);
  }

  void readSizes() {
    final value = storage.read(sizesKey);
    printInfo(info: 'readSizes: $value');
    if (value == null) {
      return;
    }
    try {
      List<dynamic> values = jsonDecode(value);
      final sizes = values.map((e) => ResolutionSize.fromMap(e));
      this.sizes.addAll(sizes);
    } on Exception {
      return;
    }
  }

  void readSizeFromRegistry() {
    final height = registry.getValueAsInt(heightKey);
    final width = registry.getValueAsInt(widthKey);
    heightController.text = height.toString();
    widthController.text = width.toString();
  }

  @override
  void onClose() {
    super.onClose();
    registry.close();
  }

  void writeSizeToRegistry() {
    final height = registry.getValue(heightKey);
    final width = registry.getValue(widthKey);
    final heightValue = int.parse(heightController.text);
    final widthValue = int.parse(widthController.text);
    registry.createValue(RegistryValue(heightKey, height!.type, heightValue));
    registry.createValue(RegistryValue(widthKey, width!.type, widthValue));
  }
}
