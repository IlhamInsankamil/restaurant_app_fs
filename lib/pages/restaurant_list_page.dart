import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/navigation.dart';
import '../data/model/restaurant_list.dart';
import '../provider/restaurant_provider.dart';
import 'restaurant_detail_page.dart';
import 'restaurant_favourite_page.dart';

class RestaurantListPage extends StatelessWidget {
  Widget _buildList(BuildContext context) {
    return Consumer<RestaurantProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.Loading) {
          return Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.HasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.results.restaurants.length,
            itemBuilder: (context, index) {
              return _buildRestaurantItem(
                  context, state.results.restaurants[index]);
            },
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
                ),
                OutlinedButton(
                  child: Text('Refresh'),
                  onPressed: () {
                    Provider.of<RestaurantProvider>(context, listen: false)
                        .refreshRestaurantList();
                  },
                ),
              ],
            ),
          );
        } else {
          return Center(child: Text(''));
        }
      },
    );
  }

  Widget _buildRestaurantItem(BuildContext context, Restaurant restaurant) {
    return Material(
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: Hero(
          tag: restaurant.id,
          child: CachedNetworkImage(
            height: 50.0,
            width: 80.0,
            placeholder: (context, url) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
            imageUrl: 'https://restaurant-api.dicoding.dev/images/small/' +
                restaurant.pictureId,
          ),
        ),
        title: Text(restaurant.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_pin,
                  size: 12,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(restaurant.city),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.star,
                  size: 12,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(restaurant.rating.toString()),
              ],
            ),
          ],
        ),
        trailing: InkWell(
          child: Provider.of<RestaurantProvider>(context, listen: false)
                  .ids
                  .contains(restaurant.id)
              ? Icon(Icons.favorite)
              : Icon(Icons.favorite_border),
          onTap: () {
            if (Provider.of<RestaurantProvider>(context, listen: false)
                .ids
                .contains(restaurant.id)) {
              Provider.of<RestaurantProvider>(context, listen: false)
                  .removeFavouriteRestaurant(restaurant.id);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Removed from Favourites')));
            } else {
              Provider.of<RestaurantProvider>(context, listen: false)
                  .addFavouriteRestaurant(restaurant.id);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to Favourites')));
            }
          },
        ),
        onTap: () => Navigation.intentWithData(
            RestaurantDetailPage.routeName, restaurant),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant App'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.favorite_sharp),
            tooltip: 'Show Favourite Restaurant',
            onPressed: () {
              Navigator.pushNamed(
                context,
                RestaurantFavouritePage.routeName,
              );
            },
          ),
        ],
      ),
      body: _buildList(context),
    );
  }
}
