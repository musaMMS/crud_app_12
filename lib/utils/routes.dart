
import 'package:flutter/material.dart';

import '../controllers/data_repository.dart';
import '../views/addProductScreen/add_product_screen.dart';
import '../views/homeCreen/home_screen.dart';
import '../views/updateProductScreen/update_product_screen.dart';

class Routes{
  static const homeScreen = "/homeScreen";
  static const addProductScreen = "/addProductScreen";
  static const updateProductScreen = "/updateProductScreen";

  static MaterialPageRoute? generateRoute(RouteSettings routeSettings){
    final Map<String,WidgetBuilder> routes = {
      Routes.homeScreen:(context) => const HomeScreen(),
      Routes.addProductScreen:(context){
        DataRepository dataController = routeSettings.arguments as DataRepository;
        return AddProductScreen(dataController: dataController);
      },
      Routes.updateProductScreen : (context){
        Map<String,dynamic> routeData = routeSettings.arguments as Map<String,dynamic>;
        return UpdateProductScreen(dataController: routeData["dataRepository"], product: routeData["product"]);
      }
    };
    final WidgetBuilder? builder = routes[routeSettings.name];
    return (builder !=null) ? MaterialPageRoute(builder: builder) : null;
  }

}