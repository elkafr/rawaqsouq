import 'package:rawaqsouq/screens/auth/login_screen.dart';
import 'package:rawaqsouq/screens/auth/password_recovery_screen.dart';
import 'package:rawaqsouq/screens/auth/register_code_activation_screen.dart';
import 'package:rawaqsouq/screens/auth/register_screen.dart';
import 'package:rawaqsouq/screens/bottom_navigation.dart/bottom_navigation_bar.dart';
import 'package:rawaqsouq/screens/cart/cart_screen.dart';
import 'package:rawaqsouq/screens/intro/our_vision.dart';
import 'package:rawaqsouq/screens/intro/torf_city.dart';
import 'package:rawaqsouq/screens/notifications/notifications_screen.dart';
import 'package:rawaqsouq/screens/order_details/add_new_product_to_order.dart';
import 'package:rawaqsouq/screens/order_details/edit_order_details.dart';
import 'package:rawaqsouq/screens/order_details/order_details.dart';
import 'package:rawaqsouq/screens/orders/orders_screen.dart';
import 'package:rawaqsouq/screens/product/product_screen.dart';
import 'package:rawaqsouq/screens/profile/personal_information_screen.dart';
import 'package:rawaqsouq/screens/splash/splash_screen.dart';
import 'package:rawaqsouq/screens/store/store_screen.dart';


final routes = {
  '/': (context) => SplashScreen(),
  '/our_vision':(context) => OurVision(),
  '/torf_city' :(context) => TorfCity(),
  '/login_screen':(context) => LoginScreen(),
  '/password_recovery_screen':(context) => PasswordRecoveryScreen(),
  '/register_screen':(context) => RegisterScreen(),
  '/store_screen':(context) => StoreScreen(),
  '/navigation':(context) => BottomNavigation(),
  '/product_screen':(context) => ProductScreen(),
  '/cart_screen':(context) => CartScreen(),
  '/orders_screen':(context) => OrdersScreen(),
 '/personal_information_screen':(context) => PersonalInformationScreen(),
  '/notifications_screen' :(context) => NotificationsScreen(),
  '/order_details_screen':(context) => OrderDetailsScreen(),
  '/edit_order_details_screen':(context) => EditOrderDetailsScreen(),
  '/add_new_product_to_order_screen':(context) => AddNewProductToOrderScreen(),
  '/register_code_activation_screen' :(context) => RegisterCodeActivationScreen()



};
