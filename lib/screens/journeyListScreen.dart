import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wlbaf/models/modelClasses.dart';
import 'package:wlbaf/providers/providers.dart';

class JourneyListScreen extends StatefulWidget {
  @override
  _JourneyListScreenState createState() => _JourneyListScreenState();
}

class _JourneyListScreenState extends State<JourneyListScreen> {
  List<Journey> journeyList = [];
  GlobalKey materialNavigatorKey;

  bool initialized = false;
  @override
  void didChangeDependencies() {
    if (!initialized) {
      materialNavigatorKey =
          Provider.of<MaterialNavigatorKey>(context, listen: false).get();
      setState(() {
        initialized = true;
      });
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    journeyList = Provider.of<JourneysData>(context).journeysList;

    return Scaffold(
      backgroundColor: Color.fromRGBO(240, 255, 240, 1),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text('journey'),
        onPressed: () {
          Navigator.of(context).pushNamed('/AddNewJourney');
        },
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color.fromRGBO(24, 96, 72, 1)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Your Journeys !',
          style: TextStyle(
              color: Color.fromRGBO(24, 96, 72, 1),
              fontWeight: FontWeight.bold),
        ),
      ),
      body: !initialized
          ? CircularProgressIndicator()
          : journeyList.isEmpty
              ? Container()
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () async {
                        await Provider.of<CurrentJourney>(context,
                                listen: false)
                            .set(
                                journeyList[index].id,
                                materialNavigatorKey.currentContext,
                                true,
                                false);
                        Navigator.of(context).pushNamed('/Tabs_screen');
                      },
                      title: Text(journeyList[index].targetWeight.toString()),
                    );
                  },
                  itemCount: journeyList.length,
                ),
    );
  }
}
