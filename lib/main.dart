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
            print('設定値読込終了');
            return MyHomePage(title: _routeInfo.routeName[0]);
          }else{
            print('設定値読込開始');
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

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  
  void _incrementCounter() {
    
    _routeInfo.abbreviation[0];
    _lineInfo.latitude[0];

    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: _routeInfo.routeColor[0],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
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
                        color: Colors.white,
                        fontSize: 17.0
                      ),
                  ),
                  decoration: BoxDecoration(color: _routeInfo.routeColor[0]),
                ),
                ListTile(
                  title: Text('路線設定'),
                  onTap:(){
                    Navigator.pop(context);
                  }
                ),
                ListTile(
                  title: Text('読込間隔設定'),
                  onTap:(){
                    Navigator.pop(context);
                  }
                ),
                ListTile(
                  title: Text('ダークモード'),
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
