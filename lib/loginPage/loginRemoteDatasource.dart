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

  PendingOrder({this.id,
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

  factory PendingOrder.fromJson(Map<String, dynamic> json) =>
      PendingOrder(
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

  factory BillData.fromJson(Map<String, dynamic> jsonObject) =>
      BillData(
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

  UpdatePasswordDataForm(this.reNewPassword, this.newPassword,
      this.currentPassword);

  Map<String, dynamic> toMap() =>
      {
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

  UpdateEmailDataForm(this.currentPassword, this.newEmail, this.reNewEmail);

  Map<String, dynamic> toMap() =>
      {
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

  SubscriptionsData({this.id,
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

class UserDetails {
  final String id;
  final String name;
  final String lastname;
  final String email;
  final String email_status;
  final String account_type;
  final String password;
  final String role;
  final String avatar;
  final String status;
  final String phone_number;
  final String state_id;
  final String city_id;
  final String address;
  final String address_number;
  final String birthday;
  final String created_at;
  final String activate_metohd;
  final String key_activate;
  final String lastvisit;
  final String black_list;
  final String key_login;

  UserDetails({this.id,
    this.name,
    this.lastname,
    this.email,
    this.email_status,
    this.account_type,
    this.password,
    this.role,
    this.avatar,
    this.status,
    this.phone_number,
    this.state_id,
    this.city_id,
    this.address,
    this.address_number,
    this.birthday,
    this.created_at,
    this.activate_metohd,
    this.key_activate,
    this.lastvisit,
    this.black_list,
    this.key_login});

  factory UserDetails.fromJson(Map<String, dynamic> json) =>
      UserDetails(
        id: json['id'],
        name: json['name'],
        lastname: json['lastname'],
        email: json['email'],
        email_status: json['email_status'],
        account_type: json['account_type'],
        password: json['password'],
        role: json['role'],
        avatar: json['avatar'],
        status: json['status'],
        phone_number: json['phone_number'],
        state_id: json['state_id'],
        city_id: json['city_id'],
        address: json['address'],
        address_number: json['address_number'],
        birthday: json['birthday'],
        created_at: json['created_at'],
        activate_metohd: json['activate_metohd'],
        key_activate: json['key_activate'],
        lastvisit: json['lastvisit'],
        black_list: json['black_list'],
        key_login: json['key_login'],
      );
}
