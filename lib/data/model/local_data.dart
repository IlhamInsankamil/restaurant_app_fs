import 'dart:convert';

LocalData localDataFromJson(String str) => LocalData.fromJson(json.decode(str));

String localDataToJson(LocalData data) => json.encode(data.toJson());

class LocalData {
  LocalData({
    required this.dailyReminder,
    required this.favouriteRestaurants,
  });

  bool dailyReminder;
  List<FavouriteRestaurant> favouriteRestaurants;

  factory LocalData.fromJson(Map<String, dynamic> json) => LocalData(
        dailyReminder: json["dailyReminder"],
        favouriteRestaurants: List<FavouriteRestaurant>.from(
            json["favouriteRestaurants"]
                .map((x) => FavouriteRestaurant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "dailyReminder": dailyReminder,
        "favouriteRestaurants":
            List<dynamic>.from(favouriteRestaurants.map((x) => x.toJson())),
      };
}

class FavouriteRestaurant {
  FavouriteRestaurant({
    required this.id,
  });

  String id;

  factory FavouriteRestaurant.fromJson(Map<String, dynamic> json) =>
      FavouriteRestaurant(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
