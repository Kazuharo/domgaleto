import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:domgaleto/models/user/address.dart';

class User {
  User(
      {this.email,
      this.password,
      this.name,
      this.id,
      this.troco,
      this.lastpaymet});

  User.fromDocument(DocumentSnapshot document) {
    var snapshot = document.data() as Map<String, dynamic>;
    id = document.id;
    name = document['name'] as String;
    email = document['email'] as String;
    //
    Map<String, dynamic> dataMap = snapshot;
    if (dataMap.containsKey('address')) {
      address = Address.fromMap(document['address'] as Map<String, dynamic>);
    }
  }

  String? id;
  String? name;
  String? email;
  String? troco;
  String? lastpaymet;
  String? cpf;
  String? password;
  String? confirmPassword;

  bool withdrawal = false;
  bool admin = false;

  Address? address;

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.doc('users/$id');

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  CollectionReference get cartReference => firestoreRef.collection('cart');

  CollectionReference get tokensReference => firestoreRef.collection('tokens');

  Future<void> saveData() async {
    await firestoreRef.set(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      if (address != null) 'address': address?.toMap(),
      if (cpf != null) 'cpf': cpf,
      if (troco != null) 'troco': troco,
      if (lastpaymet != null) 'lastpaymet': lastpaymet
    };
  }

  void setAddress(Address? address) {
    this.address = address;
    saveData();
  }

  void setCpf(String? cpf) {
    this.cpf = cpf;
    saveData();
  }

  void setTroco(String? troco) {
    this.troco = troco;
    saveData();
  }

  void setLastpaymet(String? lastpaymet) {
    this.lastpaymet = lastpaymet;
    saveData();
  }

  Future<void> saveToken() async {
    final token = await messaging.getToken();
    await tokensReference.doc(token).set({
      'token': token,
      'updatedAt': FieldValue.serverTimestamp(),
      'platform': Platform.operatingSystem,
    });
  }
}
