import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:domgaleto/models/cart/cart_manager.dart';
import 'package:domgaleto/models/order/order.dart';
import 'package:domgaleto/models/product/product.dart';

class CheckoutManager extends ChangeNotifier {
  CartManager? cartManager;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // ignore: use_setters_to_change_properties
  updateCart(CartManager? cartManager) {
    this.cartManager = cartManager;
  }

  Future<void> checkout(
      {Function? onStockFail, Function? onSuccess, Function? onPayFail}) async {
    loading = true;

    final orderId = await _getOrderId();

    try {
      await _decrementStock();
    } catch (e) {
      onStockFail!(e);
      loading = false;
      return;
    }

    try {} catch (e) {
      onPayFail!(e);
      loading = false;
      return;
    }

    final order = Order.fromCartManager(cartManager!);
    order.orderId = orderId.toString();

    await order.save();

    cartManager?.clear();

    onSuccess!(order);
    loading = false;
  }

  Future<int> _getOrderId() async {
    final ref = firestore.doc('aux/ordercounter');

    try {
      final result = await firestore.runTransaction((tx) async {
        final doc = await tx.get(ref);
        final orderId = doc['current'] as int;
        await tx.update(ref, {'current': orderId + 1});
        return {'orderId': orderId};
      });
      return result['orderId'] as int;
    } catch (e) {
      debugPrint(e.toString());
      return Future.error('Falha ao gerar número do pedido');
    }
  }

  Future<void> _decrementStock() {
    return firestore.runTransaction((tx) async {
      final List<Product> productsToUpdate = [];
      final List<Product> productsWithoutStock = [];

      for (final cartProduct in cartManager!.items) {
        Product? product;

        if (productsToUpdate.any((p) => p.id == cartProduct.productId)) {
          product =
              productsToUpdate.firstWhere((p) => p.id == cartProduct.productId);
        } else {
          final doc =
              await tx.get(firestore.doc('products/${cartProduct.productId}'));
          product = Product.fromSnap(doc);
        }

        cartProduct.product = product;

        final size = product.findSize(cartProduct.size!);
        if (size!.stock - cartProduct.quantity < 0) {
          productsWithoutStock.add(product);
        } else {
          size.stock -= cartProduct.quantity;
          productsToUpdate.add(product);
        }
      }

      if (productsWithoutStock.isNotEmpty) {
        return Future.error(
            '${productsWithoutStock.length} produtos sem estoque');
      }

      for (final product in productsToUpdate) {
        tx.update(firestore.doc('products/${product.id}'),
            {'sizes': product.exportSizeList()});
      }
    });
  }
}
