import 'dart:math';
import 'package:flutter/foundation.dart';
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
        future:_startAppSetData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData && getData){
            if (kDebugMode) {
              print('Exit Load Settings');
            }
            return const MyHomePage();
          }else{
            if (kDebugMode) {
              print('Start Load Settings');
            }
            return createProgressIndicator();
          }
        },
      ),
       
    );
  }
}


class MyHomePage extends StatefulWidget {

  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState(); 
}

int selectedRoute = 0;
bool getData = false;

Future _startAppSetData() async {
  
  if(!getData){
    await _routeInfo.getCsvData();
    await getSettingData();
    await _lineInfo.getCsvData(_routeInfo.csvFileName[settings.selectedRoute]); 
    getData = true;
  }

  return Future.value('');
}

class _MyHomePageState extends State<MyHomePage> {

  
  final List<String> _setStationName = [];
  
  bool _isUpList = false;
  int _selectedRoute = 0;
  int _loopSec = 60;
  
  Timer? _timer;
  

  @override
  void initState(){
    if(settings.selectedLoopTime > _loopSec){
      _loopSec = settings.selectedLoopTime;  
    }
    _selectedRoute = settings.selectedRoute;

    _getDistance();
    _timer ??= Timer.periodic(Duration(seconds: _loopSec), _onTimer);
    super.initState(); 
  }

  void _onTimer(Timer timer){
    var now = DateTime.now();
    if (kDebugMode) {
      print(now.toString() + ' : loopGPS');
    }
    _getDistance();
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

  Future _getFutureData(int select) async {
    _lineInfo = LineInfo();
    await _lineInfo.getCsvData(_routeInfo.csvFileName[select]); 
    _selectedRoute = select;
    _getDistance();
    return Future.value('');
  }

  Future<void> _getDistance() async
  {
    double distance;
    Map<String, double> dic = {};

    int ret = 0;

    for(int i = 0; i < _lineInfo.lineNo.length; i++){
      
      distance = await distanceInMeters(
          double.parse(_lineInfo.latitude[i]),
          double.parse(_lineInfo.longitude[i])
        );
      dic[_lineInfo.stationName[i]] = distance;
    }

    distance = dic.values.reduce(min);

    bool seachCompleate = false;

    while(!seachCompleate){

      for (var item in dic.keys) {
        // リストの最小値がキーとマッチすれば終了条件に入る
        if(dic[item] == distance){
          // 現在地が50m以上離れていれば駅から離れていると見なし、次の駅を再検索
          // また、現在駅が終点の場合にはインクリメントを追加しない
          if((distance >= 50.0) && (ret > 0 && ret < _lineInfo.stationName.length)){
            // 現在駅から近い駅を二つ取得
            double beforeNearStation1 = await getNearStation1(ret);
            double beforeNearStation2 = await getNearStation2(ret);

            // 進んだ先が分かるように3秒待機 
            Future.delayed(const Duration(seconds: 3));

            double afterNearStation1 = await getNearStation1(ret);
            double afterNearStation2 = await getNearStation2(ret);

            // 差分を取得
            double diffStation1 = afterNearStation1 - beforeNearStation1;
            double diffStation2 = afterNearStation2 - beforeNearStation2;

            // 近付いている駅は差分が少ない方
            if(diffStation1 < diffStation2){
              ret++;
            }
            else if(diffStation2 < diffStation1){
              ret--;
            }
            // その場に止まっていれば、現在駅を次駅とする

            seachCompleate = true;
            break;
          }
          seachCompleate = true;
          break;
        }
        ret++;
      }
    }
  
    setState(() {
      _setStation(ret);
    });
  }

  Future<double> getNearStation1(int ret) async{
    double nearStation1 = 0;
    if(ret + 1 > _lineInfo.stationName.length){
      nearStation1 = await distanceInMeters(
        double.parse(_lineInfo.latitude[ret + 1]),
        double.parse(_lineInfo.longitude[ret + 1])
      );
    }

    return nearStation1;
  }

  Future<double> getNearStation2(int ret) async{
    double nearStation2 = 0;
    if(ret - 1 < _lineInfo.stationName.length){
      nearStation2 = await distanceInMeters(
        double.parse(_lineInfo.latitude[ret - 1]),
        double.parse(_lineInfo.longitude[ret - 1])
      );
    }

    return nearStation2;
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
            Padding(padding: const EdgeInsetsDirectional.fromSTEB(40, 0, 10, 0),
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
                  Text(_routeInfo.abbreviation[_selectedRoute],
                    style: TextStyle(fontFamily: "BIZUDPGothic", fontSize: 15, fontWeight: FontWeight.bold, color: _routeInfo.routeColor[_selectedRoute])
                  ),
                ],
              )
            ),
            Text(
              _routeInfo.routeName[_selectedRoute],
              style: const TextStyle(fontFamily: "BIZUDPGothic", fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: _routeInfo.routeColor[_selectedRoute],
        
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
                    alignment: const Alignment(-4, 0.05),
                    children: [
                      CustomPaint(
                        painter: TrianglePainter(_routeInfo.routeColor[_selectedRoute]),
                        child: const SizedBox(
                            height: 60,
                            width: 45,
                          )
                      ),
                      const Text(
                        'Next',
                        style: TextStyle(fontFamily: "BIZUDPGothic", fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                    child: CustomPaint(
                      painter: SquarePainter(_routeInfo.routeColor[_selectedRoute]),
                      child: const SizedBox(
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
                          _routeInfo.routeName[_selectedRoute],
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
                  color: _isUpList? const Color.fromARGB(98, 0, 0, 0) : _routeInfo.routeColor[_selectedRoute],
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
                  color: _isUpList? _routeInfo.routeColor[_selectedRoute] : const Color.fromARGB(98, 0, 0, 0),
                ),
              ],
            ),
          ],
        ),
      ),
        
      drawer: 
        SizedBox(
          width: 180,
          child:Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: _routeInfo.routeColor[_selectedRoute]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 70, 10),
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
                            Text(_routeInfo.abbreviation[_selectedRoute],
                              style: TextStyle(fontFamily: "BIZUDPGothic", fontSize: 20, fontWeight: FontWeight.bold, color: _routeInfo.routeColor[_selectedRoute])
                            ),
                          ],
                        )
                      ),
                      Text(
                        '路線：' + _routeInfo.routeName[_selectedRoute],
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
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 15.0,
                  ),
                  title: const Text(
                    '路線設定',
                    style: TextStyle(
                    fontFamily: "BIZUDPGothic"
                  )),
                  onTap:() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RouteSettingScreen(_routeInfo, _selectedRoute)),
                    ).then((value) => {
                      setSelectedRoute(value),
                      _getFutureData(value)
                    });
                  }
                ),
                ListTile(
                  trailing: const Icon(
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
                      MaterialPageRoute(builder: (context) => ReadIntervalSettingScreen(_routeInfo, _loopSec)),
                    ).then((value) => {
                      setState(() {
                        setSelectedLoopTime(value);
                        _loopSec = value;
                        _timer?.cancel();
                        if(_timer != null){
                          _timer = null;
                        }
                        _timer = Timer.periodic(Duration(seconds: _loopSec), _onTimer);
                      })
                    });
                  }
                ),
              ],
            ),
          ),
        ),
        
      floatingActionButton: FloatingActionButton(
        backgroundColor: _routeInfo.routeColor[_selectedRoute],
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
