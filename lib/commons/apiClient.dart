import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
// import 'package:http/http.dart' as http;
import 'package:pluis_hv_app/commons/keyStorage.dart';
import 'package:pluis_hv_app/commons/values.dart';

import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

class ApiClient {
  final String serviceUri;
  String _encoding = 'UTF_8';
  int _httpConnectionTimeout;
  int _httpSocketTimeout;

  Dio client;

  CookieJar cookieJar;

  Map<String, dynamic> header = {'$API_KEY_NAME': '$API_KEY'};

  ApiClient({this.serviceUri}) {
    this.client = Dio();
    client.options.baseUrl = serviceUri;
    client.options.headers = this.header;

    cookieJar = CookieJar();
    client.interceptors.add(CookieManager(cookieJar));

  }

  Future<Response> getToken(String method, Map<String, dynamic> params) async {
    try {
      var get_method = this.serviceUri + method;

      log("METHOD: " + get_method);

      log(client.options.headers.toString());

      var response = await client.get(get_method).timeout(Duration(milliseconds: 6000));
      log("ON RESPONSE");
      //GEt the Cookies for later request
      var cookies = cookieJar.loadForRequest(Uri.parse(get_method));

      log("Response " + cookies.toString());

      return response;
    } catch (error) {
      var err = error as Response;
      log("ONError  get token" + err.data.toString());
      //TODO: Parse DIO.Error
    }
  }

  Future<Response> login(Map<String, dynamic> userData) async {
    try {
      var method = this.serviceUri + "user_login";

      var formData = FormData.fromMap(userData);

      log(client.options.headers.toString());

      var response = await client.post(method, data: formData);
      log("Response " + response.data.toString());

      return response;
    } catch (error) {
      log("ONError " + error.toString());
      return Response(data: error.toString());
    }
  }

  Future<Response> get(String method, Map<String, dynamic> params) async {
    try {
      var url = this.serviceUri + method;
      log(params.toString());
      var response = await client.get(url, queryParameters: params);

      return response;
    } catch (error) {
      log("ONError " + error.toString());
      //TODO: Parse DIO.Error
    }
  }

  Future<Response> post(String method, Map<String, dynamic> data) async {
    try {

      var url = this.serviceUri + method;
      log(url);
      var formData = FormData.fromMap(data);
      var response = await client.post(url, data: formData);


      log("Response " + response.data.toString());
      return response;
    } catch (error) {
      log("ONError " + error.toString());
      //TODO: Parse DIO.Error
    }
  }

  void setEncoding(String encoding) {
    this._encoding = encoding;
  }

  void setConnectionTimeout(int httpConnectionTimeout) {
    this._httpConnectionTimeout = httpConnectionTimeout;
  }

  void setSoTimeout(int httpSocketTimeout) {
    this._httpSocketTimeout = httpSocketTimeout;
  }

  String getEncoding() => this._encoding;

  int getSoTimeout() => this._httpSocketTimeout;

  int getConnectionTimeout() => this._httpConnectionTimeout;

}
