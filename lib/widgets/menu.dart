import 'package:flutter/material.dart';
import 'package:psinsx/pages/signin_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
 

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.60,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            showDrawerHeader(),
            ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                subtitle: Text(
                  'หน้าหลัก',
                  style: TextStyle(fontSize: 8),
                ),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  setState(() {
                    
                  });
                  Navigator.pop(context);
                }),
            ListTile(
                leading: Icon(Icons.image_search),
                title: Text('INSx'),
                subtitle: Text(
                  'งานแจ้งเตือน',
                  style: TextStyle(fontSize: 8),
                ),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  setState(() {
                
                  });
                  Navigator.pop(context);
                }),
            ListTile(
                leading: Icon(Icons.image_search),
                title: Text('DMSx'),
                subtitle: Text(
                  'งานงดจ่ายไฟ',
                  style: TextStyle(fontSize: 8),
                ),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  setState(() {
                
                  });
                  Navigator.pop(context);
                }),
            ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                subtitle: Text(
                  'ตั้งค่า',
                  style: TextStyle(fontSize: 8),
                ),
                trailing: Icon(Icons.arrow_right),
                onTap: () {}),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('SignOut'),
              subtitle: Text(
                'ออกจากระบบ',
                style: TextStyle(fontSize: 8),
              ),
              onTap: () => signOutProcess(),
            ),        
          ],
        ),
      ),
    );
  }

  Future<Null> signOutProcess() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    //exit(0);
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => SignIn());
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Widget showDrawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bird.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      currentAccountPicture: Icon(
        Icons.person,
        size: 80,
        color: Colors.white,
      ),
      accountName: Text('User'),
      accountEmail: Text('Emamil'),
    );
  }
}
