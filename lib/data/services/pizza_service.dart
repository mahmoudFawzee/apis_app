import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:apis/data/constants/end_points.dart';
import 'package:apis/data/models/pizza.dart';
import 'package:http/http.dart' as http;

class PizzaService {
  PizzaService._internal();
  static final PizzaService _pizzaService = PizzaService._internal();
  //this is the constructor we get each time we call the class to get object.
  factory PizzaService() {
    return _pizzaService;
  }

  Future<int> getNewPizzaId() async {
    try {
      List<int> ids = [];
      final url = Uri.https(EndPoints.authority, EndPoints.getPath);
      final response = await http.get(url);
      if (response.statusCode == HttpStatus.ok) {
        if (response.body.isEmpty) return 0;
        final jsonResponse = json.decode(response.body);

        jsonResponse.map<Pizza>((item) {
          final pizza = Pizza.fromJson(jsonObj: item);
          ids.add(pizza.id);
        });
      }
      ids.sort();
      log('ids:$ids');
      log('last id ${ids.last}');
      return ids.last + 1;
    } catch (e) {
      log(e.toString());
      return 0;
    }
  }

  Future<List<Pizza>?> getPizzas() async {
    final url = Uri.https(EndPoints.authority, EndPoints.getPath);
    final response = await http.get(url);
    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      final List<Pizza> pizzas = jsonResponse
          .map<Pizza>((pizza) => Pizza.fromJson(jsonObj: pizza))
          .toList();
      return pizzas;
    } else {
      log('${response.statusCode}');
      return null;
    }
  }

  Future<String?> postPizza(Pizza pizza) async {
    try {
      final pizzaBody = json.encode(pizza.toJson());
      final url = Uri.http(EndPoints.authority, EndPoints.postPath);
      http.Response response = await http.post(url, body: pizzaBody);
      log('status code : ${response.statusCode}');
      if (response.statusCode == HttpStatus.created) {
        return response.body;
      }
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<bool?> updatePizza(Pizza pizza) async {
    try {
      final jsonObj = json.encode(pizza.toJson());
      final url = Uri.https(EndPoints.authority, EndPoints.postPath);
      final response = await http.put(url, body: jsonObj);
      log('${response.statusCode}');
      log(response.body);
      if (response.statusCode == HttpStatus.ok) {
        return true;
      }
      return false;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<bool?> deletePizza(int id) async {
    try {
      final url = Uri.https(EndPoints.authority, EndPoints.postPath);
      final result = await http.delete(url);
      log(result.body);
      log('${result.statusCode}');
      if (result.statusCode == HttpStatus.ok) {
        return true;
      }
      return false;
    } catch (e) {
      return null;
    }
  }
}
