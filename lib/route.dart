import 'package:get/get.dart';

import 'ui/main_controller.dart';
import 'ui/main_page.dart';

class Routes {
  static const main = "/main";

  // ignore: top_level_function_literal_block
  // binding: ScopeBindingsBuilder(SPLASH, (scope) {
  //   scope.put(UserApi());
  //   scope.put(SplashController(scope.find()));
  // }),

  static final pages = [
    GetPage(
        name: main,
        page: () => const MainPage(),
        binding: BindingsBuilder.put(() => MainController())),
  ];
}
