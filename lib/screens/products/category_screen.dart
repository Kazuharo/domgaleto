import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domgaleto/models/product/product.dart';
import 'package:flutter/material.dart';
import 'package:domgaleto/models/product/product_manager.dart';
import 'package:domgaleto/models/user/user_manager.dart';
import 'package:provider/provider.dart';
import 'components/product_list_tile.dart';

class CategoryScreen extends StatelessWidget {
  final DocumentSnapshot snapshot;
  CategoryScreen(this.snapshot);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(snapshot['title']),
        centerTitle: true,
        actions: <Widget>[
          Consumer<UserManager>(
            builder: (_, userManager, __) {
              if (userManager.adminEnabled()) {
                return IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed('/edit_product', arguments: Product());
                  },
                );
              } else {
                return Container();
              }
            },
          )
        ],
      ),
      body: Consumer<ProductManager>(
        builder: (_, productManager, __) {
          if (snapshot['title'] == ('REFEIÇÕES')) {
            final allProducts = productManager.allProductsR;
            return ListView.builder(
                itemCount: allProducts.length,
                itemBuilder: (_, index) {
                  return ProductListTile(allProducts[index]);
                });
          } else if (snapshot['title'] == ('ESPETINHOS')) {
            final allProducts = productManager.allProductsE;
            return ListView.builder(
                itemCount: allProducts.length,
                itemBuilder: (_, index) {
                  return ProductListTile(allProducts[index]);
                });
          } else if (snapshot['title'] == ('BEBIDAS')) {
            final allProducts = productManager.allProductsB;
            return ListView.builder(
                itemCount: allProducts.length,
                itemBuilder: (_, index) {
                  return ProductListTile(allProducts[index]);
                });
          } else if (snapshot['title'] == ('OUTROS')) {
            final allProducts = productManager.allProductsO;
            return ListView.builder(
                itemCount: allProducts.length,
                itemBuilder: (_, index) {
                  return ProductListTile(allProducts[index]);
                });
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.of(context).pushNamed('/cart');
        },
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
