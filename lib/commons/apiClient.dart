import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pluis_hv_app/commons/keyStorage.dart';
import 'package:pluis_hv_app/commons/values.dart';

import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:pluis_hv_app/settings/settings.dart';

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
    // 60 seconds of timeout
    client.options.connectTimeout = 60 * 1000;
    client.options.receiveTimeout = 60 * 1000;

    cookieJar = CookieJar();
    client.interceptors.add(CookieManager(cookieJar));
  }

  Future<Response> getToken(String method, Map<String, dynamic> params) async {
    try {
      var get_method = this.serviceUri + method;

      var response = await client.get(get_method);

      //GEt the Cookies for later request
      var cookies = cookieJar.loadForRequest(Uri.parse(get_method));

      return response;
    } on DioError catch (error) {
      log("ONError  get token" +
          error.message.toString() +
          error.type.toString());
      throw Exception(error.message);
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
    } on DioError catch (error) {
      if (error.type == DioErrorType.connectTimeout) {
        throw Exception("Connection Timeout Exception");
      }
      return Response(data: error.toString());
    }
  }

  Future<Response> get(String method, Map<String, dynamic> params) async {
    try {
      var url = this.serviceUri + method;

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

  Future<Response> downloadFile(String pdfUrl, String storePath,
      Function(int, int) onReceiveProgress) async {
    try {
      var response = await client.download(pdfUrl, storePath,
          onReceiveProgress: onReceiveProgress);
      return response;
    } on DioError catch (error) {
      throw Exception(error.message);
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
