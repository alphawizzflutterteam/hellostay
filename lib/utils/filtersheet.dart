import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hellostay/model/filtersModel.dart';

class SelectedModel {
  final int id;
  final String name;

  SelectedModel({required this.id, required this.name});
}

class BottomSheetContent extends StatefulWidget {
  final List<FiltersModelDatum> filterListt;

  final List<String> trendingfilters = [
    'OYOIs welcomes couples',
    'Local IDs accepted',
    'Flagship'
  ];

  final List<FiltersModelDatum> filterListtItems = [];

  final List<String> collection = [
    'Couple friendly',
    'Local ID accepted',
    'Luxury OYOs',
    'Super OYO'
  ];
  final List<String> categories = [
    'Townhouse',
    'Flagship1',
    'Silver Key',
    'Collection O',
    'Spot On',
    'Capital O',
    'Townhouse Oak',
    'Home'
  ];
  final List<String> hotelfacilities = [
    'AC',
    'Coffee/tea maker',
    'Room service',
    'Power backup',
    'Daily houseekeeping Geyser',
    'TV',
    'Free Wifi',
    'Refrigerator'
  ];
  final List<String> roomfacilities = [
    'TV/Cable chgannel',
    'Towel',
    'Electric Kettle',
    'Cutlery/crockery',
    'Internet Access'
  ];

  final RangeValues selectedRange;
  final RangeValues selectedRangeStar;
  // final List<String> selectedItems;
  final List<SelectedModel> selectedItems;

  final ValueChanged<RangeValues> onChangedRange;
  final ValueChanged<List<SelectedModel>> onChangedItems;
  final ValueChanged<bool> onClearAll;

  BottomSheetContent({
    Key? key,
    required this.selectedRange,
    required this.selectedItems,
    required this.onChangedRange,
    required this.onChangedItems,
    required this.filterListt,
    required this.selectedRangeStar,
    required this.onClearAll,
  }) : super(key: key);

  @override
  State<BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  late RangeValues _currentRange;
  late List<SelectedModel> currentList = [];

  String minPrice = "";
  String maxPrice = "";
  String selectedRating = "5";
  String selectedReview = "5";

  @override
  void initState() {
    print("mmmmmmmmmmmmm");
    print(widget.filterListt[0].min);
    print(widget.filterListt[0].max);
    super.initState();
    _currentRange = widget.selectedRange;
    currentList = List<SelectedModel>.from(widget.selectedItems);

  }

  updatePriceRange() {
    setState(() {
      minPrice = _currentRange.start.toString();
      maxPrice = _currentRange.end.toString();
    });
  }

  @override
  void didUpdateWidget(covariant BottomSheetContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    _currentRange = widget.selectedRange;

    currentList = List<SelectedModel>.from(widget.selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 20),
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.cancel, color: Colors.black),
                  ),
                  const SizedBox(width: 10),
                  const Text('Filters',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(width: MediaQuery.of(context).size.width / 2),
                  InkWell(
                    onTap: () {

                      setState(() {
                        currentList.clear();
                        widget.selectedItems.clear();
                        selectedRating = "5";
                        selectedReview = "5";
                      });
                      widget.onClearAll(true);
                    },
                    child: const Text('Clear All',
                        style: TextStyle(
                            fontSize: 15, color: Colors.lightBlueAccent)),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                children: currentList.map((item) {
                  return Chip(
                    label: Text(item.name),
                    deleteIcon: Icon(Icons.cancel),
                    onDeleted: () {
                      setState(() {
                        currentList.remove(item);
                        widget.onChangedItems(currentList);
                        widget.selectedItems.remove(item);
                      });
                    },
                  );
                }).toList(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Highest rated Hotels'),
                  /*Text('Show OYOs with rating <' + selectedRating,
                      style: TextStyle(color: Colors.grey)),*/
                ],
              ),
              // Icon(Icons.remove_circle, color: Colors.black,),
              const SizedBox(
                height: 10,
              ),

              ListView.builder(
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.filterListt[3].data.length,
                  itemBuilder: (context, i) {
                    var item = widget.filterListt[3].data[i];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 1,
                              crossAxisSpacing: 1.4,
                              childAspectRatio: 2.1,
                            ),
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: item.terms.length,
                            itemBuilder: (context, j) {
                              var data = item.terms[j];
                              var category = data;
                              return FilterChip(
                                label: Text(
                                  data.name,
                                  style: TextStyle(fontSize: 13),
                                ),
                                selected: currentList.contains(SelectedModel(
                                    id: data.id, name: data.name)),
                                backgroundColor: Colors.blueGrey,
                                labelStyle: TextStyle(color: Colors.white),
                                onSelected: (isSelected) {
                                  print(data.id);
                                  print(data.name);
                                  print(currentList.contains(SelectedModel(
                                      id: data.id, name: data.name)));
                                  print("++++++++"+currentList.any((element) => element.id == data.id).toString());
                                  setState(() {
                                    if (currentList.any((element) => element.id == data.id)) {
                                      print("TRUE1111");
                                      // currentList.remove(SelectedModel(
                                      //     id: data.id, name: data.name));
                                      // widget.selectedItems.remove(SelectedModel(
                                      //     id: data.id, name: data.name));
                                    } else {
                                      print("FALSE1111111");
                                      currentList.add(SelectedModel(
                                          id: data.id, name: data.name));
                                      widget.selectedItems.add(SelectedModel(
                                          id: data.id, name: data.name));
                                      print(currentList.toString());
                                    }
                                    print("+++++++++++++++++++kkkkkk");
                                    widget.onChangedItems(currentList);

                                    // if (isSelected) {
                                    //   widget.selectedItems.add(SelectedModel(
                                    //       id: data.id, name: data.name));
                                    //   currentList.add(SelectedModel(
                                    //       id: data.id, name: data.name));
                                    //   widget.onChangedItems(currentList);
                                    // } else {
                                    //   widget.selectedItems.remove(SelectedModel(
                                    //       id: data.id, name: data.name));
                                    //   currentList.remove(SelectedModel(
                                    //       id: data.id, name: data.name));
                                    //   widget.onChangedItems(currentList);
                                    // }

                                    // for (int i = 0;
                                    //     i < widget.selectedItems.length;
                                    //     i++) {
                                    //   print(widget.selectedItems[i].name
                                    //       .toString());
                                    // }
                                  });
                                },
                              );
                            }),
                        // Wrap(
                        //   spacing: 8.0,
                        //   children: widget.categories.map((category) {
                        //     return FilterChip(
                        //       label: Text(category),
                        //       selected: widget.selectedItems.contains(category),
                        //       backgroundColor: Colors.blueGrey,
                        //       labelStyle: TextStyle(color: Colors.white),
                        //       onSelected: (isSelected) {
                        //         setState(() {
                        //           if (isSelected) {
                        //             widget.selectedItems.add(category);
                        //             currentList.add(category);
                        //             widget.onChangedItems(currentList);
                        //           } else {
                        //             widget.selectedItems.remove(category);
                        //             currentList.remove(category);
                        //             widget.onChangedItems(currentList);
                        //           }
                        //         });
                        //       },
                        //     );
                        //   }).toList(),
                        // ),

                        SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Price Range",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  Text("Excluding taxes & fee",
                      style: TextStyle(fontSize: 15, color: Colors.grey)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      "₹" +
                          double.parse(_currentRange.start.toString())
                              .toInt()
                              .toString() +
                          "- ₹" +
                          double.parse(_currentRange.end.toString())
                              .toInt()
                              .toString(),
                      style: TextStyle(fontSize: 15, color: Colors.grey)),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: RangeSlider(
                      values: _currentRange,
                      min: double.parse(widget.filterListt[0].min),
                      max: double.parse(widget.filterListt[0].max),
                      divisions: 9,
                      onChanged: (RangeValues values) {
                        setState(() {
                          print("mmmmmmmmmmmmm");
                          print(widget.filterListt[0].min);
                          print(widget.filterListt[0].max);
                          _currentRange = values;
                          updatePriceRange();
                        });
                        widget.onChangedRange(_currentRange);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Hotel Star",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  RatingBar.builder(
                    initialRating: 5,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      size: 10,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                      selectedRating = rating.toString();
                      setState(() {});
                    },
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Review Score",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  RatingBar.builder(
                    initialRating: 5,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      size: 10,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                      selectedReview = rating.toString();
                      setState(() {});
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
