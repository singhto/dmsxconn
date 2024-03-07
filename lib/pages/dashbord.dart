import 'package:flutter/material.dart';
import 'package:psinsx/pages/help_page.dart';
import 'package:psinsx/pages/information_user.dart';
import 'package:psinsx/pages/search_dmsx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Dashbord extends StatefulWidget {
  Dashbord({Key key}) : super(key: key);

  @override
  _DashbordState createState() => _DashbordState();
}

class _DashbordState extends State<Dashbord> {
  String nameUser;

  @override
  void initState() {
    super.initState();
    findUser();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString('staffname');
    });
  }

  Future<Null> launchURL() async {
    final url = 'https://www.pea23.com/index.php';
    await launch(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Unable to open URL $url');
      // throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverGrid.count(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchDmsx(),
                      ));
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Color.fromARGB(255, 174, 5, 240),
                  child: Column(
                    children: [
                      Icon(
                        Icons.search,
                        size: 100,
                      ),
                      Text("ค้นหา"),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HelpPage(),
                      ));
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Color.fromARGB(255, 29, 200, 66),
                  child: Column(
                    children: [
                      Icon(
                        Icons.book,
                        size: 100,
                      ),
                      Text('คู่มือ'),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InformationUser(),
                      ));
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Color.fromARGB(255, 76, 64, 33),
                  child: Column(
                    children: [
                      Icon(
                        Icons.book,
                        size: 100,
                      ),
                      Text('ข้อมูลส่วนตัว'),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  launchURL();
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Color.fromARGB(255, 248, 193, 54),
                  child: Column(
                    children: [
                      Icon(
                        Icons.money_off,
                        size: 100,
                      ),
                      Text('รายได้'),
                    ],
                  ),
                ),
              ),

                 InkWell(
                onTap: () {
                  launchURL();
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Color.fromARGB(255, 29, 187, 195),
                  child: Column(
                    children: [
                      Icon(
                        Icons.earbuds,
                        size: 100,
                      ),
                      Text('เว็ปไซต์'),
                    ],
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.all(8),
                color: Color.fromARGB(255, 177, 47, 220),
                child: Column(
                  children: [
                    Icon(
                      Icons.settings,
                      size: 100,
                    ),
                    Text('Veision 1.0.2'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
