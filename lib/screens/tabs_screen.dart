import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
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
          .weightAndPicList;
      print('weightAndPics.isempty' + weightAndPics.isEmpty.toString());
      weightListEmpty = weightAndPics.isEmpty;
      weightAddedToday = weightListEmpty
          ? false
          : DateFormat('dd/MM/yy').format(DateTime.now()) ==
              DateFormat('dd/MM/yy')
                  .format(DateTime.parse(weightAndPics.last.dateTime));
      todaysDayCount = DateTime.now()
              .difference(DateTime.parse(weightAndPics.first.dateTime))
              .inDays +
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
    weightAndPics = Provider.of<WeightAndPicturesData>(context, listen: true)
        .weightAndPicList;
    weightListEmpty = weightAndPics.isEmpty;
    weightAddedToday = weightListEmpty
        ? false
        : DateFormat('dd/MM/yy').format(DateTime.now()) ==
            DateFormat('dd/MM/yy')
                .format(DateTime.parse(weightAndPics.last.dateTime));
    return WillPopScope(
      onWillPop: () async {
        await SystemNavigator.pop();
      },
      child: Scaffold(
        floatingActionButton: _selectedPageIndex == 0
            ? isInitialized
                ? FloatingActionButton.extended(
                    backgroundColor: Colors.blueGrey[900],
                    onPressed: () {
                      Navigator.of(context).pushNamed('/AddWeightScreen');
                    },
                    icon: weightAddedToday ? Icon(Icons.edit) : Icon(Icons.add),
                    label:
                        Text(weightListEmpty ? 'add' : 'Day $todaysDayCount'),
                  )
                : Container()
            : Container(),
        body: !isInitialized
            ? CircularProgressIndicator()
            : AnimatedSwitcher(
                duration: Duration(milliseconds: 00),
                transitionBuilder:
                    (Widget child, Animation<double> animation) =>
                        ScaleTransition(
                  scale: animation,
                  child: child,
                ),
                child: _pages[_selectedPageIndex]['page'],
              ),
        drawer: Drawer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 70,
                color: Colors.amberAccent,
              ),
              ListTile(
                tileColor: Colors.black,
                onTap: () {
                  Navigator.of(context).pushNamed('/JourneyListScreen');
                },
              ),
              Container(
                child: ListTile(
                  title: Text('data testing screen'),
                  tileColor: Colors.pinkAccent,
                  onTap: () {
                    Navigator.of(context).pushNamed('/TestingDataScreen');
                  },
                ),
              ),
              ListTile(
                title: Text('image'),
                onTap: () {
                  Navigator.of(context).pushNamed('/ips');
                },
              )
            ],
          ),
        ),
        appBar: AppBar(
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
              activeIcon: Icon(Icons.image),
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
