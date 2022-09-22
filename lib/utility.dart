// ignore_for_file: constant_identifier_names

import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/widgets.dart' as widgets;

class Utility {
  //
  static const String IMAGES_KEY = "IMAGES_KEY";
  static const String LABELS_KEY = "LABELS_KEY";
  static const String FACES_KEY = "FACES_KEY";

  // Saving and retreving Images :

  static Future<bool> saveImagesToPreferences(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    late List<String>? currentImages =
        prefs.getStringList(IMAGES_KEY); // getting current loaded images

    if (currentImages == null) {
      return prefs
          .setStringList(IMAGES_KEY, [value]); // saving the array of images
    } else {
      currentImages.add(value); // adding the new image
      return prefs.setStringList(
          IMAGES_KEY, currentImages); // saving the array of images
    }
  }

  static Future<List<String>?> getImagesFromPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(IMAGES_KEY);
  }

  static Future<bool> resetImages() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(IMAGES_KEY, []); // deleting all saved images
  }

  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }

  static Future<ui.Image> converToUiImage(String imageAssetPath) {
    widgets.Image widgetsImage =
        widgets.Image.asset(imageAssetPath, scale: 0.5);
    Completer<ui.Image> completer = Completer<ui.Image>();
    widgetsImage.image
        .resolve(const widgets.ImageConfiguration(size: ui.Size(10, 10)))
        .addListener(
            widgets.ImageStreamListener((widgets.ImageInfo info, bool _) {
      completer.complete(info.image);
    }));
    return completer.future;
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  // Saving and retreving Labels :

  static Future<bool> saveLabelstoPrefrences(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? currentLabels = prefs.getStringList(LABELS_KEY);
    // getting current loaded labels
    if (currentLabels == null) {
      return prefs.setStringList(LABELS_KEY, [value]);
    } else {
      currentLabels.add(value); // adding the new image
      return prefs.setStringList(LABELS_KEY, currentLabels);
    }
  }

  static Future<List<String>?> getLabelsFromPrefrences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(LABELS_KEY);
  }

  static Future<bool> resetLabels() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(LABELS_KEY, []); // deleting all saved images
  }
}
