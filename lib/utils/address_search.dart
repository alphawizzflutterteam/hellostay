import 'package:flutter/material.dart';
import 'package:hellostay/constants/colors.dart';
import 'package:hellostay/screens/Hotel/homeView.dart';
import 'package:hellostay/utils/place_service.dart';

import 'package:flutter/material.dart';

class AddressSearch extends SearchDelegate<Suggestion> {
  AddressSearch(this.sessionToken) {
    apiClient = PlaceApiProvider(sessionToken);
  }

  final sessionToken;
  PlaceApiProvider? apiClient;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        //close(context,Suggestion());
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    return FutureBuilder(
      future: query.isEmpty
          ? null
          : apiClient?.fetchSuggestions(
          query, Localizations.localeOf(context).languageCode),
      builder: (context, snapshot) {
        if (query.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Enter your Destination'),
                  SizedBox(height: 20,),
              
              
                  Text(
                    "Top Destinations",
                    style: TextStyle(fontSize: 16, fontFamily: 'rubic'),
                  ),
                 // Text("aaa"),
                  Container(
                    height:600, // Provide a height to the container or use constraints
                    child: ListView.builder(
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (){
                              query=city[index];

                            },
                            child: Container(
                              height: 50,
                              // decoration: BoxDecoration(
                              //   borderRadius: BorderRadius.circular(10),
                              //   color:AppColors.primary.withOpacity(.2)
                              //
                              // ),
                              child: Row(
                                children: [
                                  SizedBox(width: 10,),
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(images[index]),
                                  ),
                                  SizedBox(width: 20,),
                                  Text(city[index],style: TextStyle(fontFamily: "rubic",),)

                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(snapshot.data![index].description),
                onTap: () {

                  close(context, snapshot.data![index]);
                },
              ),
            );
          } else {
            return const Center(child: Text('No data found.'));
          }
        }
      },
    );




    //   FutureBuilder(
    //   future: query == ""
    //       ? null
    //       : apiClient?.fetchSuggestions(
    //       query, Localizations.localeOf(context).languageCode),
    //   builder: (context, snapshot) => query == ''
    //       ? Container(
    //     height: 200,
    //         child: ListView.builder(
    //                 itemCount: 2,
    //                 itemBuilder: (context, index) {
    //         Text("aaaaa");
    //
    //                 },
    //
    //               ),
    //       )
    //
    //   // Container(
    //   //   padding: const EdgeInsets.all(16.0),
    //   //   child: const Text('Enter your Destination',style: TextStyle(),),
    //   // )
    //       : snapshot.hasData
    //       ? ListView.builder(
    //     itemBuilder: (context, index) => ListTile(
    //       title:
    //       Text((snapshot.data?[index] as Suggestion).description),
    //       onTap: () {
    //         close(context, snapshot.data?[index] as Suggestion);
    //       },
    //     ),
    //     itemCount: snapshot.data?.length,
    //   )
    //       : const Text('Loading...'),
    // );
  }
}


class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}