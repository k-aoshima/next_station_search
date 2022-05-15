import 'package:flutter/material.dart';
import 'settings/routeInfo.dart';

class RouteSettingScreen extends StatefulWidget{
  
  final RouteInfo routeInfo;
  final int selectedIndex;

  RouteSettingScreen(this.routeInfo, this.selectedIndex);

  @override
  _RouteSettingScreenState createState()=> _RouteSettingScreenState(this.routeInfo, this.selectedIndex);

}

class _RouteSettingScreenState extends State<RouteSettingScreen>{

  final RouteInfo routeInfo;
  final int selectedIndex;
  int selectIndex = 0;

  _RouteSettingScreenState(this.routeInfo, this.selectedIndex);

  @override
  void initState(){
    selectIndex = selectedIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    
    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context, selectIndex);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: 
          const Text(
            '路線設定',
            style: TextStyle(
            fontFamily: "BIZUDPGothic"
          )),
          backgroundColor: const Color.fromARGB(180, 18, 16, 16),
        ),
        body: ListView(
          children: [
            for(var i = 0; i < routeInfo.routeName.length; i++)
              RadioListTile(
                value: i,
                groupValue: selectIndex,
                title: Text(routeInfo.routeName[i]),
                onChanged: (value){
                  setState(() {
                    selectIndex = i;
                  });
                }
              ),
          ],
        )
      ),
    );
  }
}