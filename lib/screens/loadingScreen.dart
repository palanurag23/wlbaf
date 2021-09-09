import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/providers.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool isInitialized = false;

  @override
  void didChangeDependencies() async {
    if (!isInitialized) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Provider.of<SharedPreferencesData>(context, listen: false).set(prefs);
      await Provider.of<UnitsData>(context, listen: false)
          .fetchAndSetUnits(context);
      await Provider.of<CurrentJourney>(context, listen: false)
          .fetchAndSetCurrentJourneyData(context);
      // bool checkJourneyCount = prefs.containsKey('journeyCount');
      // print(' checkJourneyCount if empty then false= $checkJourneyCount ');

      // if (!checkJourneyCount) {
      //   print('a');
      //   prefs.setInt('journeyCount', 0);
      //   print('a');

      //   prefs.setInt('currentJourneyId', 0);
      //   print('a');
      // }
      // int currentJourneyId = prefs.getInt('currentJourneyId');
      // Provider.of<CurrentJourney>(context, listen: false)
      //     .setOnlyINapp(currentJourneyId);

      // await Provider.of<JourneysData>(context, listen: false).fetchAndSetData();

      // if (currentJourneyId > 0) {
      //   await Provider.of<WeightAndPicturesData>(context, listen: false)
      //       .fetchAndSetData(currentJourneyId);
      // }
      print('alldone');

      setState(() {
        isInitialized = true;
      });
      //  Navigator.of(context).pushNamed('/TestingDataScreen');
    }
    var journeyList =
        Provider.of<JourneysData>(context, listen: false).journeysList;

    Provider.of<WeightAndPicturesData>(context, listen: false)
            .weightAndPics
            .isEmpty
        ?
        //journeyList.isEmpty
        //  ?
        Navigator.of(context).pushReplacementNamed('/AddNewJourney')
        //: Navigator.of(context).pushReplacementNamed('/JourneyListScreen')
        : Navigator.of(context).pushReplacementNamed('/Tabs_screen');
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Weight Loss',
            style: TextStyle(
                color: Colors.blueGrey[50],
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
                fontFamily: 'Open Sans',
                fontSize: 40),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Before and After',
            style: TextStyle(
                color: Colors.blueGrey[200],
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
                fontFamily: 'Open Sans',
                fontSize: 24),
          )
        ],
      )),
    );
  }
}
