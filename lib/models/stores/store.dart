import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:domgaleto/helpers/extensions.dart';
import 'package:domgaleto/models/user/address.dart';

enum StoreStatus { closed, open, closing }

class Store {
  Store.fromSnap(DocumentSnapshot doc) {
    name = doc['name'] as String;
    image = doc['image'] as String;
    phone = doc['phone'] as String;
    address = Address.fromMap(doc['address'] as Map<String, dynamic>);

    opening = (doc['openning'] as Map<String, dynamic>).map((key, value) {
      final timesString = value as String;

      if (timesString.isNotEmpty) {
        final splitted = timesString.split(RegExp("[:-]"));

        return MapEntry(key, {
          "from": TimeOfDay(
              hour: int.parse(splitted[0]), minute: int.parse(splitted[1])),
          "to": TimeOfDay(
              hour: int.parse(splitted[2]), minute: int.parse(splitted[3])),
        });
      } else {
        return MapEntry(key, {});
      }
    });
    updateStatus();
  }

  String? name;
  String? image;
  String? phone;
  bool open = false;
  late Address address;
  late Map<String, Map<String, TimeOfDay>> opening =
      TimeOfDay.now() as Map<String, Map<String, TimeOfDay>>;

  StoreStatus? status;

  String get addressText =>
      '${address.street}, ${address.number}${address.complement!.isNotEmpty ? ' - ${address.complement}' : ''}${address.reference!.isNotEmpty ? ' - ${address.reference}' : ''} - '
      '${address.district}, ${address.city}/${address.state}';

  String get openingText {
    return 'Seg-Sex: ${formattedPeriod(opening['monfri']!)} - Chalita Espetaria\n'
        'Sab: ${formattedPeriod(opening['sat']!)} - Dom Galeto e Chalita Espetaria\n';
  }

  String formattedPeriod(Map<String, TimeOfDay>? period) {
    if (period == null) return "Fechada";
    return '${period['from']!.formatted()} - ${period['to']?.formatted()}';
  }

  String get cleanPhone => phone!.replaceAll(RegExp(r"[^\d]"), "");
  get openn => {open};
  void updateStatus() {
    final weekDay = DateTime.now().weekday;

    print('Verificando Status da Loja');
    Map<String, TimeOfDay>? period;
    if (weekDay > 0 || weekDay < 6) {
      period = opening['monfri'];
    } else if (weekDay == 6) {
      period = opening['sat'];
    } else {
      period = opening['sun'];
    }
    final now = TimeOfDay.now();

    if (period == null) {
      status = StoreStatus.closed;
      open = false;
    } else if (period['from']!.toMinutes() < now.toMinutes() &&
        period['to']!.toMinutes() - 15 > now.toMinutes()) {
      status = StoreStatus.open;
      open = true;
    } else if (period['from']!.toMinutes() < now.toMinutes() &&
        period['to']!.toMinutes() > now.toMinutes()) {
      status = StoreStatus.closing;
      open = true;
    } else {
      status = StoreStatus.closed;
      open = false;
    }
  }

  String get statusText {
    switch (status) {
      case StoreStatus.closed:
        return 'Fechado';
      case StoreStatus.open:
        return 'Aberto';
      case StoreStatus.closing:
        return 'Fechando';
      default:
        return 'asd';
    }
  }
}
