import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:pluis_hv_app/commons/values.dart';

class LoginResponse {
  final String user_id;
  final String name;
  final String email;
  final String token;

  LoginResponse({this.user_id, this.name, this.email, this.token});

  static LoginResponse fromMap(Map<String, dynamic> data) {
    return LoginResponse(
        user_id: data['user_id'].toString(),
        name: data['name'].toString(),
        email: data['email'].toString(),
        token: data['token'].toString());
  }
}

class PendingOrder {
  final String id;
  final String order_number;
  final String id_account;
  final String price_subtotal;
  final String address_send;
  final String price_delivery;
  final String shipping_method;
  final String status;
  final String updated_at;
  final String created_at;
  final String currency_shipping;
  final String exchange_rate;
  final String buff;

  PendingOrder(
      {this.id,
      this.order_number,
      this.id_account,
      this.price_subtotal,
      this.address_send,
      this.price_delivery,
      this.shipping_method,
      this.status,
      this.updated_at,
      this.created_at,
      this.currency_shipping,
      this.exchange_rate,
      this.buff});

  factory PendingOrder.fromJson(Map<String, dynamic> json) => PendingOrder(
        id: json["id"],
        order_number: json["order_number"],
        id_account: json["id_account"],
        price_subtotal: json["price_subtotal"],
        address_send: json["address_send"],
        price_delivery: json["price_delivery"],
        shipping_method: json["shipping_method"],
        status: json["status"],
        updated_at: json["updated_at"],
        created_at: json["created_at"],
        currency_shipping: json["currency_shipping"],
        exchange_rate: json["exchange_rate"],
        buff: json["buff"],
      );
}

class BillData {
  final String id;
  final String invoice_number;
  final String user_id;
  final String date;
  final String pdf;

  BillData({
    this.id,
    this.invoice_number,
    this.user_id,
    this.date,
    this.pdf,
  });

  factory BillData.fromJson(Map<String, dynamic> jsonObject) => BillData(
      id: jsonObject["id"],
      invoice_number: jsonObject["invoice_number"],
      user_id: jsonObject["user_id"],
      date: jsonObject["date"],
      pdf: WEB_PDF_BILLS + jsonObject["pdf"]);
}

class UpdatePasswordDataForm {
  String token_csrf;
  String currentPassword;
  String newPassword;
  String reNewPassword;

  UpdatePasswordDataForm(this.reNewPassword, this.newPassword, this.currentPassword);

  Map<String, dynamic> toMap() => {
    "token_csrf": this.token_csrf,
    "old_password": this.currentPassword,
    "new_password": this.newPassword,
    "new_passwordConfirm": this.reNewPassword,
  };
}

class UpdateEmailDataForm {
  String token_csrf;
  String currentPassword;
  String newEmail;
  String reNewEmail;

  UpdateEmailDataForm(this.currentPassword,this.newEmail, this.reNewEmail);

  Map<String, dynamic> toMap() => {
        "token_csrf": this.token_csrf,
        "password": this.currentPassword,
        "email": this.newEmail,
        "new_passwordConfirm": this.reNewEmail,
      };
}

class SubscriptionsData {
  final String id;
  final String email;
  final String user_id;

  //String comma separated gender_id
  final String preference;
  final String is_sms_recibed;
  final String is_email_recibed;

  SubscriptionsData(
      {this.id,
      this.email,
      this.user_id,
      this.preference,
      this.is_sms_recibed,
      this.is_email_recibed});

  factory SubscriptionsData.fromJson(Map<String, dynamic> jsonData) =>
      SubscriptionsData(
          id: jsonData["id"],
          email: jsonData["email"],
          user_id: jsonData["user_id"],
          preference: jsonData["preference"],
          is_sms_recibed: jsonData["is_sms_recibed"],
          is_email_recibed: jsonData["is_email_recibed"]);

  Map<String, dynamic> getMapToPostMethod(String token_Csrf) {
    Map<String, dynamic> map = {
      "sms_recibed": this.is_sms_recibed,
      "email_recibed": this.is_email_recibed,
      "token_csrf": token_Csrf,
    };

    Map<String, dynamic> genders = {};
    var index = 0;
    var splitted = this.preference.split(',');
    splitted.forEach((gender_id) {
      genders[index.toString()] = {"id": gender_id};
      index++;
    });
    var item = jsonEncode(genders);
    map["gender"] = item;
    log(map.toString());
    return map;
  }
}
