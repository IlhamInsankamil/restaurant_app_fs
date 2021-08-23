import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/api/api_service.dart';
import '../data/model/restaurant_list.dart';
import '../provider/restaurant_provider.dart';
import '../widgets/card_widget.dart';
import '../widgets/chip_widget.dart';

class RestaurantDetailPage extends StatelessWidget {
  static const routeName = '/restaurant_detail';

  final Restaurant restaurant;

  const RestaurantDetailPage({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
      ),
      body: ChangeNotifierProvider<RestaurantProvider>(
        create: (_) =>
            RestaurantProvider(apiService: ApiService(), id: restaurant.id),
        child: Consumer<RestaurantProvider>(
          builder: (context, state, _) {
            if (state.state == ResultState.Loading) {
              return Center(child: CircularProgressIndicator());
            } else if (state.state == ResultState.HasData) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Hero(
                      tag: restaurant.id,
                      child: CachedNetworkImage(
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        imageUrl:
                            'https://restaurant-api.dicoding.dev/images/medium/' +
                                restaurant.pictureId,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            restaurant.name,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_pin,
                                size: 12,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(restaurant.city +
                                  ' (' +
                                  state.resultDetail.restaurant.address +
                                  ')'),
                            ],
                          ),
                          Divider(color: Colors.grey),
                          Text(
                            'Description',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(restaurant.description),
                          Divider(color: Colors.grey),
                          Text(
                            'Foods',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Wrap(
                            children: state.resultDetail.restaurant.menus.foods
                                .map((x) =>
                                    ChipWidget(name: x.name, type: 'food'))
                                .toList(),
                          ),
                          Divider(color: Colors.grey),
                          Text(
                            'Drinks',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Wrap(
                            children: state.resultDetail.restaurant.menus.drinks
                                .map((x) =>
                                    ChipWidget(name: x.name, type: 'drinks'))
                                .toList(),
                          ),
                          Divider(color: Colors.grey),
                          Text(
                            'Reviews',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            height: 130.0,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children:
                                  state.resultDetail.restaurant.customerReviews
                                      .map((x) => CardWidget(
                                            customerReview: x,
                                          ))
                                      .take(5)
                                      .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state.state == ResultState.NoData) {
              return Center(child: Text(state.message));
            } else if (state.state == ResultState.Error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Please check your internet connection!'),
                    )
                  ],
                ),
              );
            } else {
              return Center(child: Text(''));
            }
          },
        ),
      ),
    );
  }
}
