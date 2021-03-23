import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../settings/settings.dart';
import 'jsonRpc.dart';
import 'jsonRpcError.dart';
import 'requestId.dart';

class JsonRPCHttpClient<T> extends JsonRPCClient<T> {
  final String serviceUri;
  final String httpProtocolVersion;
  Dio client;

  JsonRPCHttpClient({
    this.serviceUri,
    Dio dio,
    this.httpProtocolVersion = 'HTTP 1.0',
  }) {
    client = dio ?? Dio();
    client.options.baseUrl = serviceUri;
    client.options.connectTimeout = this.getConnectionTimeout();
    client.options.receiveTimeout = this.getSoTimeout();
    client.options.contentType = 'application/json';
    client.options.responseType = ResponseType.plain;
  }
  @override
  Future<Map<String, dynamic>> doJsonRequest(String body) async {
    // Create HTTP/POST request with a JSON entity containing the request

    try {
      Response<dynamic> response = await client.post(
        Settings.webService + '?id=' + Id.nextId().toString(),
        data: body,
      );

      dynamic jsonResponse = json.decode(response.data);

      // Check for remote errors
      if (jsonResponse.containsKey('error')) {
        Map<String, dynamic> jsonError = jsonResponse['error'];
        if (jsonError == null) {
          log('error ' + jsonError.toString());
          throw new JsonRPCError(jsonError);
        }
        // no errors
        return jsonResponse; // JSON-RPC 1.0
      } else {
        // no errors
        return jsonResponse; // JSON-RPC 2.0
      }
    }
    // Underlying errors are wrapped into a JSONRPCException instance
    catch (e) {
      throw new JsonRPCError(e.toString());
    }
  }
}
