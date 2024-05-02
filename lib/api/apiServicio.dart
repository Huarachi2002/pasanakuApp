import 'package:dio/dio.dart';

final dio = Dio(
  BaseOptions(
      baseUrl: 'http://192.168.100.17:3001/api',
      // baseUrl: 'http://www.ficct.uagrm.edu.bo:3001/api'
  ),
);

final dioUpdate = Dio(
  BaseOptions(
    baseUrl: 'http://192.168.100.17:3001/uploads/player',//"/idplayer/pathQr"
    // baseUrl: 'http://www.ficct.uagrm.edu.bo:3001/uploads/player'
  )
);