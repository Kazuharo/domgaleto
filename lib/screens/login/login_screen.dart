import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:domgaleto/models/user/user.dart';
import 'package:domgaleto/models/user/user_manager.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:domgaleto/helpers/validators.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Entrar'),
        centerTitle: true,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/signup');
            },
            child: const Text(
              'CRIAR CONTA',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  width: 150,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('images/logodg.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('images/logochalita.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 20, bottom: 20)),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: formKey,
                child: Consumer<UserManager>(
                  builder: (_, userManager, __) {
                    return ListView(
                      padding: const EdgeInsets.all(16),
                      shrinkWrap: true,
                      children: <Widget>[
                        TextFormField(
                          controller: emailController,
                          enabled: !userManager.loading,
                          decoration: const InputDecoration(hintText: 'E-mail'),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          validator: (email) {
                            if (!emailValid(email!)) return 'E-mail inválido';
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: passController,
                          enabled: !userManager.loading,
                          decoration: const InputDecoration(hintText: 'Senha'),
                          autocorrect: false,
                          obscureText: true,
                          validator: (pass) {
                            if (pass == null || pass.length < 6) {
                              return 'Senha inválida';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                          onPressed: userManager.loading
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    userManager.signIn(
                                        user: User(
                                            email: emailController.text,
                                            password: passController.text),
                                        onFail: (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content:
                                                Text('Falha ao entrar: $e'),
                                            backgroundColor: Colors.red,
                                          ));
                                        },
                                        onSuccess: () {
                                          Navigator.of(context).pop();
                                        });
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            onPrimary: Colors.white,
                          ),
                          child: userManager.loading
                              ? const CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                )
                              : const Text(
                                  'Entrar',
                                  style: TextStyle(fontSize: 15),
                                ),
                        ),
                      ],
                    );
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Esqueci minha senha'),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
