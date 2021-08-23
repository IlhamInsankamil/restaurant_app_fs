import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app3/data/api/api_service.dart';
import 'package:restaurant_app3/provider/restaurant_provider.dart';

void main() {
  group('favourite restaurant Test', () {
    late RestaurantProvider restaurantProvider;
    late List<String> favouriteRestaurantIDs;
    String testID = 'id1';

    // arrange
    setUp(() async {
      restaurantProvider = RestaurantProvider(apiService: ApiService());
      await restaurantProvider.fetchFavouriteRestaurantIDs();
      favouriteRestaurantIDs = restaurantProvider.ids;
    });

    test('should contain new item when module completed', () {
      // act
      restaurantProvider.addFavouriteRestaurant(testID);
      // assert
      var result = favouriteRestaurantIDs.contains(testID);
      expect(result, true);
    });

    test('should remove an item when module completed', () {
      // act
      restaurantProvider.removeFavouriteRestaurant(testID);
      // assert
      var result = !favouriteRestaurantIDs.contains(testID);
      expect(result, true);
    });
  });
}
