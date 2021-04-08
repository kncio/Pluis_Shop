import 'package:flutter/animation.dart';

const double DEFAULT_PADDING = 5.0;



// RPC ConstantTween
enum RPCVersion { VERSION_1, VERSION_2 }
const RPCVersion DEFAULT_RPC_VERSION = RPCVersion.VERSION_2;

//Network Constants
const String WEB_URI = 'http://prod.highvistapromotions.com/pluis/';
//http://prod.highvistapromotions.com/pluis/
const String SERVER_ONLINE_IP = 'localhost';
const String SERVER_DEBUG_IP = '192.168.1.2';
const String SERVER_PORT = '81';
const String WEB_SERVICE = 'http://prod.highvistapromotions.com/pluis/api/store/';
const String URI_HTTP = 'http://' + SERVER_DEBUG_IP + ':' + SERVER_PORT;
const String URI_HTTPS = 'https://' + SERVER_DEBUG_IP + ':' + SERVER_PORT;
const String PREVIEW_ZOOM_APP = '/previewZoomApp';
const String PREVIEW_ZOOM_REPOSITORY = '/repository/files/app/previewZoom';
const String WEB_IMAGES= WEB_URI + 'writable/uploads/images/';
//
const int HTTP_CONNECTION_TIMEOUT = 5000;
const int REQUEST_TIME_LIMIT = 6000;
const int HTTP_SOCKET_TIMEOUT = 5000;