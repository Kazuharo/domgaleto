import 'package:flutter/material.dart';
//import 'package:gallery_saver/gallery_saver.dart';
import 'package:domgaleto/common/order/order_product_tile.dart';
import 'package:domgaleto/models/order/order.dart';
import 'package:domgaleto/models/user/address.dart';
import 'package:screenshot/screenshot.dart';

class ExportAddressDialog extends StatefulWidget {
  ExportAddressDialog(this.address, this.order);

  final Address address;

  final Order order;

  @override
  _ExportAddressDialogState createState() => _ExportAddressDialogState();
}

class _ExportAddressDialogState extends State<ExportAddressDialog> {
  final ScreenshotController screenshotController = ScreenshotController();

  String tamanho = '(';

  String preco = ')....R\$';

  String teste = '\n';

  @override
  build(BuildContext context) async {
    return AlertDialog(
      title: const Text('Informações do Pedido'),
      content: Screenshot(
        controller: screenshotController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15,
            ),
            Text('Cliente: ${widget.order.name}'),
            SizedBox(
              height: 15,
            ),
            Text(
              'Endereço:\n'
              '${widget.order.address.street}, ${widget.order.address.number} ${widget.order.address.complement}\n'
              '${widget.order.address.district}, ${widget.order.address.reference = ''}\n'
              '${widget.order.address.city}/${widget.order.address.state}\n'
              '${widget.order.address.zipCode}',
            ),
            SizedBox(
              height: 15,
            ),
            Text('Descrição do Pedido:\n'
                '${widget.order.items.map(
              (e) {
                return teste +
                    OrderProductTile(e).cartProduct.product.name.toString() +
                    tamanho +
                    OrderProductTile(e).cartProduct.size! +
                    preco +
                    OrderProductTile(e)
                        .cartProduct
                        .fixedPrice!
                        .toStringAsFixed(2);
              },
            )}\n\n '),
            Text(
                'Valor Total:.......................R\$ ${widget.order.price.toStringAsFixed(2)}'),
            Text('Metodo de Pagamento: ${widget.order.lastpaymet}'),
            Text('Troco para: ${widget.order.troco}'),
          ],
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            final file = await screenshotController
                .capture(delay: const Duration(milliseconds: 10))
                .then((capturedImage) {})
                .catchError((onError) {
              print(onError);
            });
            //await GallerySaver.saveImage(file.path);
          },
          child: const Text('Exportar'),
        )
      ],
    );
  }
}
