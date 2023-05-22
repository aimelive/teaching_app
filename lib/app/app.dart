import 'package:e_connect_mobile/data/providers/chats_provider.dart';
import 'package:e_connect_mobile/ui/constants/colors.dart';
import 'package:e_connect_mobile/ui/constants/theme.dart';
import 'package:e_connect_mobile/ui/screens/auth/auth_wrapper.dart';
import 'package:e_connect_mobile/utils/hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //Initializing flutter hive database
  await Hive.initFlutter();

  //Opening database of the saved walks
  await Future.wait([
    Hive.openBox(Boxes.authBox),
  ]);

  runApp(const AppWidget());
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 850),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ChatsProvider(
            child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          color: primaryColor,
          title: 'E-connect - Teaching App',
          theme: MyThemes.theme,
          home: child,
        ));
      },
      child: const AuthWrapper(),
    );
  }
}
