import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:domgaleto/common/custom_icon_button.dart';
import 'package:domgaleto/models/cart/cart_manager.dart';
import 'package:domgaleto/models/user/address.dart';
import 'package:provider/provider.dart';

class CepInputField extends StatefulWidget {
  const CepInputField(this.address);

  final Address address;

  @override
  _CepInputFieldState createState() => _CepInputFieldState();
}

class _CepInputFieldState extends State<CepInputField> {
  final TextEditingController cepController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<CartManager>();
    final primaryColor = Theme.of(context).primaryColor;

    if (widget.address.zipCode == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            enabled: !cartManager.loading,
            controller: cepController,
            decoration: const InputDecoration(
                isDense: true, labelText: 'CEP', hintText: '12.345-678'),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CepInputFormatter(),
            ],
            keyboardType: TextInputType.number,
            validator: (cep) {
              if (cep == null) {
                return 'Campo obrigatório';
              } else if (cep.length != 10) {
                return 'CEP Inválido';
              }
              return null;
            },
          ),
          if (cartManager.loading)
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primaryColor),
              backgroundColor: Colors.transparent,
            ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor),
            onPressed: !cartManager.loading
                ? () async {
                    if (Form.of(context)!.validate()) {
                      try {
                        await context
                            .read<CartManager>()
                            .getAddress(cepController.text);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('$e'),
                          backgroundColor: Colors.red,
                        ));
                      }
                    }
                  }
                : null,
            child: const Text('Buscar CEP'),
          ),
        ],
      );
    } else
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'CEP: ${widget.address.zipCode}',
                style:
                    TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
              ),
            ),
            CustomIconButton(
              iconData: Icons.edit,
              color: primaryColor,
              size: 20,
              onTap: () {
                context.read<CartManager>().removeAddress();
              },
            ),
          ],
        ),
      );
  }
}
