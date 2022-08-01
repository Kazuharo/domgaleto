import 'package:domgaleto/models/stores/store.dart';
import 'package:domgaleto/models/stores/stores_manager.dart';
import 'package:domgaleto/screens/home/components/home_card.dart';
import 'package:flutter/material.dart';
import 'package:domgaleto/common/price_card.dart';
import 'package:domgaleto/models/cart/cart_manager.dart';
import 'package:domgaleto/models/cart/checkout_manager.dart';
import 'package:domgaleto/screens/checkout/components/cpf_field.dart';
import 'package:domgaleto/screens/checkout/components/pag_met.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CartManager, CheckoutManager>(
      create: (_) => CheckoutManager(),
      update: (_, cartManager, checkoutManager) =>
          checkoutManager!..updateCart(cartManager),
      lazy: false,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('Pagamento'),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Consumer<CheckoutManager>(
            builder: (_, checkoutManager, __) {
              if (checkoutManager.loading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Processando seu pagamento...',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16),
                      )
                    ],
                  ),
                );
              }

              return Form(
                key: formKey,
                child: ListView(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      height: 25,
                      child: Row(children: [
                        const Expanded(
                            flex: 1,
                            child: Text(
                              'Status do Restaurante:',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            )),
                        Expanded(
                          flex: 1,
                          child: Consumer<StoresManager>(
                            builder: (_, storesManager, __) {
                              if (storesManager.stores.isEmpty) {
                                return const LinearProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                  backgroundColor: Colors.transparent,
                                );
                              }

                              return ListView.builder(
                                itemCount: storesManager.stores.length,
                                itemBuilder: (_, index) {
                                  return HomeCard(storesManager.stores[index]);
                                },
                              );
                            },
                          ),
                        ),
                      ]),
                    ),
                    CpfField(),
                    PagMet(),
                    PriceCard(
                        buttonText: 'Finalizar Pedido',
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState?.save();

                            checkoutManager.checkout(onStockFail: (e) {
                              Navigator.of(context).popUntil(
                                  (route) => route.settings.name == '/cart');
                            }, onPayFail: (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('$e'),
                                backgroundColor: Colors.red,
                              ));
                            }, onSuccess: (order) {
                              Navigator.of(context).popUntil(
                                  (route) => route.settings.name == '/');
                              Navigator.of(context)
                                  .pushNamed('/confirmation', arguments: order);
                            });
                          }
                        })
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
