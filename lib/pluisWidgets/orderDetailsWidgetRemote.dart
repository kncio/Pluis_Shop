import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:pluis_hv_app/commons/apiClient.dart';
import 'package:pluis_hv_app/commons/apiMethodsNames.dart';
import 'package:pluis_hv_app/commons/failure.dart';
import 'package:pluis_hv_app/shopCart/shopCartRemoteDataSource.dart';

class OrderDetailsCubit extends Cubit<OrderDetailState> {
  final OrderDetailsRepository repo;

  OrderDetailsCubit({this.repo}) : super(OrderDetailStateInitial());

  Future<void> getDetails(String orderNumber) async {
    emit(OrderDetailStateLoading());
    log(orderNumber);
    var eitherValue = await repo.getDetails(orderNumber);

    eitherValue.fold(
        (failure) => failure.properties.isEmpty
            ? emit(OrderDetailStateError("Server unreachable"))
            : emit(OrderDetailStateError(failure.properties.first)),
        (details) => details != null
            ? emit(OrderDetailStateGetData(details))
            : emit(OrderDetailStateError("")));
  }

  Future<void> getAddress( String userId,String addressId,) async {
    emit(OrderDetailStateLoading());

    var eitherValue = await repo.getClientAddressById(userId, addressId);

    eitherValue.fold(
        (failure) => failure.properties.isEmpty
            ? emit(OrderDetailStateError("Server unreachable"))
            : emit(OrderDetailStateError(failure.properties.first)),
        (details) => details != null
            ? emit(OrderDetailStateSuccess(details))
            : emit(OrderDetailStateError("")));
  }
}

class OrderDetailsRepository {
  final ApiClient api;

  OrderDetailsRepository({this.api});

  Future<Either<Failure, OrderDetailFullData>> getDetails(
      String orderNumber) async {
    try {
      log("what? " + orderNumber);
      var response = await api.get(ORDER_DETAIL, {'order_number': orderNumber});

      if (response.statusCode == 200) {
        log("step0");
        Map<String, dynamic> infoOrder = response.data['data']['info_order'];

        OrderDetailData x = OrderDetailData.fromJson(infoOrder);

        var y = List.from(
            response.data['data']["info_product"]);

        var z = y.map((e) => OrderProductsInfo.fromJson(e)).toList();
        log("step1 " + z[0].toString());
       
        var orderDetails = OrderDetailFullData(
          data: x,
          pinfo: z
        );
        log("returnign");
        return Right(orderDetails);
      } else {
        log("Error");
        return Left(Failure([response.statusMessage]));
      }
    } catch (error) {
      return Left(Failure([error.toString()]));
    }
  }

  Future<Either<Failure, ClientAddress>> getClientAddressById(
      String userId, String addressId) async {
    ClientAddress address;
    log(userId + "   " +addressId);
    try {
      var response = await api.get(GET_CLIENT_ADDRESS, {'id': userId});

      if (response.statusCode == 200) {
        try {

          address = List.from(response.data["data"]["Libraries Address"])
              .map((e) => ClientAddress.fromJson(e))
              .where((element) => element.id == addressId)
              .single;
          return Right(address);
        } catch (error) {
          Failure(["Datos inválidos"]);
        }
      } else {
        log("Error");
        return Left(Failure([response.statusMessage]));
      }
    } catch (error) {
      return Left(Failure([error.toString()]));
    }
  }
}

class OrderDetailState extends Equatable {
  @override
  List<Object> get props => [];
}

class OrderDetailStateInitial extends OrderDetailState {}

class OrderDetailStateLoading extends OrderDetailState {}

class OrderDetailStateError extends OrderDetailState {
  final String message;

  OrderDetailStateError(this.message);
}

class OrderDetailStateGetData extends OrderDetailState {
  final OrderDetailFullData data;

  OrderDetailStateGetData(this.data);
}

class OrderDetailStateSuccess extends OrderDetailState {
  final ClientAddress address;

  OrderDetailStateSuccess(this.address);
}

class OrderDetailFullData {
  final OrderDetailData data;
  final List<OrderProductsInfo> pinfo;

  OrderDetailFullData({this.data, this.pinfo});
}

class OrderDetailData {
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

  OrderDetailData({
    this.id,
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
    this.buff,
  });

  factory OrderDetailData.fromJson(Map<String, dynamic> json) => OrderDetailData(
        id: json['id'],
        order_number: json['order_number'],
        id_account: json['id_account'],
        price_delivery: json['price_delivery'],
        address_send: json['address_send'],
        price_subtotal: json['price_subtotal'],
        shipping_method: json['shipping_method'],
        status: json['status'],
        updated_at: json['updated_at'],
        created_at: json['created_at'],
        currency_shipping: json['currency_shipping'],
        exchange_rate: json['exchange_rate'],
        buff: json['buff'],
      );
}

class OrderProductsInfo {
  final String id;
  final String order_number;
  final String product_id;
  final String price_product;
  final String price_total;
  final String color;
  final String tall;
  final String qty;

  OrderProductsInfo(
      {this.id,
      this.order_number,
      this.product_id,
      this.price_product,
      this.price_total,
      this.color,
      this.tall,
      this.qty});

   factory OrderProductsInfo.fromJson(Map<String, dynamic> json) => new OrderProductsInfo(
        id: json[""],
        order_number: json["order_number"],
        product_id: json["product_id"],
        price_product: json["price_product"],
        price_total: json["price_total"],
        color: json["color"],
        tall: json["tall"],
        qty: json["qty"],
      );
}
