import 'package:domgaleto/models/stores/stores_manager.dart';
import 'package:domgaleto/models/user/user_manager.dart';
import 'package:domgaleto/screens/home/components/home_card.dart';
import 'package:flutter/material.dart';
import 'package:domgaleto/common/custom_drawer/custom_drawer.dart';
import 'package:domgaleto/models/home/page_manager.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userManager = context.watch<UserManager>();
    return Scaffold(
      drawer: CustomDrawer(),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('images/background-home.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                title: Container(
                  alignment: Alignment.center,
                  width: 200,
                  height: 70,
                  child: Consumer<StoresManager>(
                    builder: (_, storesManager, __) {
                      if (storesManager.stores.isEmpty) {
                        return LinearProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                          backgroundColor: Colors.transparent,
                        );
                      }

                      return ListView.builder(
                        itemCount: storesManager.stores.length,
                        itemBuilder: (_, index) {
                          return HomeCard(storesManager.stores[index]);
                        },
                      );
                    },
                  ),
                ),
                centerTitle: true,
                snap: true,
                floating: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                flexibleSpace: const FlexibleSpaceBar(),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    color: Colors.white,
                    onPressed: () => Navigator.of(context).pushNamed('/cart'),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
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
                    SizedBox(
                      height: 140,
                    ),
                    Card(
                      color: Colors.red.shade900.withOpacity(0.9),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                      child: Container(
                        height: 40,
                        width: 320,
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          'São Luís - MA',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 250,
                      height: 50,
                      child: GestureDetector(
                        onTap: () {
                          userManager.user?.withdrawal = false;
                          context.read<PageManager>().setPage(1);
                        },
                        child: Card(
                          color: Colors.red.shade900.withOpacity(0.9),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    image: const DecorationImage(
                                      image: AssetImage(
                                          'images/icons/iconDelivery.png'),
                                    ),
                                  ),
                                ),
                                VerticalDivider(
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'DELIVERY',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 250,
                      height: 50,
                      child: GestureDetector(
                        onTap: () {
                          userManager.user?.withdrawal = true;
                          context.read<PageManager>().setPage(1);
                        },
                        child: Card(
                          color: Colors.red.shade900.withOpacity(0.9),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    image: const DecorationImage(
                                      image: AssetImage(
                                          'images/icons/iconLoja.png'),
                                    ),
                                  ),
                                ),
                                VerticalDivider(
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'RETIRADA',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.read<PageManager>().setPage(3);
                      },
                      child: Container(
                        width: 250,
                        height: 50,
                        child: Card(
                          color: Colors.red.shade900.withOpacity(0.9),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    image: const DecorationImage(
                                      image: AssetImage(
                                          'images/icons/iconInfo.png'),
                                    ),
                                  ),
                                ),
                                VerticalDivider(
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'SOBRE NÓS',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
