import 'dart:convert';
import 'dart:core';
import 'dart:developer';

import 'package:uuid/uuid.dart';

import '../settings/settings.dart';
import 'jsonRpcError.dart';
import 'jsonRpcHttpClient.dart';
import 'jsonRpcError.dart';
import 'jsonRpcHttpClient.dart';
import 'values.dart';

abstract class JsonRPCClient<T> {
  String _encoding = 'UTF_8';
  RPCVersion rpcVersion;
  int _httpConnectionTimeout;
  int _httpSocketTimeout;

  static JsonRPCClient jsonRPCHTTPClient<T>({RPCVersion rpcVersion}) {
    var uri = Settings.uri;

    log("la uri es"+uri.toString());

    var client = JsonRPCHttpClient<T>(
      serviceUri: uri,
    );
    client.rpcVersion = rpcVersion;
    return client;
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

  Future<Map<String, dynamic>> call(
      String method, Map<String, dynamic> params) async {
    try {
      switch (rpcVersion) {
        case RPCVersion.VERSION_1:
          return await doRequestV1(method, params.values.toList());
        case RPCVersion.VERSION_2:
          return await doRequestV2(method, params);
        default:
          throw JsonRPCError('rpc version unsopported');
      }
    } catch (e) {
      throw new JsonRPCError(e.toString());
    }
  }

  /// to be override with a child implementation
  Future<Map<String, dynamic>> doJsonRequest(String jsonBody);

  Future<Map<String, dynamic>> doRequestV1(
      String method, List<dynamic> params) async {
    Map<String, dynamic> body = Map<String, dynamic>();
    try {
      body['id'] = Uuid().v4();
      body['method'] = method;
      body['params'] = params;
    } catch (e1) {
      throw new JsonRPCError("Invalid JSON request");
    }
    return await doJsonRequest(json.encode(body));
  }

  Future<Map<String, dynamic>> doRequestV2(
      String method, Map<String, dynamic> params) async {
    Map<String, dynamic> body = Map<String, dynamic>();
    try {
      body['id'] = Uuid().v4();
      body['method'] = method;
      body['params'] = params;
      body['jsonrpc'] = '2.0';
    } catch (e1) {
      throw new JsonRPCError("Invalid JSON request");
    }
    return await doJsonRequest(json.encode(body));
  }
}
