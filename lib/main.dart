import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/core/theme/app_theme.dart';
import 'app/core/services/storage_service.dart';
import 'app/core/bindings/initial_binding.dart';

void main() async {
  try {
    print('🚀 Starting Chatty App...');
    WidgetsFlutterBinding.ensureInitialized();
    print('✅ Flutter binding initialized');

    // Initialize Hive
    print('🔄 Initializing Hive...');
    await Hive.initFlutter();
    print('✅ Hive initialized');

    // Initialize services
    print('🔄 Initializing StorageService...');
    await Get.putAsync(() => StorageService.init());
    print('✅ StorageService initialized');

    // Set preferred orientations
    print('🔄 Setting orientations...');
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    print('✅ Orientations set');

    // Set system UI overlay style
    print('🔄 Setting system UI overlay...');
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    print('✅ System UI overlay set');

    print('🎉 Running app...');
    runApp(const ChattyApp());
  } catch (e, stackTrace) {
    print('❌ Error in main: $e');
    print('Stack trace: $stackTrace');
    // Run app anyway with minimal error screen
    runApp(MaterialApp(
      home: Scaffold(
        body:  Center(
          child: Text('Error: $e'),
        ),
      ),
    ));
  }
}

class ChattyApp extends StatelessWidget {
  const ChattyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print('🏗️ Building ChattyApp widget...');
    try {
      return GetMaterialApp(
        title: 'Chatty',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        initialBinding: InitialBinding(),
        initialRoute: AppRoutes.splash,
        getPages: AppPages.routes,
        defaultTransition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 300),
        onInit: () {
          print('✅ GetMaterialApp initialized');
        },
      );
    } catch (e, stackTrace) {
      print('❌ Error building ChattyApp: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }
}
