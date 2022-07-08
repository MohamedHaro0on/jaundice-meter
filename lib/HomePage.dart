


import 'package:Jaundice/shareable/button.dart';
import 'package:Jaundice/shareable/layout.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:ui' as ui;
import "./shareable/FacePainter.dart";
// import 'package:http/http.dart' as http;

import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {


  List<XFile>? _imageFileList;
  late XFile _pickedImage ;

  late List<Face>? _faces;

  bool _isLoading = false ;

  void _setImageFileListFromFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }



  late ui.Image _image;

  final picker = ImagePicker();

  dynamic _pickImageError;
  String? _retrieveDataError;



  // _classfiyJaundice() async {
  //   var postUri = Uri.parse("https://jaundice-classfire.herokuapp.com/predict");
  //   var request = http.MultipartRequest("POST", postUri);
  //   request.fields['user'] = 'blah';
  //   request.files.add(
  //       new http.MultipartFile.fromBytes('file', await File.fromUri(Image.file(_pickedImage.path)).readAsBytes(),
  //       contentType: new MediaType('image', 'jpeg')
  //       )
  //   );
  //
  //   request.send().then((response) {
  //     if (response.statusCode == 200) print("Uploaded!");
  //   });
  // }

  Future<void> _onImageButtonPressed(ImageSource source) async {

    try {
      setState(() {
        _isLoading = true;
      });

      final XFile? pickedFile = await picker.pickImage(
        source: source,
      );
      setState(() {
        _setImageFileListFromFile(pickedFile);
        // _pickedImage = pickedFile;
      });



      final GoogleVisionImage visionImage = GoogleVisionImage.fromFile(File(pickedFile!.path));

      final FaceDetector faceDetector = GoogleVision.instance.faceDetector();

      _faces = await faceDetector.processImage(visionImage);

      final data = await pickedFile.readAsBytes();

      if (mounted) {
        await decodeImageFromList(data).then((value) => setState(() {
          _image = value;
          _isLoading = false ;
        }));
      }

    } catch (e) {
      setState(() {
        _pickImageError = e;
        _isLoading = false ;
      });
    }
  }


  Future<void> retrieveLostData() async {
    final LostDataResponse response = await picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.files == null) {
          _setImageFileListFromFile(response.file);
        } else {
          _imageFileList = response.files;
        }
      });
    }
    else {
      _retrieveDataError = response.exception!.code;
    }
  }


  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }


  Future<Widget> _previewImages  () async {
  final Text? retrieveError = _getRetrieveErrorWidget();
  if (retrieveError != null) {
    return retrieveError;
  }
  if (_imageFileList != null) {
    return Future.value(
      Center(
        child : FittedBox(
          child:  SizedBox(
            width: _image.width.toDouble(),
            height: _image.height.toDouble(),
            child: CustomPaint(
              painter: FacePainter(_image, _faces!),
            ),
          ),
        ),
      )
    );
  } else if (_pickImageError != null) {
    return Text(
      'Pick image error: $_pickImageError',
      textAlign: TextAlign.center,
    );
  } else {
    return  const Text(
      'You have not yet picked an image.',
      textAlign: TextAlign.center,
      style:  TextStyle(color: Colors.white),
    );
  }
}



  @override
  Widget build (BuildContext context) {
    // TODO: implement build
   return Layout(
       key: UniqueKey(),
       child: Scaffold(
         backgroundColor: Colors.transparent,
         appBar: AppBar(
            title: const Text("Jaundice Meter" , style: TextStyle(color: Color(0XFF232323)),),
           backgroundColor: const Color(0XFFFFDD00),
           iconTheme: const IconThemeData(
               color: Color(0XFF232323)
           ),
        ),
        body: FutureBuilder <Widget> (
          future: _previewImages(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return snapshot.data!;
              } else {
                /// you handle others state like error while it will a widget no matter what, you can skip it
                return const Center(
                  child: CircularProgressIndicator()
                );
              }
            },
        ),

         floatingActionButton: Column(
           mainAxisAlignment: MainAxisAlignment.end,
           children: <Widget>[
             Semantics(
               label: 'pick Image From Gallary',
               child: Button(
                 backgroundColor: const Color(0XFFFFDD00),
                 key: UniqueKey(),
                 onButtonClick: (){
                   _onImageButtonPressed(ImageSource.gallery);
                 },
                 tooltip: 'Pick Image from gallery',
                 child: const Icon(Icons.photo ,color: Color(0XFF232323)),
               ),
             ),
             Padding(
               padding: const EdgeInsets.only(top: 16.0),
               child: Button(
                 key: UniqueKey(),
                 backgroundColor: const Color(0XFFFFDD00),
                 onButtonClick: () {
                   _onImageButtonPressed(ImageSource.camera);
                 },
                 tooltip: 'Take a Photo',
                 child: const Icon(Icons.camera_alt ,color: Color(0XFF232323)),
               ),
             ),
           ],
         ),

    )
   );
  }
}
