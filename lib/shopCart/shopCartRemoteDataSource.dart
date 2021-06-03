class Cupon {
  final String id;
  final String row_ticket;
  final String user_id;
  final String qty;

  final String qty_asing;

  Cupon({this.id, this.row_ticket, this.user_id, this.qty, this.qty_asing});

  factory Cupon.fromJson(Map<String, dynamic> json) =>
      Cupon(
          id: json["id"],
          row_ticket: json["row_ticket"],
          user_id: json["user_id"],
          qty: json["qty"],
          qty_asing: json["qty_asing"]);
}

class ClientAddress {
  final String id;
  final String user_id;
  final String name;
  final String lastName;
  final String phone_number;
  final String state_id;
  final String city_id;
  final String address;
  final String address_number;

  ClientAddress({this.id,
    this.user_id,
    this.name,
    this.lastName,
    this.phone_number,
    this.state_id,
    this.city_id,
    this.address,
    this.address_number});

  factory ClientAddress.fromJson(Map<String, dynamic> json) =>
      ClientAddress(
        id: json["id"],
        user_id: json["user_id"],
        name: json["name"],
        lastName: json["lastName"],
        phone_number: json["phone_number"],
        state_id: json["state_id"],
        city_id: json["city_id"],
        address: json["address"],
        address_number: json["address_number"],
      );
}

class DeliveryPrice{
  final String status;
  final String message;
  //Price
  final String data;

  DeliveryPrice({this.status, this.message, this.data});

  factory DeliveryPrice.fromJson(Map<String, dynamic> json) => DeliveryPrice(
    status: json["status"],
    message: json["message"],
    data: json["data"]
  );
}

class SiteCurrency{
  final String id;
  final String coin_nomenclature;
  final String exchange_rate;

  SiteCurrency({this.id, this.coin_nomenclature, this.exchange_rate});

  factory SiteCurrency.fromJson(Map<String,dynamic> json)=> SiteCurrency(
    id: json["id"],
    coin_nomenclature: json["coin_nomenclature"],
    exchange_rate: json["exchange_rate"]
  );
}

