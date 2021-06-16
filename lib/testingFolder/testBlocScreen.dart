import '../testingFolder/bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlocScreen extends StatelessWidget {
  static const routeName = '/BlocScreen';

  @override
  Widget build(BuildContext context) {
    WeightBloc weightBloc = WeightBloc(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          weightBloc.addNum();
        },
      ),
      appBar: AppBar(
        title: Text('BlocScreen'),
      ),
      body: StreamBuilder<List<int>>(
        stream: weightBloc.stream,
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            List<int> list = snapshot.data;

            return Column(
              children: [
                Container(
                  height: 222,
                  child: ListView.builder(
                    itemBuilder: (ctx, index) {
                      return ListTile(
                        onTap: () => weightBloc.startTimer(index),
                        title: Text('${list[index]}'),
                        trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              weightBloc.deleteNum(index);
                            }),
                      );
                    },
                    itemCount: list.length,
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      // StreamBuilder(
      //     stream: weightBloc.streamWeights,
      //     builder: (ctx, snap) {
      //       if (snap.hasData) {
      //         return WeightChart();
      //       } else {
      //         return CircularProgressIndicator();
      //       }
      //     })
    );
  }
}
