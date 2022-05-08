import 'package:flutter/material.dart';
import 'routeInfo.dart';
import 'lineInfo.dart';
import "dart:async";


RouteInfo _routeInfo = RouteInfo();
LineInfo _lineInfo = LineInfo();

void main(){
  runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future:_getFutureData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData){
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

Future _getFutureData() async {
  await _routeInfo.getCsvData();
  await _lineInfo.getCsvData(_routeInfo.csvFileName[0]);
  return Future.value('');
}

///画面上にローディングアニメーションを表示する
Widget createProgressIndicator() {
  return Container(
    alignment: Alignment.center,
    child: const CircularProgressIndicator(
      color: Colors.blue,
    )
  );
}

class SquarePainter extends CustomPainter {
 
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
 
    paint.color = _routeInfo.routeColor[0];
    var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);
  
  }
 
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class TrianglePainter extends CustomPainter {
 
  @override
  void paint(Canvas canvas, Size size) {
    
    Paint fillWithBluePaint = Paint()
      ..color = _routeInfo.routeColor[0];
    
    var path = Path();
    path.moveTo(size.width / 3, size.height / 3);
    path.lineTo(size.width / 3, size.height / 2 * 1.5);
    path.lineTo(size.width / 4 * 3, size.height / 4 * 2.1);
    path.close();
    canvas.drawPath(path, fillWithBluePaint);

    var paint = Paint();
    paint.color = _routeInfo.routeColor[0];
    var rect = Rect.fromLTWH(-size.width / 1.5, size.height / 3, size.width, size.height / 2.4);
    canvas.drawRect(rect, paint);
  }
 
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  
  void _incrementCounter() {
    
    _routeInfo.abbreviation[0];
    _lineInfo.latitude[0];

    setState(() {
      _counter++;
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
        title: Text(
          widget.title,
          style: TextStyle(fontFamily: "BIZUDPGothic", fontSize: 20, fontWeight: FontWeight.bold),
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
                        painter: TrianglePainter(),
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
                      painter: SquarePainter(),
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
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 30),
                        child: 
                        Text(
                          _lineInfo.stationName[0],
                          style: const TextStyle(fontFamily: "BIZUDPGothic", fontSize: 28)
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 30),
                        child: 
                        Text(
                          _lineInfo.stationName[1],
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
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 30),
                        child: 
                        Text(
                          _lineInfo.stationName[20],
                          style: TextStyle(fontFamily: "BIZUDPGothic", fontSize: _nextStationFontSize(_lineInfo.stationName[2]))
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 30),
                        child: 
                        Text(
                          _lineInfo.stationName[3],
                          style: const TextStyle(fontFamily: "BIZUDPGothic", fontSize: 28)
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        child: 
                        Text(
                          _lineInfo.stationName[4],
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
                  onPressed: (){}, 
                  icon: const Icon(Icons.arrow_drop_up),
                  iconSize: 60.0,
                  color: _routeInfo.routeColor[0],
                ),
                IconButton(
                  onPressed: (){},
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 60.0,
                  color: _routeInfo.routeColor[0],
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
                  child: Text(
                    '路線：' + _routeInfo.routeName[0],
                    style: const TextStyle(
                      fontFamily: "BIZUDPGothic",
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 17.0
                    ),
                  ),
                  decoration: BoxDecoration(color: _routeInfo.routeColor[0]),
                ),
                ListTile(
                  
                  title: const Text(
                    '路線設定',
                    style: TextStyle(
                    fontFamily: "BIZUDPGothic"
                  )),
                  onTap:(){
                    Navigator.pop(context);
                  }
                ),
                ListTile(
                  title: const Text(
                    '読込間隔設定',
                    style: TextStyle(
                    fontFamily: "BIZUDPGothic"
                  )),
                  onTap:(){
                    Navigator.pop(context);
                  }
                ),
                ListTile(
                  title: const Text(
                    'ダークモード',
                    style: TextStyle(
                    fontFamily: "BIZUDPGothic"
                  )),
                  onTap:(){
                    Navigator.pop(context);
                  }
                ),
              ],
            ),
          ),
        ),
        
      floatingActionButton: FloatingActionButton(
        backgroundColor: _routeInfo.routeColor[0],
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(
            Icons.gps_fixed,
            size: 35.0,
          )
      ),
    );
  }
}
