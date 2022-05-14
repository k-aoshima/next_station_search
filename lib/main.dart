import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:next_station_search/settings/app_settings.dart';
import 'package:next_station_search/read_interval_setting_screen.dart';
import 'settings/routeInfo.dart';
import 'settings/lineInfo.dart';
import 'dart:async';
import 'route_setting_screen.dart';
import 'package:next_station_search/widget/widget_utils.dart';
import 'package:next_station_search/settings/lineInfo.dart';
import 'package:next_station_search/settings/routeInfo.dart';
import 'package:next_station_search/model/position.dart';


RouteInfo _routeInfo = RouteInfo();
LineInfo _lineInfo = LineInfo();

void main(){

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);
  
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  
  const MyApp({Key? key}) : super(key: key);
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme:ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: FutureBuilder(
        future:_getFutureData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData && getData){
            print('Exit Load Settings');
            return MyHomePage(title: _routeInfo.routeName[0]);
          }else{
            print('Start Load Settings');
            return createProgressIndicator();
          }
        },
      ),
       
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState(); 
}

int selectedLine = 0;
bool getData = false;

Future _getFutureData() async {
  
  if(!getData){
    await _routeInfo.getCsvData();
    selectedLine = await GetSelectedLine();
    await _lineInfo.getCsvData(_routeInfo.csvFileName[selectedLine]); 
    getData = true;
  }

  return Future.value('');
}



class _MyHomePageState extends State<MyHomePage> {

  //int _nearStationNum = 0;
  List<String> _setStationName = [];
  bool _isUpList = false;

  @override
  void initState(){
    _getDistance();
    super.initState();
    
  }

  void _setStation(int nearestStationNum){

    _setStationName.clear();

    setState(() {
      if(_isUpList){
        if(nearestStationNum - 2 >= 0){
          _setStationName.add(_lineInfo.stationName[nearestStationNum - 2]);
        }
        else{
          _setStationName.add("");
        }
        
        if(nearestStationNum -1 >= 0){
            _setStationName.add(_lineInfo.stationName[nearestStationNum - 1]);
        }
        else{
          _setStationName.add("");
        }
        
        _setStationName.add(_lineInfo.stationName[nearestStationNum]);

        if(nearestStationNum + 1 < _lineInfo.stationName.length){
          _setStationName.add(_lineInfo.stationName[nearestStationNum + 1]);
        }
        else{
          _setStationName.add("");
        }

        if(nearestStationNum + 2 < _lineInfo.stationName.length){
          _setStationName.add(_lineInfo.stationName[nearestStationNum + 2]);
        }
        else{
          _setStationName.add("");
        }

      }
      else{
        if(nearestStationNum + 2 < _lineInfo.stationName.length){
          _setStationName.add(_lineInfo.stationName[nearestStationNum + 2]);
        }
        else{
          _setStationName.add("");
        }
        
        if(nearestStationNum + 1 < _lineInfo.stationName.length){
          _setStationName.add(_lineInfo.stationName[nearestStationNum + 1]);
        }
        else{
          _setStationName.add("");
        }

        _setStationName.add(_lineInfo.stationName[nearestStationNum]);
        
        if(nearestStationNum -1 >= 0){
            _setStationName.add(_lineInfo.stationName[nearestStationNum - 1]);
        }
        else{
          _setStationName.add("");
        }

        if(nearestStationNum - 2 >= 0){
          _setStationName.add(_lineInfo.stationName[nearestStationNum - 2]);
        }
        else{
          _setStationName.add("");
        }
      }
    });
    
  }

  Future<void> _getDistance() async
  {
    double distance;
    Map<String, double> dic = {};

    int ret = 0;

    for(int i = 0; i < _lineInfo.lineNo.length; i++){
      
      distance = await DistanceInMeters(
          double.parse(_lineInfo.latitude[i]),
          double.parse(_lineInfo.longitude[i])
        );
      dic[_lineInfo.stationName[i]] = distance;
    }

    distance = dic.values.reduce(min);

    for (var item in dic.keys) {
      if(dic[item] == distance){
        break;
      }
      ret++;
    }
  
    setState(() {
      _setStation(ret);
    });
  }

  double _nextStationFontSize(String nextStationName){

    if(nextStationName.length > 3){
      return 40;
    }
    else{
      return 50;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsetsDirectional.fromSTEB(50, 0, 10, 0),
              child: Stack(
                alignment: const Alignment(0, 0),
                children: [
                  Container(
                    width: 40,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  Text(_routeInfo.abbreviation[0],
                    style: TextStyle(fontFamily: "BIZUDPGothic", fontSize: 15, fontWeight: FontWeight.bold, color: _routeInfo.routeColor[0])
                  ),
                ],
              )
            ),
            Text(
              widget.title,
              style: TextStyle(fontFamily: "BIZUDPGothic", fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: _routeInfo.routeColor[0],
        
      ),
      body: SafeArea(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                
                children: [
                  Stack(
                    alignment: Alignment(-4, 0.05),
                    children: [
                      CustomPaint(
                        painter: TrianglePainter(_routeInfo.routeColor[0]),
                        child: Container(
                            height: 60,
                            width: 45,
                          )
                      ),
                      const Text(
                        'Next',
                        style: const TextStyle(fontFamily: "BIZUDPGothic", fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                    child: CustomPaint(
                      painter: SquarePainter(_routeInfo.routeColor[0]),
                      child: Container(
                        height: 75,
                        width: 5,
                      )
                    ),
                  ),
                  
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 55),
                        child: 
                        Text(
                          _setStationName.isNotEmpty? _setStationName[0] : _lineInfo.stationName[0],
                          style: const TextStyle(fontFamily: "BIZUDPGothic", fontSize: 28)
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 55),
                        child: 
                        Text(
                          _setStationName.isNotEmpty? _setStationName[1] : _lineInfo.stationName[1],
                          style: const TextStyle(fontFamily: "BIZUDPGothic", fontSize: 28)
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                        child: 
                        Text(
                          _routeInfo.routeName[0],
                          style: const TextStyle(fontFamily: "BIZUDPGothic", fontSize: 15)
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 55),
                        child: 
                        Text(
                          _setStationName.isNotEmpty? _setStationName[2] : _lineInfo.stationName[2],
                          style: TextStyle(fontFamily: "BIZUDPGothic", fontSize: _nextStationFontSize(_setStationName.isNotEmpty? _setStationName[2] : _lineInfo.stationName[2]))
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 55),
                        child: 
                        Text(
                          _setStationName.isNotEmpty? _setStationName[3] : _lineInfo.stationName[3],
                          style: const TextStyle(fontFamily: "BIZUDPGothic", fontSize: 28)
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        child: 
                        Text(
                          _setStationName.isNotEmpty? _setStationName[4] : _lineInfo.stationName[4],
                          style: const TextStyle(fontFamily: "BIZUDPGothic", fontSize: 28)
                        ),
                      ),
                    ],
                  )
                  
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: (){
                    setState(() {
                      _isUpList = true;
                      _getDistance();
                    });
                  }, 
                  icon: const Icon(Icons.arrow_drop_up),
                  iconSize: 60.0,
                  color: _isUpList? Color.fromARGB(98, 0, 0, 0) : _routeInfo.routeColor[0],
                ),
                IconButton(
                  onPressed: (){
                    setState(() {
                      _isUpList = false;
                      _getDistance();
                    });
                  },
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 60.0,
                  color: _isUpList? _routeInfo.routeColor[0] : Color.fromARGB(98, 0, 0, 0),
                ),
              ],
            ),
          ],
        ),
      ),
        
      drawer: 
        SizedBox(
          width: 200,
          child:Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: _routeInfo.routeColor[0]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(padding: EdgeInsetsDirectional.fromSTEB(0, 0, 70, 10),
                        child: Stack(
                          alignment: const Alignment(0, 0),
                          children: [
                            Container(
                              width: 60,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            Text(_routeInfo.abbreviation[0],
                              style: TextStyle(fontFamily: "BIZUDPGothic", fontSize: 20, fontWeight: FontWeight.bold, color: _routeInfo.routeColor[0])
                            ),
                          ],
                        )
                      ),
                      Text(
                        '路線：' + _routeInfo.routeName[0],
                        style: const TextStyle(
                          fontFamily: "BIZUDPGothic",
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 17.0
                        ),
                      ),  
                    ],
                  ),
                ),
                
                ListTile(
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 15.0,
                  ),
                  title: const Text(
                    '路線設定',
                    style: TextStyle(
                    fontFamily: "BIZUDPGothic"
                  )),
                  onTap:(){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RouteSettingScreen(_routeInfo))
                    );
                  }
                ),
                ListTile(
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 15.0,
                  ),
                  title: const Text(
                    '読込間隔設定',
                    style: TextStyle(
                    fontFamily: "BIZUDPGothic"
                  )),
                  onTap:(){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ReadIntervalSettingScreen(_routeInfo))
                    );
                  }
                ),
              ],
            ),
          ),
        ),
        
      floatingActionButton: FloatingActionButton(
        backgroundColor: _routeInfo.routeColor[0],
        onPressed: _getDistance,
        tooltip: 'Increment',
        child: const Icon(
            Icons.gps_fixed,
            color: Colors.white,
            size: 35.0,
          )
      ),
    );
  }
}
