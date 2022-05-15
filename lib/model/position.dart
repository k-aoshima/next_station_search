import 'package:geolocator/geolocator.dart';

/// デバイスの現在位置を決定する。
/// 位置情報サービスが有効でない場合、または許可されていない場合。
/// エラーを返します
Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // 位置情報サービスが有効かどうかをテストします。
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // 位置情報サービスが有効でない場合、続行できません。
    // 位置情報にアクセスし、ユーザーに対して 
    // 位置情報サービスを有効にするようアプリに要請する。
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    // ユーザーに位置情報を許可してもらうよう促す
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      // 拒否された場合エラーを返す
      return Future.error('Location permissions are denied');
    }
  }
  
  // 永久に拒否されている場合のエラーを返す
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  // ここまでたどり着くと、位置情報に対しての権限が許可されているということなので
  // デバイスの位置情報を返す。
  return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
}

Future<double> distanceInMeters(double endLatitude, double endLongitude) async{

  Position position = await determinePosition();
  double startLatitude = position.latitude;
  double startLongitude = position.longitude;

  return Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);
}