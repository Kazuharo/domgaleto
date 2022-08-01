import 'package:domgaleto/models/user/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:domgaleto/common/price_card.dart';
import 'package:domgaleto/models/cart/cart_manager.dart';
import 'package:domgaleto/screens/address/components/address_card.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userManager = context.watch<UserManager>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrega'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          if (userManager.user?.withdrawal == false) ...[AddressCard()],
          Consumer<CartManager>(
            builder: (_, cartManager, __) {
              return PriceCard(
                buttonText: 'Continuar para o Pagamento',
                onPressed: cartManager.isAddressValid
                    ? () {
                        Navigator.of(context).pushNamed('/checkout');
                      }
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }
}
