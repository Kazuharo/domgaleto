import 'package:flutter/material.dart';
import 'package:domgaleto/models/admin/admin_orders_manager.dart';
import 'package:domgaleto/models/admin/admin_users_manager.dart';
import 'package:domgaleto/models/cart/cart_manager.dart';
import 'package:domgaleto/models/order/order.dart';
import 'package:domgaleto/models/order/orders_manager.dart';
import 'package:domgaleto/models/product/product.dart';
import 'package:domgaleto/models/product/product_manager.dart';
import 'package:domgaleto/models/stores/stores_manager.dart';
import 'package:domgaleto/models/user/user_manager.dart';
import 'package:domgaleto/screens/address/address_screen.dart';
import 'package:domgaleto/screens/base/base_screen.dart';
import 'package:domgaleto/screens/cart/cart_screen.dart';
import 'package:domgaleto/screens/checkout/checkout_screen.dart';
import 'package:domgaleto/screens/confirmation/confirmation_screen.dart';
import 'package:domgaleto/screens/edit_product/edit_product_screen.dart';
import 'package:domgaleto/screens/login/login_screen.dart';
import 'package:domgaleto/screens/product/product_screen.dart';
import 'package:domgaleto/screens/select_product/select_product_screen.dart';
import 'package:domgaleto/screens/signup/signup_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ProductManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => StoresManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          create: (_) => CartManager(),
          lazy: false,
          update: (_, userManager, cartManager) =>
              cartManager!..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, OrdersManager>(
          create: (_) => OrdersManager(),
          lazy: false,
          update: (_, userManager, ordersManager) =>
              ordersManager!..updateUser(userManager.user),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          lazy: false,
          update: (_, userManager, adminUsersManager) =>
              adminUsersManager!..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminOrdersManager>(
          create: (_) => AdminOrdersManager(),
          lazy: false,
          update: (_, userManager, adminOrdersManager) => adminOrdersManager!
            ..updateAdmin(adminEnabled: userManager.adminEnabled()),
        )
      ],
      child: MaterialApp(
        title: 'Dom Galeto',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
            primary: Color.fromARGB(255, 137, 0, 1),
          ),
          primaryColor: const Color.fromARGB(255, 137, 0, 1),
          scaffoldBackgroundColor: const Color.fromARGB(255, 137, 0, 1),
          appBarTheme: const AppBarTheme(elevation: 0),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/login':
              return MaterialPageRoute(builder: (_) => LoginScreen());
            case '/signup':
              return MaterialPageRoute(builder: (_) => SignUpScreen());
            case '/product':
              return MaterialPageRoute(
                  builder: (_) => ProductScreen(settings.arguments as Product));
            case '/cart':
              return MaterialPageRoute(
                  builder: (_) => CartScreen(), settings: settings);
            case '/address':
              return MaterialPageRoute(builder: (_) => AddressScreen());
            case '/checkout':
              return MaterialPageRoute(builder: (_) => CheckoutScreen());
            case '/edit_product':
              return MaterialPageRoute(
                  builder: (_) =>
                      EditProductScreen(settings.arguments as Product));
            case '/select_product':
              return MaterialPageRoute(builder: (_) => SelectProductScreen());

            case '/confirmation':
              return MaterialPageRoute(
                  builder: (_) =>
                      ConfirmationScreen(settings.arguments as Order));
            case '/':
            default:
              return MaterialPageRoute(
                  builder: (_) => BaseScreen(), settings: settings);
          }
        },
      ),
    );
  }
}
