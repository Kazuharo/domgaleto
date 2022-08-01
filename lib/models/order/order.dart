import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:domgaleto/models/cart/cart_manager.dart';
import 'package:domgaleto/models/cart/cart_product.dart';
import 'package:domgaleto/models/user/address.dart';

enum Status { canceled, preparing, transporting, delivered }

class Order {
  Order.fromCartManager(CartManager cartManager) {
    name = cartManager.user!.name!;
    items = List.from(cartManager.items);
    price = cartManager.totalPrice!;
    userId = cartManager.user!.id!;
    address = cartManager.address!;
    status = Status.preparing;
    troco = cartManager.user!.troco;
    lastpaymet = cartManager.user!.lastpaymet!;
    // pagmet = cartManager.pagmet;
  }

  Order.fromDocument(DocumentSnapshot doc) {
    orderId = doc.id;
    name = doc['name'] as String;

    items = (doc['items'] as List<dynamic>).map((e) {
      return CartProduct.fromMap(e as Map<String, dynamic>);
    }).toList();

    price = doc['price'] as num;
    userId = doc['user'] as String;
    address = Address.fromMap(doc['address'] as Map<String, dynamic>);
    date = doc['date'] as Timestamp;
    status = Status.values[doc['status'] as int];
    troco = doc['troco'] as String;
    lastpaymet = doc['lastpaymet'] as String;
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  DocumentReference get firestoreRef =>
      firestore.collection('orders').doc(orderId);

  void updateFromDocument(DocumentSnapshot doc) {
    status = Status.values[doc['status'] as int];
  }

  Future<void> save() async {
    firestore.collection('orders').doc(orderId).set({
      'items': items.map((e) => e.toOrderItemMap()).toList(),
      'name': name,
      'price': price,
      'user': userId,
      'address': address.toMap(),
      'status': status.index,
      'date': Timestamp.now(),
      'troco': troco,
      'lastpaymet': lastpaymet,
    });
  }

  Null Function()? get back {
    return status.index >= Status.transporting.index
        ? () {
            status = Status.values[status.index - 1];
            firestoreRef.update({'status': status.index});
          }
        : null;
  }

  Null Function()? get advance {
    return status.index <= Status.transporting.index
        ? () {
            status = Status.values[status.index + 1];
            firestoreRef.update({'status': status.index});
          }
        : null;
  }

  Future<void> cancel() async {
    try {
      status = Status.canceled;
      firestoreRef.update({'status': status.index});
    } catch (e) {
      debugPrint('Erro ao cancelar');
      return Future.error('Falha ao cancelar');
    }
  }

  late String orderId;
  String? troco;
  late String lastpaymet;

  late List<CartProduct> items;
  late num price;
  late String name;
  late String userId;
  late Address address;
  late Status status;

  Timestamp? date;

  String get formattedId => '#${orderId.padLeft(6, '0')}';

  String get statusText => getStatusText(status);

  static String getStatusText(Status status) {
    switch (status) {
      case Status.canceled:
        return 'Cancelado';
      case Status.preparing:
        return 'Em preparação';
      case Status.transporting:
        return 'Em transporte';
      case Status.delivered:
        return 'Entregue';
      default:
        return '';
    }
  }

  @override
  String toString() {
    return 'Order{firestore: $firestore, orderId: $orderId, items: $items, price: $price, userId: $userId, address: $address, date: $date, troco: $troco, lastpaymet: $lastpaymet, name : $name}';
  }
}
