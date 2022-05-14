import 'package:flutter/material.dart';
import 'settings/routeInfo.dart';

  String TEN_SECONDS = '10秒';
  String FIFTEEN_SECONDS = '15秒';
  String THIRTY_SECONDS = '30秒';
  String ONE_MINUTES = '1分';
  String FIVE_MINUTES = '5分';
  String TEN_MINUTES = '10分';

class ReadIntervalSettingScreen extends StatefulWidget{

  final RouteInfo routeInfo;
  final int loopSec;
  ReadIntervalSettingScreen(this.routeInfo, this.loopSec);

  @override
  _ReadIntervalSettingScreenState createState()=> _ReadIntervalSettingScreenState(this.routeInfo, this.loopSec);
}

class _ReadIntervalSettingScreenState extends State<ReadIntervalSettingScreen>{

  final RouteInfo routeInfo;
  final int loopSec;
  var _selectTime = 0;
  

  List<String> timeSettingArray = [
                                    TEN_SECONDS, 
                                    FIFTEEN_SECONDS, 
                                    THIRTY_SECONDS, 
                                    ONE_MINUTES,
                                    FIVE_MINUTES, 
                                    TEN_MINUTES
                                  ];

  _ReadIntervalSettingScreenState(this.routeInfo, this.loopSec);

  @override
  void initState(){
    _selectTime = loopSecToSelectedTime(loopSec);
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    
    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context, selectTimeToloopSec(_selectTime));
        return Future.value(false);
      },
      child:Scaffold(
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
                groupValue: _selectTime,
                title: Text(timeSettingArray[i]),
                onChanged: (value) {
                  setState(() {
                    _selectTime = i;
                  });
                },
              ),
          ],
        )
      )
    );
  }

  int selectTimeToloopSec(int selectTime){
    switch(selectTime){
      case 0:
        return 10;
      case 1:
        return 15;
      case 2:
        return 30;
      case 3:
        return 60;
      case 4:
        return 300;
      case 5:
        return 600; 
      default:
        return 60;
    }
  }

  int loopSecToSelectedTime(int loopSec){
    switch(loopSec){
      case 10:
        return 0;
      case 15:
        return 1;
      case 30:
        return 2;
      case 60:
        return 3;
      case 300:
        return 4;
      case 600:
        return 5;
      default:
        return 3;
    }
  }



}