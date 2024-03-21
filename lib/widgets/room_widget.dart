
import 'package:flutter/material.dart';
import 'package:hellostay/constants/colors.dart';
import 'package:hellostay/model/hotel_detail_response.dart';

import '../screens/Hotel/BookNowDetails.dart';
import 'custom_image.dart';
import 'fevoriteBox.dart';

class FeatureItem extends StatelessWidget {




  const FeatureItem({
    Key? key,
     this.data,
    this.width = 280,
    this.height = 300,
    this.onTap,
    this.onTapFavorite,this.onTapBook
  }) : super(key: key);

  final Room? data;
  final double width;
  final double height;
  final GestureTapCallback? onTapFavorite;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onTapBook;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.sizeOf(context).width,
       // height: height,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.faqanswerColor.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(1, 1), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

        Row(
        children: [
        CustomImage(
        data?.image ??' ',
          // width: double.infinity,
          isNetwork: true,
          height: 100,
          radius: 1,
        ),
        Container(
          width:MediaQuery.sizeOf(context).width*.5,
          padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildName(),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GridView.count(
                  shrinkWrap: true,
                  childAspectRatio: 2.65,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  crossAxisCount: 3,
                  children: List<Widget>.generate(data?.termFeatures?.length ?? 0, (index) {
                    var item =data?.termFeatures?[index];
                    return Column(
                      children: [
                        Row(
                          children: [
                            item!.title.toLowerCase().contains('wake')
                                ? const Icon(
                              Icons.watch_later_outlined,
                              size: 11,
                              color: AppColors.primary,
                            )
                                : item.title.toLowerCase().contains('tv')
                                ? const Icon(
                              Icons.tv,
                              size: 11,
                              color: AppColors.primary,
                            )
                                : item.title.toLowerCase().contains('laundry')
                                ? const Icon(
                              Icons.local_laundry_service,
                              size:11,
                              color: AppColors.primary,
                            )
                                : item.title
                                .toLowerCase()
                                .contains('wifi')
                                ? const Icon(
                              Icons.wifi,
                              size: 10,
                              color: AppColors.primary,
                            )
                                : const Icon(
                              Icons.coffee,
                              size: 11,
                              color: AppColors.primary,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Text(
                              data?.termFeatures?[index].title ?? '',
                                style: const TextStyle(
                                    fontFamily: "open-sans",
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 5.0),
                              ),
                            ),
                          ],
                        ),
                        /*Row(children: [
                        const Icon(Icons.person, size: 24, color:AppColor.activeColor ,),
                        const SizedBox(width: 5,),
                        Expanded(
                          child: Text(
                            'Max People ${model!.row!.maxPeople} ',
                            style:const TextStyle(
                                fontFamily: "open-sans",
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0),
                          ),
                        ),

                      ],),*/
                      ],
                    );
                  }),
                ),
              ),
              _buildInfo(),

            ],
          ),
        )
        ],
      ),
            Divider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(

                  child: InkWell(
                    onTap: (){
                      _showCustomDialog(context);
                    },
                    child: Row(
                    //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                      children: [
                        Text("Non Refundable"
                        ),
                        SizedBox(width: 10,),
                        Icon(Icons.error_outline,color: Colors.blue,)
                      ],
                    ),
                  ),
                ),

                InkWell(
                onTap: onTapBook
                //   onTap: (){
                //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BookNowDetails(title: data?.title ?? '' ,imageUrl: data?.image ??"",)));
                //   }
                  ,
                  child: Container(height: 40,
                  width:150,
                  decoration:BoxDecoration(borderRadius: BorderRadius.circular(5),
                      color: AppColors.primary) , child: Center(child: Text("Book Now",style: TextStyle(
                        color: AppColors.whiteTemp
                    ),))
                    ,),
                ),



                // ElevatedButton(
                //     onPressed: onTapBook, child: const Text('Book Now')),
              ],
            ),

            Divider(),

            // _buildImage(),
            // Container(
            //   width: width - 20,
            //   padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       _buildName(),
            //       const SizedBox(
            //         height: 5,
            //       ),
            //       _buildInfo(),
            //
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String inputText = '';

        return AlertDialog(
          title: const Text(
            'Cancellation Policy',
            style: TextStyle(fontFamily: "rubic",fontSize: 18),
          ),
          content: Container(
            height: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Cancelled",style: TextStyle(fontFamily: "rubic",fontSize: 14),),
                Text("100% of booking amount.",style: TextStyle(fontFamily: "rubic",fontSize: 14),),
                SizedBox(height: 5,),
                Container(

                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.5),
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Please note that failure to check-in may result in a charge of up to the full cost of your stay, including taxes and service fees."
                      ,style: TextStyle(fontFamily: "rubic",fontSize: 12),
                      ),
                    )),
              ],
            ),
          ),

          actions: <Widget>[
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Text('GOT IT',style: TextStyle(color: Colors.blue,fontFamily: "rubic"),),
            ),
          ],
        );
      },
    );
  }
  Widget _buildName() {
    return Text(
      data?.title ?? '',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 16,
        //fontFamily: "rubic",
       // color: Colors.black,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
         Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text(
            //   'type',
            //   maxLines: 1,
            //   overflow: TextOverflow.ellipsis,
            //   style: TextStyle(
            //     color: AppColors.blackTemp,
            //     fontSize: 13,
            //   ),
            // ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Text(
                 '   ${data?.totPriceText}' ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

              ],
            ),

          ],
        ),



      ],
    );
  }

  Widget _buildImage() {
    return  Row(
      children: [
        CustomImage(
          data?.image ??' ',
         // width: double.infinity,
          isNetwork: true,
          height: 80,
          radius: 15,
        ),
        Container(
          width:200,
          padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildName(),
              const SizedBox(
                height: 5,
              ),
              _buildInfo(),

            ],
          ),
        )
      ],
    );
  }


}