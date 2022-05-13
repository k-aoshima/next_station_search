import 'package:flutter/material.dart';
import 'settings/routeInfo.dart';

class ReadIntervalSettingScreen extends StatefulWidget{

  final RouteInfo routeInfo;
  ReadIntervalSettingScreen(this.routeInfo);

  @override
  _ReadIntervalSettingScreenState createState()=> _ReadIntervalSettingScreenState(this.routeInfo);
}

class _ReadIntervalSettingScreenState extends State<ReadIntervalSettingScreen>{

  final RouteInfo routeInfo;
  var _selectedIndex = 0;

  List<String> timeSettingArray = ['10秒' ,'15秒', '30秒', '1分', '5分', '10分'];

  _ReadIntervalSettingScreenState(this.routeInfo);

  @override
  Widget build(BuildContext context){
    
    return Scaffold(
      appBar: AppBar(
        title: 
        const Text(
          '読込間隔設定',
          style: TextStyle(
          fontFamily: "BIZUDPGothic"
        )),
        backgroundColor: Color.fromARGB(180, 18, 16, 16),
      ),
      body: ListView(
        children: [
          for(var i = 0; i < timeSettingArray.length; i++)
            RadioListTile(
              value: i,
              groupValue: _selectedIndex,
              title: Text(timeSettingArray[i]),
              onChanged: (value) => _onRadioSelected(value),
            ),
        ],
      )
    );
    
  }

  _onRadioSelected(value) 
  {
    setState(() {
      _selectedIndex = value;
    });
  }
}