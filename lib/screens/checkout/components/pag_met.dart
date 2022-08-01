import 'package:flutter/material.dart';
import 'package:domgaleto/models/cart/cart_manager.dart';
import 'package:domgaleto/models/user/user_manager.dart';
import 'package:provider/provider.dart';

class PagMet extends StatefulWidget {
  @override
  PagMetState createState() => PagMetState();
}

class PagMetState extends State<PagMet> {
  var paymet;
  var troco = 2;

  @override
  Widget build(BuildContext context) {
    final userManager = context.watch<UserManager>();
    final cartManager = context.watch<CartManager>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Escolha a Forma de Pagamento',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            RadioListTile(
              title: Text(
                'Cartão',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text('Debito ou Credito na maquininha'),
              secondary: Icon(Icons.credit_card),
              activeColor: Colors.blue,
              value: 'Cartao',
              groupValue: paymet,
              onChanged: (var newValue) {
                setState(() {
                  userManager.user?.lastpaymet = newValue.toString();
                  paymet = newValue;
                });
              },
            ),
            RadioListTile(
              title: Text(
                'PIX',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text('Pagamento via PIX na entrega'),
              secondary: Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('images/icons/iconPix.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              activeColor: Colors.blue,
              value: 'PIX',
              groupValue: paymet,
              onChanged: (var newValue) {
                setState(() {
                  paymet = newValue;
                  userManager.user?.lastpaymet = newValue.toString();
                });
              },
            ),
            RadioListTile(
              title: Text(
                'Dinheiro',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Visibility(
                visible: paymet == 'Dinheiro',
                child: TextFormField(
                  decoration: const InputDecoration(
                      isDense: false,
                      labelText: 'Troco para Quanto?',
                      hintText: '50'),
                  keyboardType: TextInputType.number,
                  validator: (troco) {
                    if (paymet == 'Dinheiro' && troco == null)
                      return 'Troco obrigatório';
                    if (int.parse(troco!) < cartManager.totalPrice!) {
                      return 'Troco incorreto';
                    } else {
                      return null;
                    }
                  },
                  onSaved: userManager.user?.setTroco,
                  //userManager.user.setTroco,
                ),
              ),
              secondary: Icon(Icons.monetization_on),
              activeColor: Colors.blue,
              value: 'Dinheiro',
              groupValue: paymet,
              onChanged: (var newValue) {
                setState(() {
                  paymet = newValue;
                  userManager.user?.lastpaymet = newValue.toString();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
