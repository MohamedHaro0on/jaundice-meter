import 'dart:async';
import 'dart:typed_data';

import 'package:jaundice/navigation_drawer.dart';
import 'package:jaundice/shareable/button.dart';
import 'package:jaundice/shareable/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jaundice/shareable/preview_faces_response.dart';
import 'package:jaundice/shareable/preview_jaundice_response.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'shareable/face_painter.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
// ignore: depend_on_referenced_packages
import 'package:async/async.dart';

import 'package:connectivity/connectivity.dart';

import 'package:jaundice/utility.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _connectionStatus = 'Unknown'; // default value for internet connection
  List<XFile>? _imageFileList; // Image Picked
  late XFile _pickedImage;
  late List<Face>? _faces = []; // Faces Detected ;
  bool _isLoading = false;
  dynamic _jaundiceResponse; // Jaundice HTTP Request Response

  bool _faceDetected = false;
  late ui.Image? _image;

  final picker = ImagePicker();
  dynamic _pickImageError;
  String? _retrieveDataError;

  final Connectivity _connectivity = Connectivity();

  void _setImageFileListFromFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
  }

  // Checking the internet connection ;
  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      setState(() {
        _jaundiceResponse = e;
      });
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = "none");
        break;
    }
  }

  _classifyJaundice() async {
    try {
      if (_connectionStatus != "ConnectivityResult.none" ||
          _connectionStatus != "none") {
        // open a bytestream

        // ignore: deprecated_member_use
        var stream =
            http.ByteStream(DelegatingStream.typed(_pickedImage.openRead()));

        var length = await _pickedImage.length(); // get file length

        // string to uri
        var uri = Uri.parse("https://jaundicce.herokuapp.com/predict");

        // create multipart request
        var request = http.MultipartRequest("POST", uri);

        // multipart that takes file
        var multipartFile = http.MultipartFile('file', stream, length,
            filename: basename(_pickedImage.path));

        // add file to multipart
        request.files.add(multipartFile);

        // send
        var response = await request.send();

        // listen for response
        response.stream.transform(utf8.decoder).listen((value) {
          setState(() {
            _jaundiceResponse = value;
            _isLoading = false;
          });
        });
        // saving the classfied Image to shared Prefrences :
        try {
          File temp = File(_pickedImage.path);
          final ByteData bytes = temp.readAsBytesSync().buffer.asByteData();
          final Uint8List list = bytes.buffer.asUint8List();

          await Utility.saveImagesToPreferences(Utility.base64String(list));

          if (_jaundiceResponse == "Normal" ||
              _jaundiceResponse == "Abnormal") {
            await Utility.saveLabelstoPrefrences(_jaundiceResponse);
          } else {
            await Utility.saveLabelstoPrefrences("Not Detected");
          }
        } catch (e) {
          // Handle Error Here ;
        }
      } else {
        setState(() {
          _isLoading = false;
          _jaundiceResponse = "You are Offline Please connect to the internet";
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _jaundiceResponse = error;
      });
    }
  }

  Future<void> _onImageButtonPressed(ImageSource source) async {
    try {
      setState(() {
        _isLoading = true;
        _jaundiceResponse = " ";
        _faceDetected = false;
        _image = null;
        _jaundiceResponse = " ";
      });

      final XFile? pickedFile = await picker.pickImage(
        source: source,
      );
      setState(() {
        _setImageFileListFromFile(pickedFile);
        _pickedImage = pickedFile!;
      });

      final GoogleVisionImage visionImage =
          GoogleVisionImage.fromFile(File(pickedFile!.path));

      final FaceDetector faceDetector = GoogleVision.instance.faceDetector(
          const FaceDetectorOptions(
              mode: FaceDetectorMode.fast,
              enableLandmarks: true,
              enableClassification: false,
              enableContours: false,
              enableTracking: false));

      _faces = await faceDetector.processImage(visionImage);

      final data = await pickedFile.readAsBytes();

      if (mounted) {
        await decodeImageFromList(data).then((value) => setState(() {
              _image = value;
              if (_faces!.length > 1) {
                _isLoading = false;
              } else if (_faces!.isEmpty) {
                _faceDetected = false;
                _isLoading = false;
              } else if (_faces!.length == 1) {
                _faceDetected = true;
                _classifyJaundice();
              }
            }));
      }
    } catch (e) {
      setState(() {
        _pickImageError = e;
        _isLoading = false;
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
    } else {
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

  Future<Widget> _previewImages(BuildContext context) async {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }

    if (_imageFileList != null) {
      return Future.value(Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child:  Container(
              padding: const EdgeInsets.fromLTRB(10.0, 20.0, 20.0, 0.0),
              width: MediaQuery.of(context).size.width - 120,
              height: MediaQuery.of(context).size.height - 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    child: SizedBox(
                        width: _image == null ? 300 : _image!.width.toDouble(),
                        height: _image == null ? 400 : _image!.height.toDouble(),
                        child: _image == null
                            ? Image.file(File(_pickedImage.path))
                            : CustomPaint(
                          painter: FacePainter(_image!, _faces!),
                        )),
                  ),
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _isLoading == true
                              ? const Text.rich(TextSpan(
                            children: [
                              TextSpan(
                                text: "Loading ...!!  ",
                                style: TextStyle(color: Colors.white),
                              ),
                              WidgetSpan(
                                child: SizedBox(width: 10),
                              ),
                              WidgetSpan(
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Color(0XFFFFDD00),
                                      strokeWidth: 2,
                                    ),
                                  ))
                            ],
                          ))
                              : Text.rich(TextSpan(children: [
                            const TextSpan(
                                text: "Done .... ",
                                style: TextStyle(color: Colors.white)),
                            WidgetSpan(
                                child:
                                Icon(Icons.done, color: Colors.green[400]))
                          ])),
                          const SizedBox(height: 10),
                          PreviewFacesResponse(value: _faces!.length),
                          const SizedBox(height: 10),
                          _isLoading
                              ? const SizedBox(height: 5)
                              : PreviewJaundiceResponse(value: _jaundiceResponse),
                        ],
                      ))
                ],
              ),
        ),
      ),
      ),
      );
    } else if (_pickImageError != null) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/Image_not_available.png",
            fit: BoxFit.cover,
          ),
          const Text("Couldn't Load the image please try again ",
              style: TextStyle(color: Colors.white))
        ],
      ));
    } else {
      return Center(
          child: Image.asset("assets/images/Image_not_available.png",
              fit: BoxFit.cover));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
        key: UniqueKey(),
        child: Scaffold(
          drawer: const NavigationDrawerWidget(),
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Image.asset(
              "assets/images/Logo_Logo_Logo.png",
              height: 110,
            ),
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
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Semantics(
                child: Button(
                  heroTag: "btn1",
                  backgroundColor: const Color(0XFFFFDD00),
                  key: UniqueKey(),
                  onButtonClick: () {
                    _onImageButtonPressed(ImageSource.gallery);
                  },
                  tooltip: 'Pick Image from gallery',
                  size: 70,
                  child: const Icon(Icons.photo, color: Color(0XFF232323)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Button(
                  heroTag: "btn2",
                  key: UniqueKey(),
                  backgroundColor: const Color(0XFF232323),
                  onButtonClick: () {
                    _onImageButtonPressed(ImageSource.camera);
                  },
                  tooltip: 'Take a Photo',
                  size: 70,
                  child: const Icon(Icons.camera_alt, color: Color(0XFFFFDD00)),
                ),
              )
            ],
          ),
        ));
  }
}
