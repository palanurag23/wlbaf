import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../models/modelClasses.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:io';

class GalleryViewScreen extends StatelessWidget {
  static const routeName = '/GalleryViewScreen';
  const GalleryViewScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context).size;
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    int initialPage = args.number;
    List<WeightAndPic> list = args.list;
    //  var photoViewGalleryController = PhotoViewController();
    var pageViewController = PageController(
      initialPage: initialPage,
    );
    return Container(
      color: Colors.black,
      width: mediaQueryData.width,
      height: (mediaQueryData.height),
      child: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: FileImage(File(list[index].path)),
            initialScale: PhotoViewComputedScale.contained * 0.95,
            heroAttributes: PhotoViewHeroAttributes(tag: list[index].path),
          );
        },
        itemCount: list.length,
        loadingBuilder: (context, event) => Center(
          child: Container(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              value: event == null
                  ? 0
                  : event.cumulativeBytesLoaded / event.expectedTotalBytes,
            ),
          ),
        ),
        // backgroundDecoration: widget.backgroundDecoration,
        pageController: pageViewController,
        // onPageChanged: onPageChanged,
      ),
    );
  }
}
