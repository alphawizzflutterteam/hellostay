import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hellostay/constants/colors.dart';

class TravelDetailsTile extends StatefulWidget {

   TravelDetailsTile({super.key,this.isFromHome});

  bool? isFromHome ;

  @override
  State<TravelDetailsTile> createState() => _TravelDetailsTileState();
}

List<int> adultCountList = [];
List<int> childrenCountList = [];
int adultCount1 = 2;
int childrenCount1 = 0;
int room = 1;
List<List<int?>> childrenCountListOfList = [];


class _TravelDetailsTileState extends State<TravelDetailsTile> {
  int adultCount = 2;

  int childrenCount = 0;
  List<List<int>> childrenAgesList = [];

  List<int?> childrenAgesSelected = [];
  List<List<int?>> childrenAgesSelectedList = [];



  int? childrenAge;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.isFromHome ?? false) {
      adultCountList.add(adultCount);
      childrenCountList.add(childrenCount);
      childrenCountListOfList.add(childrenAgesSelected);
      print('adult1-------${adultCountList.length}');
      print('children------${childrenCountList.length}');
      print('adult count-----${adultCount1}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title:
          Text('${adultCount1 + childrenCount1} Guests, $room Room', style: TextStyle(fontFamily: 'rubic',fontSize: 16),),
      children: [
        Wrap(
            children: List<Widget>.generate(room, (index) {
          return addRoom(index);
        })),
        const SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            InkWell(
                onTap: () {
                  childrenAgesSelected = [];
                  room++;
                  adultCount1+=2;
                  adultCountList.add(adultCount);
                  childrenCountList.add(childrenCount);
                  childrenCountListOfList.add(childrenAgesSelected);
                  print('${childrenCountListOfList.length}_________');

                  setState(() {});
                },
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.primary)),
                  child: const Center(
                    child: Text(
                      'Add',
                      style: TextStyle(color: AppColors.primary,fontFamily: 'rubic'),
                    ),
                  ),
                )),
            const SizedBox(
              width: 50,
            ),
            InkWell(
                onTap: () {
                  if(room > 1 ) {
                    room--;

                    adultCountList.removeLast();
                    childrenCountList.removeLast();
                    adultCount1 = adultCountList.reduce((value, element) => value + element);
                    childrenCount1 = childrenCountList.reduce((value, element) => value + element);

                    childrenCountListOfList.removeLast();
                    setState(() {});
                  }
                },
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.primary)),

                  child: const Center(
                    child: Text(
                      'Remove',
                      style: TextStyle(color: AppColors.primary,fontFamily: 'rubic'),
                    ),
                  ),
                ))
          ],
        ),
        const SizedBox(height: 10,)
      ],
    );
  }

  Widget _buildChildrenDropdowns(int index) {
    return Wrap(
      children: List<Widget>.generate(childrenCountList[index], (i) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(color: Colors.grey),
          ),
          child: DropdownButton2<int>(

            underline: const SizedBox(),
            isDense: true,
            hint: const Text('Age',),
            value: childrenCountListOfList[index][i],
            onChanged: (value) {
              setState(() {
                // childrenAgesSelected[i] = value;
                childrenCountListOfList[index][i] = value;
              });
            },
            items: List.generate(12, (index) => index + 1)
                .map((age) => DropdownMenuItem<int>(

                      value: age,
                      child: Text('$age'),
                    ))
                .toList(),
          ),
        );
      }),
    );
  }

  Widget _buildIncrementDecrement(
      String label, int count, Function(int) onChanged, int index) {
    return Column(
      children: [
        Text(label),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.faqanswerColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: IconButton(

                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),


                    icon: const Icon(Icons.remove,),
                    onPressed: () {
                      if (count > 0) {
                        onChanged(count - 1);
                        if(label == 'Adults'){
                          adultCount1--;
                        }else {
                          childrenCount1--;
                          childrenCountListOfList[index].removeLast();
                          //childrenAgesSelected.removeLast();
                        }


                        // _updateChildrenAgesList();
                      }
                    },
                  ),
                ),
              ),
              Container(
                color: AppColors.faqanswerColor.withOpacity(0.3),
                  padding: const EdgeInsets.symmetric(vertical: 7,horizontal: 12),
                  child: Text('$count')),
              SizedBox(
                height: 30,
                width:30,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),

                  icon: const Icon(Icons.add),
                  onPressed: () {

                    print(childrenAgesSelected);

                    onChanged(count + 1);
                    if(label == 'Adults'){
                      adultCount1++;
                    }else {
                      childrenCount1++;
                      childrenCountListOfList[index].add(childrenAge);
                     // childrenAgesSelected.add(childrenAge);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget addRoom(int index) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildIncrementDecrement('Adults', adultCountList[index], (value) {
              setState(() {
                adultCountList[index] = value;

                //adultCount = value;
              });
            }, index),
            _buildIncrementDecrement('Children', childrenCountList[index],
                (value) {
              setState(() {
                childrenCountList[index] = value;
                //  childrenCount = value;
              });
            }, index),
          ],
        ),
        if (childrenCountList[index] > 0)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              childrenCountList[index] > 1
                  ? const Text('Age of Children')
                  : Text('Age of Child'),
              _buildChildrenDropdowns(index),
            ],
          ),
      ],
    );
  }
}
