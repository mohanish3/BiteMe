import 'dart:async';
import 'dart:io';

import 'package:http/http.dart';

class ServerFunctions {
  static const serverIp = 'http://192.168.43.41:3000';

  static dynamic getRequest(List<String> pathList, List<List<String>> args) async {
    String urlRequest = serverIp;

    for (var path in pathList) {
      urlRequest = urlRequest + '/' + path;
    }

    for (int i = 0; i < args.length; i++) {
      if (i == 0)
        urlRequest = urlRequest + '?' + args[i][0] + '=' + args[i][1];
      else
        urlRequest = urlRequest + '&' + args[i][0] + '=' + args[i][1];
    }

    try {
      Response response = await get(urlRequest);
      if (response.statusCode == 200)
        return response.body;
      else
        return null;
    } on TimeoutException catch (_) {
      return null;
    } on SocketException catch (_) {
      return null;
    }
  }

  static dynamic postRequest(
      List<String> pathList, List<List<String>> args) async {
    String urlRequest = serverIp;

    for (var path in pathList) {
      urlRequest = urlRequest + '/' + path;
    }

    for (int i = 0; i < args.length; i++) {
      if (i == 0)
        urlRequest = urlRequest + '?' + args[i][0] + '=' + args[i][1];
      else
        urlRequest = urlRequest + '&' + args[i][0] + '=' + args[i][1];
    }
    Uri uri = Uri.parse(urlRequest);
    print(uri.path);
    print(uri.port);
    print(uri.authority);
    print(uri.queryParameters);
    Response response = await post(uri);
    try {
      if (response.statusCode == 200)
        return response.body;
      else
        return null;
    } on TimeoutException catch (_) {
      return null;
    } on SocketException catch (_) {
      return null;
    }
  }
}
