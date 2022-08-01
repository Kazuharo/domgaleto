import 'package:flutter/material.dart';
import 'package:domgaleto/helpers/validators.dart';
import 'package:domgaleto/models/user/user.dart';
import 'package:domgaleto/models/user/user_manager.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final User user = User();

  SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Criar Conta'),
        centerTitle: true,
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
                          decoration:
                              const InputDecoration(hintText: 'Nome Completo'),
                          enabled: !userManager.loading,
                          validator: (name) {
                            if (name == null) {
                              return 'Campo obrigatório';
                            } else if (name.trim().split(' ').length <= 1) {
                              return 'Preencha seu Nome completo';
                            }
                            return null;
                          },
                          onSaved: (name) => user.name = name,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(hintText: 'E-mail'),
                          keyboardType: TextInputType.emailAddress,
                          enabled: !userManager.loading,
                          validator: (email) {
                            if (email == null) {
                              return 'Campo obrigatório';
                            } else if (!emailValid(email)) {
                              return 'E-mail inválido';
                            }
                            return null;
                          },
                          onSaved: (email) => user.email = email,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(hintText: 'Senha'),
                          obscureText: true,
                          enabled: !userManager.loading,
                          validator: (pass) {
                            if (pass == null) {
                              return 'Campo obrigatório';
                            } else if (pass.length < 6) {
                              return 'Senha muito curta';
                            }
                            return null;
                          },
                          onSaved: (pass) => user.password = pass,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(hintText: 'Repita a Senha'),
                          obscureText: true,
                          enabled: !userManager.loading,
                          validator: (pass) {
                            if (pass == null) {
                              return 'Campo obrigatório';
                            } else if (pass.length < 6) {
                              return 'Senha muito curta';
                            }
                            return null;
                          },
                          onSaved: (pass) => user.confirmPassword = pass,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor),
                          onPressed: userManager.loading
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState?.save();

                                    if (user.password != user.confirmPassword) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text('Senhas não coincidem!'),
                                        backgroundColor: Colors.red,
                                      ));
                                      return;
                                    }

                                    userManager.signUp(
                                        user: user,
                                        onSuccess: () {
                                          Navigator.of(context).pop();
                                        },
                                        onFail: (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content:
                                                Text('Falha ao cadastrar: $e'),
                                            backgroundColor: Colors.red,
                                          ));
                                        });
                                  }
                                },
                          child: userManager.loading
                              ? const CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                )
                              : const Text(
                                  'Criar Conta',
                                  style: TextStyle(fontSize: 15),
                                ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
