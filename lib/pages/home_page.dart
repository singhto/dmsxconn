import 'dart:convert';
import 'dart:io';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:psinsx/models/insx_model2.dart';
import 'package:psinsx/models/user_model.dart';
import 'package:psinsx/pages/add_information_user.dart';
import 'package:psinsx/pages/dashbord.dart';

import 'package:psinsx/pages/help_page.dart';
import 'package:psinsx/pages/information_user.dart';
import 'package:psinsx/pages/map.dart';
import 'package:psinsx/pages/map_dmsx.dart';
import 'package:psinsx/pages/search_dmsx.dart';
import 'package:psinsx/pages/search_page.dart';
import 'package:psinsx/pages/signin_page.dart';
import 'package:psinsx/pages/take_photo_id.dart';
import 'package:psinsx/utility/app_controller.dart';
import 'package:psinsx/utility/app_service.dart';
import 'package:psinsx/utility/my_constant.dart';
import 'package:psinsx/utility/normal_dialog.dart';
import 'package:psinsx/utility/sqlite_helper.dart';
import 'package:psinsx/widgets/show_text.dart';
import 'package:psinsx/widgets/widget_text_button.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  //HomePage({Key key}) : super(key: key);
  bool? statusINSx; // false => Non Back frome edit INSx
  HomePage({Key? key, this.statusINSx}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? nameUser, userEmail, userImge, userId;
  bool? status;

  Widget currentWidget = MyMap();
  int selectedIndex = 0;
  List<InsxModel2> insxModel2s = [];

  List pages = [
    // MyMap2(),
    Mapdmsx(),
    // SearchPage(),
    SearchDmsx(),
    Dashbord(),
  ];

  UserModel? userModel;

  bool online = true;
  var title = <String>[
    //'แจ้งเตือน',
    'งดจ่ายไฟ',
    'ประวัติ',
    'หน้าหลัก',
  ];

  AppController appController = Get.put(AppController());

  @override
  void initState() {
    super.initState();
    cratePages();
    readUserInfo();

    Future.delayed(
      Duration.zero,
      () {
        AppService().processFindLocation(context: context).then((value) {
          print('###5feb position --> ${appController.positions.length}');
        });
      },
    );

    //สำหรับขอ per stor
    Future.delayed(
      Duration.zero,
      () {
        requestManageExternalStoragePermission();
      },
    );
  }

  Future<void> requestManageExternalStoragePermission() async {
    print('###14dec หรับขอ per stor ');

    if (Platform.isAndroid) {
      // ตรวจสอบเวอร์ชัน Android
      if (await Permission.manageExternalStorage.isGranted) {
        print("###14dec MANAGE_EXTERNAL_STORAGE permission already granted.");
      } else {
        final status = await Permission.manageExternalStorage.request();
        if (status.isGranted) {
          print("##14dec MANAGE_EXTERNAL_STORAGE permission granted.");
        } else if (status.isDenied) {
          print("##14dec Permission denied.");
        } else if (status.isPermanentlyDenied) {
          print(
              "##14dec Permission permanently denied. Redirecting to settings...");
          await openAppSettings();
        }
      }
    } else {
      print("##14dec This permission is only available for Android.");
    }
  }

  void cratePages() {
    if (pages.isNotEmpty) {
      pages.clear();
    }
    //pages.add(online ? MyMap2() : MyMap());
    pages.add(Mapdmsx());
    pages.add(SearchDmsx(
      displayBackIcon: false,
    ));
    pages.add(Dashbord());
  }

  Future<Null> readUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    nameUser = preferences.getString('staffname');
    userEmail = preferences.getString('user_email');
    userImge = preferences.getString('user_img');
    userId = preferences.getString('id');

    print('##26oct userId ==>>> $userId');

    String urlGetUserWhereId =
        'https://www.dissrecs.com/apipsinsx/getUserWhereId.php?isAdd=true&user_id=$userId';
    await Dio().get(urlGetUserWhereId).then(
      (value) {
        for (var element in json.decode(value.data)) {
          userModel = UserModel.fromJson(element);

          if (userModel!.staffname!.isEmpty) {
            normalDialog(context, 'กรุณาถ่ายภาพบัตรประชาชน',
                widget: WidgetTextButton(
                  label: 'ถ่ายภาพ',
                  pressFunc: () {
                    Get.back(); //Navigator.pop
                    Get.to(TakePhotoId())?.then((value) => readUserInfo());
                  },
                ));
          }
        }
      },
    );

    setState(() {});
  }

  Widget showDrawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bird.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      currentAccountPicture: GestureDetector(
        onTap: () {
          moveToEditProfile();
        },
        child: CircularProfileAvatar(
          '$userImge',
          borderWidth: 4.0,
        ),
      ),
      accountName: Text('$nameUser'),
      accountEmail: Text('$userEmail'),
    );
  }

  void moveToEditProfile() {
    MaterialPageRoute materialPageRoute = MaterialPageRoute(
      builder: (context) => AddInformationUser(),
    );
    Navigator.push(context, materialPageRoute).then((value) => readUserInfo());
  }

  Future<Null> signOutProcess() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    //exit(0);
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => SignIn());
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Future<Null> launchURL() async {
    final url = 'https://www.dissrecs.com/index.php';
    await launch(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Unable to open URL $url');
      // throw 'Could not launch $url';
    }
  }

  Future<Null> deleteAllData() async {
    await SQLiteHelper().deleteAllData().then((value) => signOutProcess());
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              showDrawerHeader(),
              ListTile(
                  leading: Icon(Icons.person_pin),
                  title: Text('ข้อมูลส่วนตัว'),
                  subtitle: Text(
                    'ข้อมูลส่วนตัวของพนักงาน',
                    style: TextStyle(fontSize: 10),
                  ),
                  trailing: Icon(Icons.arrow_right),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => InformationUser()));
                  }),
              ListTile(
                  leading: Icon(Icons.help),
                  title: Text('ช่วยเหลือ'),
                  subtitle: Text(
                    'ช่วยเหลือ คู่มือต่าง',
                    style: TextStyle(fontSize: 10),
                  ),
                  trailing: Icon(Icons.arrow_right),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HelpPage()));
                  }),
              ListTile(
                  leading: Icon(Icons.download_rounded),
                  title: Text('ดึงข้อมูล'),
                  subtitle: Text(
                    'เปิดเว็ปไซต์บริษัท,แหล่งข้อมูล',
                    style: TextStyle(fontSize: 10),
                  ),
                  trailing: Icon(Icons.arrow_right),
                  onTap: () {
                    Navigator.pop(context);
                    launchURL();
                  }),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('ออกจากระบบ'),
                subtitle: Text(
                  'ออกจากระบบ',
                  style: TextStyle(fontSize: 10),
                ),
                onTap: () {
                  //signOutProcess();
                  //deleteAllData();
                  confirmDialog();
                },
              ),
              Divider(),
              ListTile(
                title: Text('Version อัพเดทล่าสุด'),
                subtitle: Text(
                  'อัพเดทเมื่อ 31 กรกฎาคม 2568',
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Center(
            child: Row(
              children: [
                ShowText(
                  text: title[selectedIndex],
                  textStyle: MyConstant().h2Style(),
                ),
                Text(
                  // online ? ' ออนไลน์' : ' ออฟไลน์',
                  '',
                  style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: online ? Colors.green : Colors.red),
                ),
              ],
            ),
          ),
          actions: [
            // selectedIndex == 0
            //     ? Switch(
            //         value: online,
            //         onChanged: (velue) {
            //           setState(() {
            //             online = velue;
            //             cratePages();
            //           });
            //         })
            //     : const SizedBox(),
            InkWell(
              onTap: () {
                moveToEditProfile();
              },
              child: CircularProfileAvatar(
                '$userImge',
                borderWidth: 2,
                radius: 28,
                elevation: 5.0,
                cacheImage: true,
                foregroundColor: Colors.brown.withOpacity(0.5),
                imageFit: BoxFit.cover,
              ),
            )
          ],
        ),
        body: pages[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Color(0xff6a1b9a),
            selectedItemColor: Colors.white,
            unselectedItemColor: Color(0xffce93d8),
            showUnselectedLabels: true,
            currentIndex: selectedIndex,
            onTap: (int index) {
              if (online) {
                setState(() {
                  selectedIndex = index;
                });
              } else {
                normalDialog(context, 'กรุณาเปิดโหมด ออนไลน์ ก่อนครับ');
              }
            },
            items: [
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.notifications_active),
              //   label: 'แจ้งเตือน',
              // ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: 'งดจ่ายไฟ',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'ประวัติ',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'หน้าหลัก',
              ),
            ]),
      ),
    );
  }

  Future<Null> confirmDialog() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Column(
          children: [
            Text(
              'ยืนยันออกจากระบบ',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
              ),
            ),
            Text(
              'เมื่อกดยื่นยันข้อมูลจะถูกลบออกจากเครื่อง',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.normal,
              ),
            ),
          ],
        ),
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'ปิด',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                      deleteAllData();
                      signOutProcess();
                    },
                    child: Text(
                      'ยืนยัน',
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
