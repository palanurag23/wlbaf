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
    }
    var journeyList =
        Provider.of<JourneysData>(context, listen: false).journeysList;

    Provider.of<WeightAndPicturesData>(context, listen: false)
            .weightAndPicList
            .isEmpty
        ? journeyList.isEmpty
            ? Navigator.of(context).pushNamed('/AddNewJourney')
            : Navigator.of(context).pushNamed('/JourneyListScreen')
        : Navigator.of(context).pushNamed('/Tabs_screen');
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
