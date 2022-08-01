import 'package:flutter/material.dart';
import 'package:domgaleto/models/product/product.dart';
import 'package:domgaleto/models/product/product_manager.dart';
import 'package:domgaleto/screens/edit_product/components/images_form.dart';
import 'package:domgaleto/screens/edit_product/components/sizes_form.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  EditProductScreen(Product? p)
      : editing = p?.id != null,
        product = p != null ? p.clone() : Product();

  final Product? product;
  bool editing;

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  String dropdownValue = 'refeicoes';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: widget.product,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.editing ? 'Editar Produto' : 'Criar Produto'),
          centerTitle: true,
          actions: <Widget>[
            if (widget.editing)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  context.read<ProductManager>().delete(widget.product!);
                  Navigator.of(context).pop();
                },
              )
          ],
        ),
        backgroundColor: Colors.white,
        body: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              ImagesForm(widget.product),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      initialValue: widget.product?.name,
                      decoration: const InputDecoration(
                        hintText: 'Título',
                        border: InputBorder.none,
                      ),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      validator: (name) {
                        if (name!.length < 6) return 'Título muito curto';
                        return null;
                      },
                      onSaved: (name) => widget.product?.name = name,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'A partir de',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Text(
                      'R\$ ...',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 0),
                          child: Text(
                            'Categoria',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        DropdownButton<String>(
                          value: widget.product?.category,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.red),
                          underline: Container(
                            width: 2,
                            height: 2,
                            color: Colors.red,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              widget.product?.category = newValue;
                            });
                          },
                          items: <String>[
                            'refeicoes',
                            'espetinhos',
                            'bebidas',
                            'outros'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        'Descrição',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    TextFormField(
                      initialValue: widget.product?.description,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                          hintText: 'Descrição', border: InputBorder.none),
                      maxLines: null,
                      validator: (desc) {
                        if (desc!.length < 10) return 'Descrição muito curta';
                        return null;
                      },
                      onSaved: (desc) => widget.product?.description = desc,
                    ),
                    SizesForm(widget.product),
                    const SizedBox(
                      height: 20,
                    ),
                    Consumer<Product>(
                      builder: (_, product, __) {
                        return SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor),
                            onPressed: !product.loading
                                ? () async {
                                    if (formKey.currentState!.validate()) {
                                      formKey.currentState!.save();

                                      await product.save();

                                      context
                                          .read<ProductManager>()
                                          .update(product);

                                      Navigator.of(context).pop();
                                    }
                                  }
                                : null,
                            child: product.loading
                                ? const CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  )
                                : const Text(
                                    'Salvar',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
