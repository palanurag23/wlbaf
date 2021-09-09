import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:wlbaf/my_flutter_app_icons.dart';
import 'package:wlbaf/progress_icon_icons.dart';
import 'tab3SlideShow.dart';
import 'tab1.dart';
import 'package:intl/intl.dart';
import 'tab2.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../models/modelClasses.dart';
import '../screens/testingScreen.dart';

class TabsScreen extends StatefulWidget {
  // TabsScreen({Key? key}) : super(key: key);
  static const routeName = '/Tabs_screen';
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  List<Map<String, Object>> _pages;
  @override
  void initState() {
    // TODO: implement initState
    _pages = [
      {'page': Tab1(), 'title': 'Tab1'},
      {'page': Tab2(), 'title': 'Tab2'},
      {'page': Tab3(), 'title': 'Tab2'}
    ]; //you can use 'widget.' in build method but not outside..
    //and you cant create variables in initState..
    //you can only assign values to the non final variables here..like _pages
    // TODO: implement initState
    super.initState();
    super.initState();
  }

  List<WeightAndPic> weightAndPics = [];
  bool weightListEmpty;
  bool isInitialized = false;
  bool weightAddedToday;
  int todaysDayCount = 0;
  @override
  void didChangeDependencies() {
    if (!isInitialized) {
      weightAndPics = Provider.of<WeightAndPicturesData>(context, listen: false)
          .weightAndPics;
      print('weightAndPics.isempty' + weightAndPics.isEmpty.toString());
      weightListEmpty = weightAndPics.isEmpty;
      weightAddedToday = weightListEmpty
          ? false
          : DateFormat('dd/MM/yy').format(DateTime.now()) ==
              DateFormat('dd/MM/yy')
                  .format(DateTime.parse(weightAndPics.last.dateTime));
      todaysDayCount = ((DateTime.now()
                      .difference(DateTime.parse(weightAndPics.first.dateTime))
                      .inHours) /
                  24)
              .round() +
          1;
      setState(() {
        isInitialized = true;
      });
    }

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void _selectPage(int index) {
    //INDEX IS AUTOMATICALLY PROVIDED BY FLUTTER
    //FUNCTION TO SELECT PAGE FROM BOTTOM-NAVIGATION-BAR
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double ratio = MediaQuery.of(context).size.height / 896;

    weightAndPics =
        Provider.of<WeightAndPicturesData>(context, listen: true).weightAndPics;
    weightListEmpty = weightAndPics.isEmpty;
    weightAddedToday = weightListEmpty
        ? false
        : DateFormat('dd/MM/yy').format(DateTime.now()) ==
            DateFormat('dd/MM/yy')
                .format(DateTime.parse(weightAndPics.last.dateTime));
    print('Weight added today $weightAddedToday');
    return WillPopScope(
      onWillPop: () async {
        await SystemNavigator.pop();
      },
      child: Scaffold(
        floatingActionButton: _selectedPageIndex == 0
            ? isInitialized
                ? weightAndPics.isEmpty
                    ? Container()
                    : FloatingActionButton.extended(
                        backgroundColor: Colors.blueGrey[900],
                        onPressed: () {
                          Navigator.of(context).pushNamed('/AddWeightScreen');
                        },
                        icon: weightAddedToday
                            ? Icon(Icons.edit)
                            : Icon(Icons.add),
                        label: Text(
                            weightListEmpty ? 'add' : 'Day $todaysDayCount'),
                      )
                : Container()
            : Container(),
        body: !isInitialized
            ? CircularProgressIndicator()
            : AnimatedSwitcher(
                duration: Duration(milliseconds: 0),
                transitionBuilder:
                    (Widget child, Animation<double> animation) =>
                        ScaleTransition(
                  scale: animation,
                  child: child,
                ),
                child: weightAndPics.isEmpty
                    ? Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed('/AddNewJourney');
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: _selectedPageIndex == 0
                                  ? Colors.blueGrey[900]
                                  : _selectedPageIndex == 1
                                      ? Colors.cyan
                                      : Colors.amber,
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
                    : _pages[_selectedPageIndex]['page'],
              ),
        drawer: Drawer(
          child: Container(
            color: Colors.blueGrey[50],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  //height: 70,
                  padding: EdgeInsets.only(top: 55, bottom: 25),
                  color: Colors.cyan,
                  child: Center(
                    child: Text(
                      'Weight Loss - Before and After',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Open Sans',
                          fontSize: 20),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 2),
                  child: ListTile(
                    leading: Icon(
                      Icons.star,
                      color: Colors.blueGrey[700],
                    ),
                    tileColor: Colors.white,
                    title: Text('Rate this app',
                        style: TextStyle(
                          color: Colors.blueGrey[900],
                        )),
                    onTap: () {
                      RateMyApp rateMyApp = RateMyApp();
                      var contextX = Provider.of<MaterialNavigatorKey>(context,
                              listen: false)
                          .get()
                          .currentContext;
                      //  var rateMyApp =
                      Provider.of<RateMyAppData>(context, listen: false)
                          .set(rateMyApp);
                      Provider.of<RateMyAppData>(context, listen: false)
                          .showStarDialog(contextX);
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 2),
                  child: ListTile(
                    leading: Icon(
                      Icons.library_add_check_outlined,
                      color: Colors.blueGrey[700],
                    ),
                    tileColor: Colors.white,
                    title: Text('Show License Page',
                        style: TextStyle(
                          color: Colors.blueGrey[900],
                        )),
                    onTap: () {
                      showLicensePage(
                        context: context,
                        // applicationIcon: Image.asset(name)
                        // applicationName: "App Name"
                        // Other parameters
                      );
                    },
                  ),
                ),
                // ListTile(
                //   tileColor: Colors.black,
                //   onTap: () {
                //     Navigator.of(context).pushNamed('/JourneyListScreen');
                //   },
                // ),
                // Container(
                //   child: ListTile(
                //     title: Text('data testing screen'),
                //     tileColor: Colors.pinkAccent,
                //     onTap: () {
                //       Navigator.of(context).pushNamed('/TestingDataScreen');
                //     },
                //   ),
                // ),
                // ListTile(
                //   title: Text('image'),
                //   onTap: () {
                //     Navigator.of(context).pushNamed('/ips');
                //   },
                // )
              ],
            ),
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(),
          elevation: 0,
          backgroundColor: Colors.transparent,
          //    _selectedPageIndex == 2 ? Colors.amber : Colors.pinkAccent,
          title: Text(
            'You are losing weight !',
            style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
                fontFamily: 'Open Sans',
                fontSize: 20),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting, selectedFontSize: 15,
          unselectedFontSize: 10,
          currentIndex: _selectedPageIndex, //WHICH TAB IS SELECTED/HIGHLIGHTED
          unselectedItemColor: _selectedPageIndex == 2
              ? Colors.white
              : Colors.white, //Theme.of(context).accentColor,
          //  Colors.white, //grey[300], //Theme.of(context).canvasColor,
          selectedItemColor: _selectedPageIndex == 2
              ? Colors.white
              : Colors.white, //Theme.of(context).accentColor,
          onTap:
              _selectPage, //flutter will automaticlly give 'index' of the tab
          backgroundColor: Colors.pinkAccent, //Theme.of(context).accentColor,
          items: [
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.image,
              ),
              backgroundColor:
                  Colors.blueGrey[900], //Theme.of(context).bottomAppBarColor,
              icon: Icon(Icons.image),
              // Container(
              //     padding: EdgeInsets.all(0),
              //     decoration: BoxDecoration(
              //         border: Border.all(color: Colors.white, width: 0.4),
              //         color: Colors.pinkAccent,
              //         shape: BoxShape.circle),
              //     child: Icon(Icons.line_weight_sharp)),
              label: 'Now', //.tr(),
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(ProgressIcon.graphic_progression),
              backgroundColor:
                  Colors.cyan, //Theme.of(context).bottomAppBarColor,
              //  backgroundColor: Theme.of(context).primaryColor,//with shifting
              icon: Icon(ProgressIcon.graphic_progression),
              //  Container(
              //     padding: EdgeInsets.all(0),
              //     decoration: BoxDecoration(
              //         border: Border.all(color: Colors.white, width: 0.4),
              //         color: Colors.tealAccent[700],
              //         shape: BoxShape.circle),
              //     child: Icon(Icons.accessibility_rounded)),
              label: 'Goal', //.tr(),
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.play_circle_outline_rounded),
              backgroundColor:
                  Colors.amber, //Theme.of(context).bottomAppBarColor,
              icon: Icon(Icons.play_circle_outline_rounded),
              // Container(
              //     padding: EdgeInsets.all(0),
              //     decoration: BoxDecoration(
              //         border: Border.all(color: Colors.white, width: 0.4),
              //         color: Colors.pinkAccent,
              //         shape: BoxShape.circle),
              //     child: Icon(Icons.line_weight_sharp)),
              label: 'Slide Show', //.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
/* */
