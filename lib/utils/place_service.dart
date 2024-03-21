import 'dart:convert';
import 'dart:developer';

import 'package:hellostay/screens/Hotel/homeView.dart';
import 'package:http/http.dart';
import 'dart:io';

import 'address_search.dart';



class PlaceApiProvider {
  final client = Client();

  PlaceApiProvider(this.sessionToken);

  final sessionToken;

  static const String androidKey = 'AIzaSyDs0Y8pl74wsfvzapoo3JPmTnnun-_Pz3s';
  static const String iosKey = 'AIzaSyDs0Y8pl74wsfvzapoo3JPmTnnun-_Pz3s';
  final apiKey = Platform.isAndroid ? androidKey : iosKey;

  Future<List<Suggestion>> fetchSuggestions(String input, String lang) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=geocode&language=$lang&components=country:in&key=$apiKey&sessiontoken=$sessionToken';
    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {

      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        log(response.body);
        return result['predictions']
             .map<Suggestion>((p) => Suggestion(p['place_id'],p['description'])) ////p['place_id'], p['structured_formatting']['secondary_text']
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<Place> getPlaceDetailFromId(String placeId) async {
    final request = 'https://maps.googleapis.com/maps/api/geocode/json?place_id=$placeId&key=$apiKey';
        //'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=address_component&key=$apiKey&sessiontoken=$sessionToken';
    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      //log(response.body);
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        final components =
        result['results'][0]['address_components'] as List<dynamic>;
        final latLong =
        result['results'][0]['geometry']['location'];
        lat = latLong['lat'] ;
        lng = latLong['lng'];

        // build result
        final place = Place();
        components.forEach((c) {
          final List type = c['types'];
          if (type.contains('street_number')) {
            place.streetNumber = c['long_name'];
          }
          if (type.contains('route')) {
            place.street = c['long_name'];
          }
          if (type.contains('locality')) {
            place.city = c['long_name'];
          }
          if (type.contains('postal_code')) {
            place.zipCode = c['long_name'];
          }
        });


        return place;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }
    // if you want to get the details of the selected place by place_id
  
}

class Place {
  String? streetNumber;
  String? street;
  String? city;
  String? zipCode;

  Place({
    this.streetNumber,
    this.street,
    this.city,
    this.zipCode,
  });

  @override
  String toString() {
    return 'Place(streetNumber: $streetNumber, street: $street, city: $city, zipCode: $zipCode)';
  }
}