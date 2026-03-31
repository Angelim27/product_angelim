import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:product_angelim/models/product_model.dart';

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com/products';

  Future<List<Product>> getAllProducts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception("Gagal mengambil data!");
    }
  }
}