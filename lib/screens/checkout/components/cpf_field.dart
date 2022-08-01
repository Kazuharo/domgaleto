import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:domgaleto/models/user/user_manager.dart';
import 'package:provider/provider.dart';

class CpfField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userManager = context.watch<UserManager>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'CPF',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            TextFormField(
              initialValue: userManager.user?.cpf,
              decoration: const InputDecoration(
                  hintText: '000.000.000-00', isDense: true),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CpfInputFormatter(),
              ],
              onSaved: userManager.user!.setCpf,
            )
          ],
        ),
      ),
    );
  }
}
