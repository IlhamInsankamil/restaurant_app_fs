import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app3/data/api/api_service.dart';
import 'package:restaurant_app3/data/model/restaurant_list.dart';

import 'json_parsing_test.mocks.dart';

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks([http.Client])
void main() {
  group('restaurant API', () {
    test('returns list of restaurants if the http call completes successfully',
        () async {
      final client = MockClient();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse('https://restaurant-api.dicoding.dev/list')))
          .thenAnswer((_) async => http.Response(
              '{"error":false,"message":"success","count":0,"restaurants":[]}',
              200));

      expect(
          await ApiService().allRestaurants(client), isA<RestaurantResult>());
    });
  });
}
