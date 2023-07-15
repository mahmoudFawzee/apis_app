import 'package:apis/logic/blocs/pizza_bloc/pizza_bloc.dart';
import 'package:apis/view/screens/home/pizzas_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoutesManger {
  static final _pizzaBloc = PizzaBloc();
  static Map<String, Widget Function(BuildContext)> routes = {
    PizzasScreen.pageRoute: (context) => BlocProvider.value(
          value: _pizzaBloc..add(const GetPizzasEvent()),
          child: const PizzasScreen(),
        ),
  };
  static const initialRoute = PizzasScreen.pageRoute;
}
