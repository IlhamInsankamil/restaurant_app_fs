import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/model/restaurant_list.dart';
import '../provider/restaurant_provider.dart';
import 'restaurant_detail_page.dart';

class RestaurantFavouritePage extends StatelessWidget {
  static const routeName = '/restaurant_favourite';

  Widget _buildList(BuildContext context) {
    return Consumer<RestaurantProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.Loading) {
          return Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.HasData) {
          return state.ids.length < 1
              ? Center(child: Text('You don\'t have any'))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.ids.length,
                  itemBuilder: (context, index) {
                    return _buildRestaurantItem(
                        context,
                        state.results.restaurants
                            .where((element) => element.id == state.ids[index])
                            .first);
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
          child: Icon(Icons.close),
          onTap: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Remove Restaurant'),
              content: const Text(
                  'Are you sure you want to remove from favourites?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Provider.of<RestaurantProvider>(context, listen: false)
                        .removeFavouriteRestaurant(restaurant.id);
                    Navigator.pop(context, 'Remove');
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Removed from Favourites')));
                  },
                  child: const Text('Remove'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, RestaurantDetailPage.routeName,
              arguments: restaurant);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourite Restaurant'),
      ),
      body: _buildList(context),
    );
  }
}
