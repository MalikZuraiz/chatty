import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../../chat_list/controllers/chat_list_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../settings/controllers/settings_controller.dart';
import '../../notifications/controllers/notifications_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(
      () => MainController(),
    );
    Get.lazyPut<ChatListController>(
      () => ChatListController(),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
    Get.lazyPut<SettingsController>(
      () => SettingsController(),
    );
    Get.lazyPut<NotificationsController>(
      () => NotificationsController(),
    );
  }
}