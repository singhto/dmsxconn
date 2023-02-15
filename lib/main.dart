import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psinsx/offlineMode/home_offline.dart';
import 'package:psinsx/pages/home_page.dart';
import 'package:psinsx/pages/insx_page_old.dart';
import 'package:psinsx/pages/map_dmsx.dart';
import 'package:psinsx/pages/out_time.dart';
import 'package:psinsx/pages/signin_page.dart';
import 'package:psinsx/pages/wait_work.dart';
import 'package:psinsx/pages/worktime.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, WidgetBuilder> map = {
  '/homePage': (BuildContext context) => HomePage(),
  '/signIn': (BuildContext context) => SignIn(),
  '/homeOffline': (BuildContext context) => HomeOffline(),
  '/mapDmsx': (BuildContext context) => Mapdmsx(),
  '/workTime': (BuildContext context) => WorkTime(),
  '/outTime': (BuildContext context) => OutTime(),
  '/waitWork': (BuildContext context) => WaitWork(),
  '/insxPage': (BuildContext context) => InsxPageOld(),
};

String initialRount;

Future<Null> main() async {
  HttpOverrides.global = MyHttpOverride();
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String string = preferences.getString('id');

  if (string?.isEmpty ?? true) {
    initialRount = '/signIn';
    runApp(MyApp());
  } else {
    initialRount = '/homePage';
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'dmsxConnect',
      theme: ThemeData(
          fontFamily: 'Prompt',
          brightness: Brightness.dark,
          primaryColor: Color(0xff6a1b9a),
          accentColor: Color(0xff6a1b9a),
          textTheme: TextTheme(
            headline5: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            bodyText2: TextStyle(fontSize: 18),
          )),
      debugShowCheckedModeBanner: false,
      routes: map,
      initialRoute: initialRount,
    );
  }
}

class MyHttpOverride extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
