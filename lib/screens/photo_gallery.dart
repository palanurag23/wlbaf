import 'package:flutter/material.dart';
import 'package:wlbaf/models/modelClasses.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:share/share.dart';
import '../screens/GalleryViewScreen.dart';

class PhotoGallery extends StatefulWidget {
  static const routeName = '/PhotoGallery';
  // PhotoGallery({Key? key}) : super(key: key);

  @override
  _PhotoGalleryState createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  List<WeightAndPic> photoWeightList = [];
  bool initialized = false;
  List<String> paths = [];
  bool selectionModeActivated = false;
  bool selectedAll = false;
  @override
  void didChangeDependencies() {
    if (!initialized) {
      Provider.of<WeightAndPicturesData>(context, listen: false)
          .weightAndPics
          .forEach((e) {
        if (e.havePicture) {
          photoWeightList.add(e);
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

    final mediaQueryData = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Gallery',
            style: TextStyle(
                color: Colors.blueGrey[600],
                fontStyle: FontStyle.italic,
                fontSize: 20 * ratio,
                fontWeight: FontWeight.bold)),
        iconTheme: IconThemeData(color: Colors.blueGrey),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (selectionModeActivated)
            IconButton(
              icon: Icon(Icons.share_rounded /* ios share also available*/),
              onPressed: () {
                final RenderBox box = context.findRenderObject();

                Share.shareFiles(paths,
                    subject: 'Weight Loss before and after',
                    sharePositionOrigin:
                        box.localToGlobal(Offset.zero) & box.size);
              },
            ),
          IconButton(
            onPressed: () {
              if (selectedAll) {
                setState(() {
                  paths.clear();
                  selectedAll = false;
                  selectionModeActivated = false;
                });
              } else {
                setState(() {
                  int i;
                  paths.clear();
                  for (i = 0; i < photoWeightList.length; i++) {
                    paths.add(photoWeightList[i].path);
                  }

                  selectedAll = true;
                  selectionModeActivated = true;
                });
              }
            },
            icon: Icon(
              Icons.select_all_sharp,
              color: selectedAll ? Colors.blue : Colors.blueGrey,
            ),
          ),
        ],
      ),
      body: !initialized
          ? CircularProgressIndicator()
          : GridView.builder(
              itemCount: photoWeightList.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  //costomization of grids
                  maxCrossAxisExtent: 100,
                  mainAxisSpacing: 1,
                  childAspectRatio: 1, //lengthwidth ratio
                  crossAxisSpacing: 1),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: selectionModeActivated
                      ? () {
                          setState(() {
                            if (paths.contains(photoWeightList[index].path)) {
                              if (paths.length == photoWeightList.length) {
                                selectedAll = false;
                              }
                              if (paths.length == 1) {
                                selectionModeActivated = false;
                              }
                              paths.remove(photoWeightList[index].path);
                            } else {
                              if (paths.length == photoWeightList.length - 1) {
                                selectedAll = true;
                              }
                              paths.add(photoWeightList[index].path);
                            }
                          });
                        }
                      : () {
                          Navigator.of(context).pushNamed(
                              GalleryViewScreen.routeName,
                              arguments: ScreenArguments(
                                  list: photoWeightList, number: index));
                        },
                  onLongPress: () {
                    setState(() {
                      if (paths.length == photoWeightList.length - 1) {
                        selectedAll = true;
                      }
                      paths.add(photoWeightList[index].path);
                    });
                    selectionModeActivated = true;
                  },
                  child: Stack(
                    children: [
                      Container(
                          height: mediaQueryData.width * 0.24,
                          width: mediaQueryData.width * 0.24,
                          margin: EdgeInsets.all(1),
                          child: Image.asset('./lib/assets/ooo1.jpeg')

                          // Image.file(
                          //   File(
                          //     item.filePath,
                          //   ),
                          //   fit: BoxFit.cover,
                          // )

                          ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Text(
                            NumberFormat("###.#")
                                .format(photoWeightList[index].weight),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                      if (paths.contains(photoWeightList[index].path))
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                              color: Colors.black,
                              child: Icon(
                                Icons.check,
                                size: 30,
                                color: Colors.blue,
                              )),
                        )
                    ],
                  ),
                );
              }),
    );
  }
}
