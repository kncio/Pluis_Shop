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
