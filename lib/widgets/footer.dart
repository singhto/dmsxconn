import 'package:flutter/material.dart';

class Footer extends StatefulWidget {
  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  String companyName = 'สดุดียี่สิบสาม';

  void changeCompanyName() {
    setState(() {
      companyName = 'Flutter';
    });
  }

  @override
  void initState() {
    super.initState();
    //print('int foodter');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$companyName', style: Theme.of(context).textTheme.headline5,),
        ElevatedButton(
          onPressed: changeCompanyName,
          child: Text('click Me'),
        ),
      ],
    );
  }
}
