import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wlbaf/models/modelClasses.dart';
import 'package:wlbaf/providers/providers.dart';

class TestingDataScreen extends StatefulWidget {
  static const routeName = '/TestingDataScreen';
  @override
  _TestingDataScreenState createState() => _TestingDataScreenState();
}

class _TestingDataScreenState extends State<TestingDataScreen> {
  bool isInitialized = false;
  GlobalKey materialNavigatorKey;
  @override
  void didChangeDependencies() {
    if (!isInitialized) {
      materialNavigatorKey =
          Provider.of<MaterialNavigatorKey>(context, listen: false).get();
      setState(() {
        isInitialized = true;
      });
    }

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('testing data screen build starts');
    int journeyId = Provider.of<CurrentJourney>(context).get();
    print(journeyId);
    return Scaffold(
      appBar: AppBar(
        actions: [Center(child: Text(journeyId.toString()))],
        title: Text('testing data screen'),
      ),
      body: !isInitialized
          ? CircularProgressIndicator()
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      child: Consumer<JourneysData>(
                        child: Text('empty journey'),
                        builder: (context, journeyData, child) {
                          List<Journey> journeys = journeyData.getJourneysList;
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                ListTile(
                                  trailing: IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        Provider.of<JourneysData>(
                                                materialNavigatorKey
                                                    .currentContext,
                                                listen: false)
                                            .addNewJourney(context, 'name',
                                                60.0, 2, false, true);
                                      }),
                                  title: Text('add new journey'),
                                ),
                                journeys.isEmpty
                                    ? child
                                    : ListView.builder(
                                        itemCount: journeys.length,
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            trailing: IconButton(
                                                icon: Icon(Icons.delete),
                                                onPressed: () {
                                                  journeyData
                                                      .deleteSingleJourney(
                                                          context);
                                                }),
                                            subtitle: Text(journeys[index]
                                                .weightTableName
                                                .toString()),
                                            onTap: () async {
                                              await Provider.of<CurrentJourney>(
                                                      context,
                                                      listen: false)
                                                  .set(
                                                      journeys[index].id,
                                                      materialNavigatorKey
                                                          .currentContext,
                                                      true,
                                                      false);
                                            },
                                            title: Text(
                                                journeys[index].id.toString()),
                                          );
                                        })
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      height: 600,
                      child: Consumer<WeightAndPicturesData>(
                        child: Text('empty weightAndPicsData'),
                        builder: (context, weightAndPicturesData, child) {
                          List<WeightAndPic> weightAndPicsList =
                              weightAndPicturesData.weightAndPics;
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                ListTile(
                                  trailing: IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: journeyId == 0
                                          ? () {}
                                          : () {
                                              weightAndPicturesData
                                                  .addWeightAndPic(55.0,
                                                      journeyId, true, '.....');
                                            }),
                                  title: Text('weights of this journey'),
                                ),
                                weightAndPicsList.isEmpty
                                    ? child
                                    : ListView.builder(
                                        itemCount: weightAndPicsList.length,
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            subtitle: Text(
                                                weightAndPicsList[index]
                                                    .dateTime
                                                    .toString()),
                                            onTap: () {
                                              weightAndPicturesData
                                                  .deleteSingleWeightAndPics(
                                                      weightAndPicsList[index]
                                                          .dateTime,
                                                      journeyId);
                                            },
                                            title: Text(weightAndPicsList[index]
                                                .weight
                                                .toString()),
                                          );
                                        })
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
