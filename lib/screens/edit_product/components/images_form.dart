import 'dart:io';
import 'dart:typed_data';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:domgaleto/models/product/product.dart';
import 'package:domgaleto/screens/edit_product/components/image_source_sheet.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagesForm extends StatelessWidget {
  const ImagesForm(this.product, {Key? key}) : super(key: key);

  final Product? product;

  @override
  Widget build(BuildContext context) {
    return FormField<List<dynamic>>(
      initialValue: List.from(product!.images!),
      validator: (images) {
        if (images == null) return 'Insira ao menos uma imagem';
        return null;
      },
      onSaved: (images) => product!.newImages = images,
      builder: (state) {
        void onImageSelected(File file) {
          state.value!.add(file);
          state.didChange(state.value);
          Navigator.of(context).pop();
        }

        return Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1,
              child: CarouselSlider(
                items: state.value?.map<Widget>((image) {
                  return Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      if (image is String)
                        Image.network(
                          image,
                          fit: BoxFit.cover,
                        )
                      else
                        Image.file(
                          image as File,
                          fit: BoxFit.cover,
                        ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.remove),
                          color: Colors.red,
                          onPressed: () {
                            state.value?.remove(image);
                            state.didChange(state.value);
                          },
                        ),
                      )
                    ],
                  );
                }).toList()
                  ?..add(Material(
                    color: Colors.grey[100],
                    child: IconButton(
                      icon: const Icon(Icons.add_a_photo),
                      color: Theme.of(context).primaryColor,
                      iconSize: 50,
                      onPressed: () {
                        if (Platform.isAndroid) {
                          showModalBottomSheet(
                              context: context,
                              builder: (_) => ImageSourceSheet(
                                    onImageSelected: onImageSelected,
                                  ));
                        } else {
                          showCupertinoModalPopup(
                              context: context,
                              builder: (_) => ImageSourceSheet(
                                    onImageSelected: onImageSelected,
                                  ));
                        }
                      },
                    ),
                  )),
                options: CarouselOptions(
                    autoPlay: false, height: 400, aspectRatio: 16 / 9),
              ),
            ),
            if (state.hasError)
              Container(
                margin: const EdgeInsets.only(top: 16, left: 16),
                alignment: Alignment.centerLeft,
                child: Text(
                  state.errorText!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}
