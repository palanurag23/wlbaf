//adb tcpip 5555 <phone connedted -adb tcpip "port Name"
//adb connect 192.168.1.2:5555 <phone disconnected -adb connect "ip address":"port Name"

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/single_child_widget.dart';
import 'package:wlbaf/screens/GalleryViewScreen.dart';
import 'package:wlbaf/screens/JourneyMonthsScreen.dart';
import 'package:wlbaf/screens/addWeight.dart';
import 'package:wlbaf/screens/editGoal.dart';
import 'package:wlbaf/screens/journeyListScreen.dart';
import 'package:wlbaf/screens/loadingScreen.dart';
import 'package:wlbaf/screens/monthsWeightAndPicsScreen.dart';
import 'package:wlbaf/screens/newJourney.dart';
import 'package:wlbaf/screens/photo_gallery.dart';
import 'package:wlbaf/screens/tabs_screen.dart';
import 'package:wlbaf/screens/testingDataScreen.dart';
import 'package:wlbaf/screens/testingScreen.dart';
import 'package:wlbaf/testingFolder/testBlocScreen.dart';
import 'package:provider/provider.dart';
import './providers/providers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  GlobalKey materialNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider.value(value: UnitsData()),
        ChangeNotifierProvider.value(value: RateMyAppData()),
        ChangeNotifierProvider.value(value: CurrentJourney()),
        ChangeNotifierProvider.value(value: JourneysData()),
        ChangeNotifierProvider.value(value: WeightAndPicturesData()),
        Provider.value(value: SharedPreferencesData()),
        Provider.value(
            value: MaterialNavigatorKey(
                materialNavigatorKey: materialNavigatorKey)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: materialNavigatorKey,
        title: 'Weight Loss Before and After',
        theme: ThemeData(
          bottomAppBarColor: Colors.white,
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: LoadingScreen(), //MyHomePage(title: 'Flutter Demo Home Page'),
        routes: {
          PhotoGallery.routeName: (context) => PhotoGallery(),
          GalleryViewScreen.routeName: (context) => GalleryViewScreen(),
          '/MonthsWeightAndPicsScreen': (context) =>
              MonthsWeightAndPicsScreen(),
          EditGoal.routeName: (context) => EditGoal(),
          '/JourneyMonthScreen': (context) => JourneyMonthScreen(),
          '/JourneyListScreen': (context) => JourneyListScreen(),
          '/AddNewJourney': (context) => AddNewJourney(),
          '/ips': (context) => ImagePickerScreen(),
          '/Tabs_screen': (context) => TabsScreen(),
          '/TestingDataScreen': (context) => TestingDataScreen(),
          '/BlocScreen': (context) => BlocScreen(),
          '/AddWeightScreen': (context) => AddWeight()
        },
      ),
    );
  }
}
/*
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
     
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
                onPressed: () => Navigator.of(context).pushNamed('/BlocScreen'),
                child: Text('blocScreen')),
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
*/
