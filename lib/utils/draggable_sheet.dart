import 'package:flutter/material.dart';
import 'package:hellostay/screens/Hotel/homeView.dart';
import 'package:hellostay/widgets/select_date_widget.dart';
import 'package:intl/intl.dart';

import 'date_function.dart';

class MyDraggableSheetState extends StatefulWidget{
  const MyDraggableSheetState({super.key});

  @override
  State<MyDraggableSheetState> createState() => _MyDraggableSheetStateState();
}

class _MyDraggableSheetStateState extends State<MyDraggableSheetState> {
  final _sheet = GlobalKey();

  final _controller = DraggableScrollableController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(_onChanged);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      key: _sheet,
      initialChildSize: 0.5,
      maxChildSize: 1,
      minChildSize: 0,
      expand: true,
      snap: true,
      snapSizes: const [0.5],
      builder: (BuildContext context, ScrollController scrollController) {
        return DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: DefaultTabController(
            length: 2,
            child: CustomScrollView(
              controller: scrollController,
              slivers:  [
                 SliverToBoxAdapter(
                  child: TabBar(
                    tabs: [
                      Tab(icon: InkWell(
                          onTap: () async{
                            String date = await selectDate(context);

                            checkInDate = date ;

                            formattedCheckInDate = DateFormat("dd MMM''yy").format(DateTime.parse(date));
                            checkInDayOfWeek = DateFormat("EEEE").format(DateTime.parse(date));
                          },
                          child: selectDateWidget( 'Check-in', checkInDayOfWeek, formattedCheckInDate,true,context))),
                      Tab(icon: InkWell(
                          onTap: () async{
                            String date = await selectDate(context);

                            checkInDate = date ;

                            formattedCheckOutDate = DateFormat("dd MMM''yy").format(DateTime.parse(date));
                            checkOutDayOfWeek = DateFormat("EEEE").format(DateTime.parse(date));
                          },
                          child: selectDateWidget( 'Check-out', checkOutDayOfWeek, formattedCheckOutDate,true,context)),),
                     // Tab(icon: Icon(Icons.directions_bike)),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 400,
                    child: TabBarView(
                      children: [



                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onChanged() {
    final currentSize = _controller.size;
    if (currentSize <= 0.05) _collapse();
  }

  void _collapse() => _animateSheet(sheet.snapSizes!.first);

  void _anchor() => _animateSheet(sheet.snapSizes!.last);

  void _expand() => _animateSheet(sheet.maxChildSize);

  void _hide() => _animateSheet(sheet.minChildSize);

  void _animateSheet(double size) {
    _controller.animateTo(
      size,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  DraggableScrollableSheet get sheet =>
      (_sheet.currentWidget as DraggableScrollableSheet);
}