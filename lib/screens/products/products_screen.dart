import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:domgaleto/common/custom_drawer/custom_drawer.dart';

import 'components/category_list_tile.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                title: const Text('Cardápio'),
                centerTitle: true,
                snap: true,
                floating: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                flexibleSpace: const FlexibleSpaceBar(),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    color: Colors.white,
                    onPressed: () => Navigator.of(context).pushNamed('/cart'),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 300,
                  child: FutureBuilder<QuerySnapshot>(
                    future:
                        FirebaseFirestore.instance.collection('category').get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        var dividedTiles = ListTile.divideTiles(
                          tiles: snapshot.data!.docs.map((doc) {
                            return CategoryListTile(doc);
                          }).toList(),
                          color: Colors.red,
                        ).toList();

                        return ListView(
                          children: dividedTiles,
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
