import 'dart:io' as io;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wlbaf/models/modelClasses.dart';
import 'package:wlbaf/screens/GalleryViewScreen.dart';
import '../providers/providers.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import '../models/modelClasses.dart';

class MonthsWeightAndPicsScreen extends StatefulWidget {
  static const routeName = '/MonthsWeightAndPicsScreen';
  // MonthsWeightAndPicsScreen({Key? key}) : super(key: key);

  @override
  _MonthsWeightAndPicsScreenState createState() =>
      _MonthsWeightAndPicsScreenState();
}

class _MonthsWeightAndPicsScreenState extends State<MonthsWeightAndPicsScreen> {
  int id;
  List<WeightAndPic> weightAndPicList;
  List<WeightAndPic> pictureAndWeightList = [];
  bool initialized = false;
  ScreenArguments args;
  String appBarTitle = '';
  String units;
  bool lastDelete = false;
  @override
  void didChangeDependencies() {
    if (!initialized) {
      units = Provider.of<UnitsData>(context, listen: false).units;

      args = ModalRoute.of(context).settings.arguments;
      id = Provider.of<CurrentJourney>(context, listen: false).get();
      weightAndPicList = args.list;
      appBarTitle = args.appBarTitle;
      weightAndPicList.forEach((element) {
        if (element.havePicture) {
          pictureAndWeightList.add(element);
        }
      });

      setState(() {
        initialized = true;
      });
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double ratio = MediaQuery.of(context).size.height / 896;
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.blueGrey[50],
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.blueGrey[600]),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(appBarTitle,
              style: TextStyle(
                  color: Colors.blueGrey[600],
                  fontStyle: FontStyle.italic,
                  fontSize: 22 * ratio,
                  fontWeight: FontWeight.w900)),
        ),
        body: lastDelete
            ? Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed('/AddNewJourney');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: 20 * ratio, horizontal: 22 * ratio),
//color: Colors.cyan,
                    margin: EdgeInsets.only(
                      top: 20 * ratio,
                      left: 15 * ratio,
                      right: 15 * ratio,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Spacer(),
                        Icon(
                          Icons.pedal_bike_outlined,
                          color: Colors.white,
                          size: 33 * ratio,
                        ),
                        SizedBox(
                          width: 12 * ratio,
                        ),
                        Text('Start new journey !',
                            style: TextStyle(
                                color: Colors.white,
                                fontStyle: FontStyle.normal,
                                fontSize: 20 * ratio,
                                fontWeight: FontWeight.bold)),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              )
            : SingleChildScrollView(
                child: !initialized
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : new StaggeredGridView.countBuilder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        crossAxisCount: 9,
                        itemCount: weightAndPicList.length,
                        itemBuilder: (BuildContext context, int index) =>
                            weightAndPicList[index].havePicture
                                ? Stack(children: [
                                    ImageCard(
                                        units: units,
                                        index: index,
                                        pictureAndWeightList:
                                            pictureAndWeightList,
                                        element: weightAndPicList[index],
                                        ratio: ratio,
                                        args: args),
                                    Positioned(
                                      child: IconButton(
                                        onPressed: () async {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text("Are you sure ?"),
                                                  content: Text(
                                                      "This picture will be permanently deleted from here."),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('cancel')),
                                                    TextButton(
                                                        onPressed: () async {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(SnackBar(
                                                                  duration: Duration(
                                                                      seconds:
                                                                          1),
                                                                  backgroundColor:
                                                                      Colors.blueGrey[
                                                                          700],
                                                                  content: Text(
                                                                      'Weight and Picture deleted')));
                                                          bool shouldNavigate =
                                                              Provider.of<WeightAndPicturesData>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .weightAndPics
                                                                      .length ==
                                                                  1;
                                                          await Provider.of<
                                                                      WeightAndPicturesData>(
                                                                  context,
                                                                  listen: false)
                                                              .deleteSingleWeightAndPics(
                                                                  weightAndPicList[
                                                                          index]
                                                                      .dateTime,
                                                                  id);
                                                          pictureAndWeightList
                                                              .removeWhere((element) =>
                                                                  element
                                                                      .dateTime ==
                                                                  weightAndPicList[
                                                                          index]
                                                                      .dateTime);
                                                          setState(() {
                                                            weightAndPicList.removeWhere((element) =>
                                                                element
                                                                    .dateTime ==
                                                                weightAndPicList[
                                                                        index]
                                                                    .dateTime);
                                                          });
                                                          if (shouldNavigate) {
                                                            setState(() {
                                                              lastDelete = true;
                                                            });
                                                            // Navigator.of(context).popUntil(
                                                            //      ModalRoute.withName('name'));
                                                            // Navigator.of(context)
                                                            //     .pushReplacementNamed(
                                                            //         '/AddNewJourney');
                                                          }
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text(
                                                          'delete',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .redAccent),
                                                        )),
                                                  ],
                                                );
                                              });
                                        },
                                        icon: Icon(Icons.delete),
                                        color: Colors.white,
                                      ),
                                      top: 0,
                                      left: 0,
                                    ),
                                  ])
                                : Stack(children: [
                                    WithoutImageCard(
                                        units: units,
                                        element: weightAndPicList[index],
                                        ratio: ratio,
                                        args: args),
                                    Positioned(
                                      child: IconButton(
                                        onPressed: () async {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                    title:
                                                        Text("Are you sure ?"),
                                                    content: Text(
                                                        "Are you sure you want to delete this entry."),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child:
                                                              Text('cancel')),
                                                      TextButton(
                                                          onPressed: () async {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(SnackBar(
                                                                    duration: Duration(
                                                                        seconds:
                                                                            1),
                                                                    backgroundColor:
                                                                        Colors.blueGrey[
                                                                            700],
                                                                    content: Text(
                                                                        'Weight deleted')));
                                                            bool shouldNavigate = Provider.of<
                                                                            WeightAndPicturesData>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .weightAndPics
                                                                    .length ==
                                                                1;
                                                            await Provider.of<
                                                                        WeightAndPicturesData>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .deleteSingleWeightAndPics(
                                                                    weightAndPicList[
                                                                            index]
                                                                        .dateTime,
                                                                    id);
                                                            pictureAndWeightList
                                                                .removeWhere((element) =>
                                                                    element
                                                                        .dateTime ==
                                                                    weightAndPicList[
                                                                            index]
                                                                        .dateTime);
                                                            setState(() {
                                                              weightAndPicList.removeWhere((element) =>
                                                                  element
                                                                      .dateTime ==
                                                                  weightAndPicList[
                                                                          index]
                                                                      .dateTime);
                                                            });
                                                            if (shouldNavigate) {
                                                              setState(() {
                                                                lastDelete =
                                                                    true;
                                                              });
                                                              // Navigator.of(context)
                                                              //     .pushReplacementNamed(
                                                              //         '/AddNewJourney');
                                                            }
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                            'delete',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .redAccent),
                                                          ))
                                                    ]);
                                              });
                                        },
                                        icon: Icon(Icons.delete),
                                        color: Colors.blueGrey[300],
                                      ),
                                      top: 0,
                                      right: 0,
                                    ),
                                  ]),
                        staggeredTileBuilder: (int index) =>
                            new StaggeredTile.count(
                                3, weightAndPicList[index].havePicture ? 4 : 2),
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 0,
                      )));
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class ImageCard extends StatelessWidget {
  const ImageCard({
    Key key,
    @required this.pictureAndWeightList,
    @required this.ratio,
    @required this.element,
    @required this.units,
    @required this.args,
    @required this.index,
  }) : super(key: key);
  final List<WeightAndPic> pictureAndWeightList;
  final WeightAndPic element;
  final double ratio;
  final int index;
  final ScreenArguments args;
  final String units;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(GalleryViewScreen.routeName,
              arguments: ScreenArguments(
                  list: pictureAndWeightList,
                  number: pictureAndWeightList.indexWhere(
                      (element) => element.dateTime == this.element.dateTime)));
        },
        child: Card(
          color: Colors.amber,
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Image.file(
            io.File(element.path),
            fit: BoxFit.cover,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          margin: EdgeInsets.all(5),
        ),
      ),
      Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            margin: EdgeInsets.all(5),
            child: Column(
              children: [
                RichText(
                  text: TextSpan(
                      text: NumberFormat("###.#").format(element.weight),
                      style: TextStyle(
                          color: Colors.blueGrey[700],
                          fontStyle: FontStyle.normal,
                          fontSize: 15 * ratio,
                          fontWeight: FontWeight.w900),
                      children: <TextSpan>[
                        TextSpan(
                            text: ' ' + units,
                            style: TextStyle(
                                color: Colors.blueGrey[400],
                                fontStyle: FontStyle.italic,
                                fontSize: 10 * ratio,
                                fontWeight: FontWeight.bold))
                      ]),
                ),
                RichText(
                  text: TextSpan(
                      text: DateTime.parse(element.dateTime).day.toString(),
                      style: TextStyle(
                          color: Colors.blueGrey[700],
                          fontStyle: FontStyle.normal,
                          fontSize: 15 * ratio,
                          fontWeight: FontWeight.w900),
                      children: <TextSpan>[
                        TextSpan(
                            text: args.appBarTitle,
                            style: TextStyle(
                                color: Colors.blueGrey[500],
                                fontStyle: FontStyle.normal,
                                fontSize: 10 * ratio,
                                fontWeight: FontWeight.bold))
                      ]),
                )
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
            ),
          ))
    ]);
  }
}

class WithoutImageCard extends StatelessWidget {
  const WithoutImageCard({
    Key key,
    @required this.element,
    @required this.ratio,
    @required this.units,
    @required this.args,
  }) : super(key: key);

  final double ratio;
  final String units;
  final WeightAndPic element;
  final ScreenArguments args;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        margin: EdgeInsets.all(5),
        child: Container(
          margin: EdgeInsets.only(left: 10, top: 20, bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RichText(
                text: TextSpan(
                    text: NumberFormat("###.#").format(element.weight),
                    style: TextStyle(
                        color: Colors.blueGrey[700],
                        fontStyle: FontStyle.normal,
                        fontSize: 20 * ratio,
                        fontWeight: FontWeight.w900),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' ' + units,
                          style: TextStyle(
                              color: Colors.blueGrey[400],
                              fontStyle: FontStyle.italic,
                              fontSize: 10 * ratio,
                              fontWeight: FontWeight.bold))
                    ]),
              ),
              RichText(
                text: TextSpan(
                    text: DateTime.parse(element.dateTime).day.toString() + ' ',
                    style: TextStyle(
                        color: Colors.blueGrey[700],
                        fontStyle: FontStyle.normal,
                        fontSize: 15 * ratio,
                        fontWeight: FontWeight.w900),
                    children: <TextSpan>[
                      TextSpan(
                          text: args.appBarTitle,
                          style: TextStyle(
                              color: Colors.blueGrey[500],
                              fontStyle: FontStyle.normal,
                              fontSize: 10 * ratio,
                              fontWeight: FontWeight.bold))
                    ]),
              )
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
          ),
        ),
        color: Colors.white,
      ),
    ]);
  }
}
