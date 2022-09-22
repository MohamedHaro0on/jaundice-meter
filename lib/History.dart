// ignore_for_file: file_names

import 'dart:async';

import 'package:jaundice/shareable/button.dart';
import 'package:jaundice/shareable/layout.dart';
import 'package:flutter/material.dart';
import 'package:jaundice/shareable/preview_jaundice_response.dart';

import 'package:jaundice/utility.dart';
import 'package:carousel_slider/carousel_slider.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  late final List<Image> _images = [];
  late final List<String> _labels = [];
  late int index = 0;

  @override
  void initState() {
    super.initState();
    _loadDataFromPrefrences();
  }

  @override
  dispose() {
    super.dispose();
  }

  _loadDataFromPrefrences() async {
    Utility.getImagesFromPreferences().then((imgs) async => {
          if (imgs == null)
            {}
          else
            {
              for (int i = _images.length; i < imgs.length; i++)
                {
                  setState(() {
                    _images.add(Utility.imageFromBase64String(imgs[i]));
                  }),
                },
            }
        });

    Utility.getLabelsFromPrefrences().then((labels) async => {
          setState(() {
            _labels.addAll(labels!);
          })
        });
  }

  _onButtonPressed() {
    if (_images.isNotEmpty) {
      Utility.resetImages();
      Utility.resetLabels();
      setState(() {
        _images.clear();
        _labels.clear();
      });
    }
  }

  Future<Widget> _previewImages(BuildContext context) async {
    if (_images.isNotEmpty) {
      return Future.value(Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          child: Center(
            child: CarouselSlider(
              options: CarouselOptions(
                height: 600,
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: false,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
              items: _images
                  .map(
                    (item) => Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          SizedBox(
                            height: item.height,
                            child: Image(
                              image: item.image,
                              repeat: ImageRepeat.noRepeat,
                              fit: BoxFit.fill,
                            ),
                          ),
                          const SizedBox(height: 10),
                          PreviewJaundiceResponse(value: _labels[index++])
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ));
    } else {
      return Center(
          child: Image.asset(
        "assets/images/Image_not_available.png",
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      key: UniqueKey(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Previous Images",
              style: TextStyle(color: Color(0XFF232323))),
          backgroundColor: const Color(0XFFFFDD00),
          iconTheme: const IconThemeData(color: Color(0XFF232323)),
        ),
        body: FutureBuilder<Widget>(
          future: _previewImages(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return snapshot.data!;
            } else {
              /// you handle others state like error while it will a widget no matter what, you can skip it
              return const Center(
                  child: CircularProgressIndicator(
                color: Color(0XFFFFDD00),
              ));
            }
          },
        ),
        floatingActionButton: Button(
          tooltip: "Delete Images ",
          heroTag: "delete Images btn ",
          key: UniqueKey(),
          onButtonClick: () {
            _onButtonPressed();
          },
          size: 100,
          backgroundColor: const Color(0XFF232323),
          child: const Icon(Icons.restore_from_trash, color: Color(0XFFFFDD00)),
        ),
      ),
    );
  }
}
