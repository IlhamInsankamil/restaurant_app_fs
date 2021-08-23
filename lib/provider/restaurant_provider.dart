import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../data/api/api_service.dart' as service;
import '../data/model/local_data.dart';
import '../data/model/restaurant_detail.dart' as res_detail;
import '../data/model/restaurant_list.dart' as res_list;
import '../helper/shared_pref_operations.dart';

enum ResultState { Loading, NoData, HasData, Error }

class RestaurantProvider extends ChangeNotifier {
  final service.ApiService apiService;
  String? id;
  List<String> ids = [];

  RestaurantProvider({required this.apiService, this.id}) {
    fetchFavouriteRestaurantIDs();
    if (id != null)
      _fetchDetailRestaurant();
    else
      fetchAllRestaurants();
  }

  late res_detail.RestaurantResult _restaurantDetailResult;
  late res_list.RestaurantResult _restaurantResult;
  late LocalData localDataResult;
  late bool dailyNotification;

  String _message = '';
  late ResultState _state;

  String get message => _message;

  ResultState get state => _state;

  res_detail.RestaurantResult get resultDetail => _restaurantDetailResult;

  res_list.RestaurantResult get results => _restaurantResult;

  Future<dynamic> fetchAllRestaurants() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final restaurant = await apiService.allRestaurants(http.Client());
      if (restaurant.error) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = restaurant.message;
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurantResult = restaurant;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }

  Future<dynamic> _fetchDetailRestaurant() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final restaurant = await apiService.detailRestaurant(id!);
      if (restaurant.error) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = restaurant.message;
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurantDetailResult = restaurant;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }

  fetchFavouriteRestaurantIDs() async {
    try {
      localDataResult = localDataFromJson(await SharedPref().readLocalData());
      ids = localDataResult.favouriteRestaurants
          .map((value) => value.id)
          .toList();
      dailyNotification = localDataResult.dailyReminder;
    } catch (Exception) {
      SharedPref()
          .saveLocalData('{"dailyReminder":false,"favouriteRestaurants":[]}');
      localDataResult = localDataFromJson(await SharedPref().readLocalData());
      ids = localDataResult.favouriteRestaurants
          .map((value) => value.id)
          .toList();
      dailyNotification = localDataResult.dailyReminder;
    }
  }

  _updateDataFavouritesAndNotification() async {
    List<FavouriteRestaurant> listFavouriteRestaurant = [];
    ids.forEach((element) =>
        listFavouriteRestaurant.add(FavouriteRestaurant(id: element)));

    localDataResult.favouriteRestaurants = listFavouriteRestaurant;
    localDataResult.dailyReminder = dailyNotification;

    await SharedPref().saveLocalData(localDataToJson(localDataResult));
  }

  void addFavouriteRestaurant(String id) {
    ids.add(id);
    _updateDataFavouritesAndNotification();
    notifyListeners();
  }

  void removeFavouriteRestaurant(String id) {
    ids.remove(id);
    _updateDataFavouritesAndNotification();
    notifyListeners();
  }

  void refreshRestaurantList() {
    fetchFavouriteRestaurantIDs();
    fetchAllRestaurants();
  }

  void turnDailyNotification(bool value) {
    dailyNotification = value;
    _updateDataFavouritesAndNotification();
    notifyListeners();
  }
}
