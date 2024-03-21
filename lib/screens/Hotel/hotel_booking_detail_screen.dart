import 'package:flutter/material.dart';

class HotelBookingDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Hotel Booking Detail'),

        ),
        body: Column(children: [
          SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
            Image.network(
              'https://pix10.agoda.net/hotelImages/124/1246280/1246280_16061017110043391702.jpg?',
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
                    const Text(
                      'Hotel XYZ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '123 Main St, New York, NY 10001',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed commodo erat ut lectus auctor bibendum. Fusce ac nisl eget velit sagittis interdum nec vel neque. Donec ut aliquet augue, ac pharetra libero. Fusce sit amet dui eu libero fringilla efficitur. Donec dignissim, nulla at mattis lobortis, risus est commodo sapien, a feugiat sapien massa non risus. Nullam sit amet ullamcorper tellus. Sed id tellus tellus. ',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Amenities',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.local_parking,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Free parking',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.pool,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Outdoor pool',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.pets,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Pet-friendly',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

          ]))
        ]));
  }
}







