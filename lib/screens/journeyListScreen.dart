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
      floatingActionButton: FloatingActionButton(
        child: Text('add'),
        onPressed: () {
          Navigator.of(context).pushNamed('/AddNewJourney');
        },
      ),
      appBar: AppBar(
        title: Text('journey list'),
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
                      title: Text(journeyList[index].id.toString()),
                    );
                  },
                  itemCount: journeyList.length,
                ),
    );
  }
}
