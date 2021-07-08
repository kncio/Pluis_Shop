import 'package:flutter/animation.dart';

const double DEFAULT_PADDING = 5.0;

// RPC ConstantTween
enum RPCVersion { VERSION_1, VERSION_2 }

const RPCVersion DEFAULT_RPC_VERSION = RPCVersion.VERSION_2;

//Network Constants
const String WEB_URI = 'https://www.calzadopluis.com/api/';
const String WEB_SERVICE = 'https://www.calzadopluis.com/api/store/';
const String WEB_IMAGES =
    'https://www.calzadopluis.com/writable/uploads/images/';
const String WEB_PDF_BILLS =
    'https://www.calzadopluis.com/writable/uploads/pdf/';
const String WEB_SLIDES_IMAGES =
    'https://www.calzadopluis.com/writable/uploads/slides/';
//
const int HTTP_CONNECTION_TIMEOUT = 5000;
const int REQUEST_TIME_LIMIT = 6000;
const int HTTP_SOCKET_TIMEOUT = 5000;
//
const String ApplicationVersion = "0.0.1";

//region Metodos de entrega
const String storePickUp = '0|null';
const String userDefaultAddress = '|0';
//endregion

//socialNetworksUrl
const String facebookUrl = "https://www.facebook.com/calzadopluis/";
const String instagramUrl = "https://www.instagram.com/calzadopluis/";
const String phone = "+5359624232";
const String whatsappUrl = "whatsapp://send?phone=$phone";
