import 'dart:io';

import 'package:dio/dio.dart';
import 'package:html/parser.dart' show parse;
import 'package:openfcu/src/util.dart';

class AspStateInterceptor extends Interceptor {
  final Map<String, AspState> _map = {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('request: ${options.uri.page}');
    if (options.method == 'POST' &&
        _map.containsKey(options.uri.page) &&
        options.contentType == 'application/x-www-form-urlencoded') {
      print("Sent ASP state");
      final state = _map[options.uri.page]!;
      final data = options.data as Map<String, dynamic>;
      data['__VIEWSTATE'] = state.vs;
      data['__VIEWSTATEGENERATOR'] = state.vsg;
      data['__EVENTVALIDATION'] = state.ev;
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('response: ${response.realUri.page}');
    if (response.headers.value(HttpHeaders.contentTypeHeader) == 'text/html') {
      final doc = parse(response.data);
      final vs = doc.getElementById('__VIEWSTATE')?.attributes['value'];
      final vsg = doc.getElementById('__VIEWSTATEGENERATOR')?.attributes['value'];
      final ev = doc.getElementById('__EVENTVALIDATION')?.attributes['value'];
      if (vs != null && vsg != null && ev != null) {
        print("Extracted ASP state");
        _map[response.realUri.page] = AspState(vs, vsg, ev);
      }
    }
    handler.next(response);
  }
}

class AspState {
  final String vs;
  final String vsg;
  final String ev;

  const AspState(this.vs, this.vsg, this.ev);
}
