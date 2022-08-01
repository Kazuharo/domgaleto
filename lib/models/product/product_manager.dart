import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:domgaleto/models/product/product.dart';

class ProductManager extends ChangeNotifier {
  ProductManager() {
    _loadAllProductsR();
    _loadAllProductsE();
    _loadAllProductsB();
    _loadAllProductsO();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Product> allProducts = [];
  List<Product> allProductsR = [];
  List<Product> allProductsE = [];
  List<Product> allProductsB = [];
  List<Product> allProductsO = [];

  Future<void> _loadAllProductsR() async {
    final QuerySnapshot snapProducts = await firestore
        .collection('products')
        .where('deleted', isEqualTo: false)
        .where('category', isEqualTo: 'refeicoes')
        .get();

    allProductsR = snapProducts.docs.map((d) => Product.fromSnap(d)).toList();

    notifyListeners();
  }

  Future<void> _loadAllProductsE() async {
    final QuerySnapshot snapProducts = await firestore
        .collection('products')
        .where('deleted', isEqualTo: false)
        .where('category', isEqualTo: 'espetinhos')
        .get();

    allProductsE = snapProducts.docs.map((d) => Product.fromSnap(d)).toList();

    notifyListeners();
  }

  Future<void> _loadAllProductsB() async {
    final QuerySnapshot snapProducts = await firestore
        .collection('products')
        .where('deleted', isEqualTo: false)
        .where('category', isEqualTo: 'bebidas')
        .get();

    allProductsB = snapProducts.docs.map((d) => Product.fromSnap(d)).toList();

    notifyListeners();
  }

  Future<void> _loadAllProductsO() async {
    final QuerySnapshot snapProducts = await firestore
        .collection('products')
        .where('deleted', isEqualTo: false)
        .where('category', isEqualTo: 'outros')
        .get();

    allProductsO = snapProducts.docs.map((d) => Product.fromSnap(d)).toList();

    notifyListeners();
  }

  Product? findProductById(String id) {
    try {
      return allProducts.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  void update(Product product) {
    allProducts.removeWhere((p) => p.id == product.id);
    allProducts.add(product);
    notifyListeners();
  }

  void delete(Product product) {
    product.delete();
    allProducts.removeWhere((p) => p.id == product.id);
    notifyListeners();
  }
}
