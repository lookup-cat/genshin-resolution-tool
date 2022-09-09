import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genshin_resolution_tool/ui/main_controller.dart';
import 'package:get/get.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainController>();
    final formKey = GlobalKey<FormState>();
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 46, right: 46),
            child: _buildSizeEditor(formKey, controller)),
        const Padding(padding: EdgeInsets.only(top: 36)),
        MaterialButton(
            onPressed: () {
              if (formKey.currentState?.validate() != true) {
                return;
              }
              int width = int.parse(controller.widthController.text);
              int height = int.parse(controller.heightController.text);
              if (controller.sizes.any((element) =>
                  element.width == width && element.height == height)) {
                final snackBar = SnackBar(
                  content: const Text('已存在相同的预设配置'),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(label: '好的', onPressed: () {  },),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                return;
              }
              controller.sizes
                  .add(ResolutionSize(width: width, height: height));
              final snackBar = SnackBar(
                content: const Text('保存成功'),
                duration: const Duration(seconds: 2),
                action: SnackBarAction(label: '好的', onPressed: () {  },),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            minWidth: 150,
            color: Colors.blue,
            child: const Text(
              '保存到预设配置',
              style: TextStyle(color: Colors.white),
            )),
        const Padding(padding: EdgeInsets.only(top: 12)),
        MaterialButton(
            onPressed: () {
              Get.dialog(_buildSizeListDialog(controller));
            },
            minWidth: 150,
            color: Colors.blue,
            child: const Text(
              '选择预设配置',
              style: TextStyle(color: Colors.white),
            )),
        const Padding(padding: EdgeInsets.only(top: 12)),
        MaterialButton(
            onPressed: () {
              if (formKey.currentState?.validate() != true) {
                return;
              }
              controller.writeSizeToRegistry();
              final snackBar = SnackBar(
                content: const Text('保存成功'),
                duration: const Duration(seconds: 2),
                action: SnackBarAction(label: '好的', onPressed: () {  },),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            color: Colors.blue,
            minWidth: 150,
            child: const Text(
              '应用配置',
              style: TextStyle(color: Colors.white),
            )),
      ],
    ));
  }
}

Widget _buildSizeEditor(
    GlobalKey<FormState> formKey, MainController controller) {
  return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(label: Text('宽度')),
            controller: controller.widthController,
            validator: (value) {
              if (value?.isEmpty == true) {
                return '请输入宽度';
              }
              final width = int.parse(value!);
              if (width <= 0) {
                return '宽度不能小于0';
              }
              final screenWidth = controller.screen?.frame.size.width;
              if (screenWidth != null && width > screenWidth) {
                return '宽度不能大于屏幕分辨率宽度(${screenWidth.toInt()})';
              }
              return null;
            },
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          TextFormField(
              decoration: const InputDecoration(label: Text('高度')),
              controller: controller.heightController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value?.isEmpty == true) {
                  return '请输入高度';
                }
                final height = int.parse(value!);
                if (height <= 0) {
                  return '高度不能小于0';
                }
                final screenWidth = controller.screen?.frame.size.height;
                if (screenWidth != null && height > screenWidth) {
                  return '高度不能大于屏幕分辨率高度(${screenWidth.toInt()})';
                }
                return null;
              })
        ],
      ));
}

AlertDialog _buildSizeListDialog(MainController controller) {
  return AlertDialog(
    title: const Text('选择配置'),
    content: Obx(() => ListView.builder(
        itemCount: controller.sizes.length,
        itemBuilder: (_, index) => InkWell(
              onTap: () {
                final size = controller.sizes[index];
                controller.widthController.text = size.width.toString();
                controller.heightController.text = size.height.toString();
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      '${controller.sizes[index].width} × ${controller.sizes[index].height}',
                    )),
                    TextButton(
                        onPressed: () {
                          controller.sizes.removeAt(index);
                        },
                        child: const Text('删除',
                            style: TextStyle(color: Colors.blue)))
                  ],
                ),
              ),
            ))),
    actions: [
      SimpleDialogOption(
        onPressed: () {
          Get.back();
        },
        child: const Text('取消', style: TextStyle(color: Colors.blue)),
      )
    ],
  );
}
