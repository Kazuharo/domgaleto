import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:domgaleto/models/cart/cart_manager.dart';
import 'package:domgaleto/models/product/product.dart';
import 'package:domgaleto/models/user/user_manager.dart';
import 'package:domgaleto/screens/product/components/size_widget.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(
          title: Text(product.name!),
          centerTitle: true,
          actions: <Widget>[
            Consumer<UserManager>(
              builder: (_, userManager, __) {
                if (userManager.adminEnabled() && product.deleted == false) {
                  return IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(
                          '/edit_product',
                          arguments: product);
                    },
                  );
                } else {
                  return Container();
                }
              },
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            Container(
              child: CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: 1,
                  autoPlay: true,
                  viewportFraction: 1.0,
                ),
                items: product.images?.map((url) {
                  return Image.network(url);
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    product.name!,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'A partir de',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    'R\$ ${product.basePrice?.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Descrição:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    product.description!,
                    style: const TextStyle(fontSize: 16),
                  ),
                  if (product.deleted == true)
                    const Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        'Este produto não está mais disponível',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.red),
                      ),
                    )
                  else ...[
                    const Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        'Tamanhos:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: product.sizes!.map((s) {
                        return SizeWidget(size: s);
                      }).toList(),
                    ),
                  ],
                  const SizedBox(
                    height: 20,
                  ),
                  if (product.hasStock)
                    Consumer2<UserManager, Product>(
                      builder: (_, userManager, product, __) {
                        return SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: primaryColor),
                            onPressed: product.selectedSize != null
                                ? () {
                                    if (userManager.isLoggedIn) {
                                      context
                                          .read<CartManager>()
                                          .addToCart(product);
                                      Navigator.of(context).pushNamed('/cart');
                                    } else {
                                      Navigator.of(context).pushNamed('/login');
                                    }
                                  }
                                : null,
                            child: Text(
                              userManager.isLoggedIn
                                  ? 'Adicionar ao Carrinho'
                                  : 'Entre para Comprar',
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        );
                      },
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
