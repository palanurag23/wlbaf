import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wlbaf/models/modelClasses.dart';
import 'package:wlbaf/providers/Bloc_slideshow.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as sfCharts;
import 'package:wlbaf/providers/providers.dart';

class Tab3 extends StatefulWidget {
  @override
  _Tab3State createState() => _Tab3State();
}

class _Tab3State extends State<Tab3> {
  bool autoPlay = false;
  int length = 0;
  bool initialized = false;
  int pics = 7;
  int index = 0;
  int maxIndex = 4;
  List<int> numberOfPics = [7, 30, 90, 180, 360];
  WeightAndPicBloc weightAndPicBloc;
  List<WeightAndPic> weightAndPic = [];

  DateTime dateMin = DateTime(2003, 01, 01);
  DateTime dateMax = DateTime(2070, 01, 01);
  SfRangeValues dateValues =
      SfRangeValues(DateTime(2005, 01, 01), DateTime(2008, 01, 01));
  @override
  void didChangeDependencies() {
    if (!initialized) {
      weightAndPicBloc = WeightAndPicBloc(context, pics);
      length = weightAndPicBloc.getLength();
      setState(() {
        initialized = true;
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    String units = Provider.of<UnitsData>(context).units;

    double ratio = MediaQuery.of(context).size.height / 896;

    var size = MediaQuery.of(context).size;
    return !initialized
        ? CircularProgressIndicator()
        : length == 0
            ? Container(
                child: Center(
                  child: Text(
                    'You have\'nt added any pictures yet',
                    style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.w800,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Open Sans',
                        fontSize: 20),
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Container(
                  child: Column(
                      // color: Colors.black,
                      children: [
                        StreamBuilder<List<WeightAndPic>>(
                          stream: weightAndPicBloc.stream,
                          builder: (ctx, snapshot) {
                            if (snapshot.hasData) {
                              print('snapshot.hasData ${snapshot.hasData}');
                              weightAndPic = snapshot.data;
                              return Column(children: [
                                Container(
                                  child: CarouselSlider.builder(
                                      itemCount: snapshot.data.length,
                                      itemBuilder:
                                          (context, itemIndex, pageViewIndex) {
                                        return Stack(children: [
                                          Center(
                                            child: Stack(
                                              children: [
                                                Card(
                                                  color: Colors.amber,
                                                  semanticContainer: true,
                                                  clipBehavior: Clip
                                                      .antiAliasWithSaveLayer,
                                                  child: Image.file(
                                                    File(snapshot
                                                        .data[itemIndex].path),
                                                    fit: BoxFit.cover,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  elevation: 5,
                                                  margin: EdgeInsets.all(5),
                                                ),
                                                Positioned(
                                                    bottom: 10,
                                                    right: 10,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .blueGrey[900],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      padding: EdgeInsets.only(
                                                          top: 2,
                                                          bottom: 2,
                                                          left: 2 * ratio,
                                                          right: 4 * ratio),
                                                      child: RichText(
                                                        text: TextSpan(
                                                            text: ' ',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                fontSize:
                                                                    20 * ratio,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900),
                                                            children: <
                                                                TextSpan>[
                                                              TextSpan(
                                                                  text: NumberFormat(
                                                                          "###.#")
                                                                      .format(snapshot
                                                                          .data[
                                                                              itemIndex]
                                                                          .weight),
                                                                  style: TextStyle(
                                                                      color:
                                                                          Colors
                                                                              .white,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .normal,
                                                                      fontSize: 15 *
                                                                          ratio,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal)),
                                                              TextSpan(
                                                                  text: ' $units'
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic,
                                                                      fontSize: 10 *
                                                                          ratio,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold))
                                                            ]),
                                                      ),
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ]);
                                      },
                                      options: CarouselOptions(
                                        height: size.height * 0.55,
                                        aspectRatio: 16 / 9,
                                        viewportFraction: 1,
                                        initialPage: 0,
                                        enableInfiniteScroll: true,
                                        reverse: false,
                                        autoPlay: autoPlay,
                                        autoPlayInterval: Duration(
                                            seconds: 1, milliseconds: 500),
                                        autoPlayAnimationDuration:
                                            Duration(milliseconds: 1000),
                                        autoPlayCurve: Curves.fastOutSlowIn,
                                        enlargeCenterPage: true,
                                        // onPageChanged: callbackFunction,
                                        scrollDirection: Axis.horizontal,
                                      )),
                                ),
                                SizedBox(
                                  height: 22,
                                ),
                                Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    // border: Border.all(color: Colors.black, width: 1),
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Colors.grey.withOpacity(0.3),
                                    //     spreadRadius: 5,
                                    //     blurRadius: 7,
                                    //     offset: Offset(03, 3), // changes position of shadow
                                    //   ),
                                    // ]
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        autoPlay = !autoPlay;
                                      });
                                    },
                                    child: Center(
                                      child: Icon(
                                        autoPlay
                                            ? Icons.pause_circle_filled
                                            : Icons.play_circle_fill_rounded,
                                        color: Colors.amber,
                                        size: 55,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.amber[400],
                                    borderRadius: BorderRadius.circular(21),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15 * ratio,
                                      horizontal: 22 * ratio),
//color: Colors.cyan,
                                  margin: EdgeInsets.only(
                                    top: 20 * ratio,
                                    left: 15 * ratio,
                                    right: 15 * ratio,
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (length > snapshot.data.length) {
                                            if (index < 5) {
                                              weightAndPicBloc.addData(
                                                  numberOfPics[index + 1]);
                                              setState(() {
                                                index = index + 1;
                                              });
                                            } else {
                                              weightAndPicBloc.addData(length);
                                            }
                                          }
                                        },
                                        child: Icon(
                                          Icons.arrow_drop_up_outlined,
                                          size: 35,
                                          color: length > snapshot.data.length
                                              ? Colors.white
                                              : Colors.amber[400],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 22,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                            text: ' ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontStyle: FontStyle.italic,
                                                fontSize: 20 * ratio,
                                                fontWeight: FontWeight.w900),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: autoPlay
                                                      ? 'Showing '
                                                      : 'Show ',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 20 * ratio,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              TextSpan(
                                                  text: length >
                                                          snapshot.data.length
                                                      ? 'last '
                                                      : 'all ',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 20 * ratio,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              TextSpan(
                                                  text:
                                                      '${snapshot.data.length}',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 30 * ratio,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              TextSpan(
                                                  text: snapshot.data.length > 1
                                                      ? ' pics'.toString()
                                                      : ' pic'.toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 20 * ratio,
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ]),
                                      ),
                                      SizedBox(
                                        width: 22,
                                      ),
                                      // Text('last ${snapshot.data.length} pics'),
                                      GestureDetector(
                                        onTap: () {
                                          if (index > 0) {
                                            weightAndPicBloc.addData(
                                                numberOfPics[index - 1]);
                                            setState(() {
                                              index = index - 1;
                                            });
                                          }
                                        },
                                        child: Icon(
                                          Icons.arrow_drop_down_sharp,
                                          size: 35,
                                          color: index > 0
                                              ? Colors.white
                                              : Colors.amber[400],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ]);
                            } else {
                              print('snapshot.hasData ${snapshot.hasData}');

                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ]),
                ),
              );
  }
}
