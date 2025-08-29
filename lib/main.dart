
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rename_me/services/firebase_services/firebase_storage_service.dart';
import 'package:rename_me/services/firebase_services/firestore_service.dart';
import 'utils/app_colors.dart';
import 'utils/constants.dart';
import 'utils/route_management.dart';
import 'utils/screen_bindings.dart';

// import 'utils/ssl_http_protocol.dart';

/*Modified By: Afaque Ali on 02-Aug-2023*/
void main() async {
  ErrorWidget.builder = (FlutterErrorDetails details) => Scaffold(
    backgroundColor: Colors.white,
    body: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          details.summary.name??'',
          style: TextStyle(
            fontSize: 16,
            color: kTextColor.withAlpha(200),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '${details.summary.value}',
          style: TextStyle(
            fontSize: 14,
            color: kTextColor.withAlpha(200),
          ),
        ),
      ],
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCcUuKX5o77jnHRPahrlqtfbRPbiXK6Tng",
      appId: "1:678144749729:android:7600c6bc3fb3919bcc00e0",
      messagingSenderId: "your-messaging-sender-id",
      projectId: "face-attendance-bf0c4",
    ),
  );
  // Put services into dependency injection
  Get.put(FirebaseStorageService());
  Get.put(FirestoreService());
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  //for hive
  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);
  // final Box<List<dynamic>> faceBox = Hive.box('face_db');
  // final Box<String> attendanceBox = Hive.box('attendance_db');
  // await Hive.openBox<List>('face_db');
  await Hive.openBox<String>('attendance_db');
  await Hive.openBox('face_db');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: kAppName,
      initialRoute: kSplashScreenRoute,
      initialBinding: ScreensBindings(),
      getPages: RouteManagement.getPages(),
      theme: ThemeData(primarySwatch: Colors.indigo),
      debugShowCheckedModeBanner: false,
    );
  }
}


