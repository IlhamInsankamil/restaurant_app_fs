import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restaurant_app3/data/model/restaurant_detail.dart'
    as res_detail;
import 'package:restaurant_app3/data/model/restaurant_list.dart' as res_list;

class ApiService {
  static final String _baseUrl = 'https://restaurant-api.dicoding.dev/';

  Future<res_list.RestaurantResult> allRestaurants(http.Client client) async {
    final response = await client.get(Uri.parse(_baseUrl + 'list'));
    if (response.statusCode == 200) {
      return res_list.RestaurantResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Restaurants');
    }
  }

  Future<res_detail.RestaurantResult> detailRestaurant(String id) async {
    final response = await http.get(Uri.parse(_baseUrl + 'detail/$id'));
    if (response.statusCode == 200) {
      return res_detail.RestaurantResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load detail Restaurant');
    }
  }
}
