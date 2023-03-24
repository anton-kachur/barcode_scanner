import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;


OutlineInputBorder textFieldStyle = OutlineInputBorder(
  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
  borderSide: BorderSide(color: Colors.grey.shade700, width: 2.0),
);


class GenerateQRCode extends StatefulWidget {
  const GenerateQRCode({super.key});

  @override
  _GenerateQRCodeState createState() => _GenerateQRCodeState();
}


class _GenerateQRCodeState extends State<GenerateQRCode> {
  final GlobalKey _key = GlobalKey();
  var text = '';
  bool saveStatus = false;


  void _saveToGallery() async {
    RenderRepaintBoundary boundary = _key.currentContext!.findRenderObject() as RenderRepaintBoundary;

    if (boundary.debugNeedsPaint) {
      Timer(const Duration(seconds: 1), () => _saveToGallery());
      return null;
    }

    ui.Image image = await boundary.toImage();

    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  
    if (byteData != null) {
      Uint8List pngint8 = byteData.buffer.asUint8List();

      final saveImage = await ImageGallerySaver.saveImage(Uint8List.fromList(pngint8), quality: 100, name: 'qrcode-${DateTime.now()}.png');
      saveStatus = saveImage['isSuccess'];
      if (saveStatus) { alert(); }
    }  
  }


  alert() {
    return Fluttertoast.showToast(
      msg: "Збережено",
      toastLength: Toast.LENGTH_SHORT,
      textColor: Colors.black,
      fontSize: 16,
      timeInSecForIosWeb: 2,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color.fromARGB(255, 208, 208, 208),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Створити власний QR-код'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 59, 59, 59),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              margin: const EdgeInsets.all(20),
              child: TextFormField(
                  autofocus: false,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  autocorrect: true,
                  enableSuggestions: true,
                  cursorRadius: const Radius.circular(10.0),
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    labelText: 'Введіть текст або URL',
                    hintStyle:
                        TextStyle(fontSize: 12, color: Colors.grey.shade400),
                    labelStyle:
                        TextStyle(fontSize: 12, color: Colors.grey.shade400),
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    focusedBorder: textFieldStyle,
                    enabledBorder: textFieldStyle,
                  ),
                  onChanged: (String value) {
                    text = value;
                  })),

          //This button when pressed navigates to QR code generation
          ElevatedButton(
              onPressed: () async {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return RepaintBoundary(
                        key: _key,
                        child: Scaffold(
                          appBar: AppBar(
                            title: const Text('Створений QR-код'),
                            centerTitle: true,
                            backgroundColor: const Color.fromARGB(255, 59, 59, 59),
                          ),
                          
                          body: QrImage(
                              data: text,
                              padding: const EdgeInsets.all(30),
                            ),

                          floatingActionButton: FloatingActionButton.extended(
                            icon: const Icon(Icons.save_alt_rounded),
                            label: const Text("Зберегти"),
                            onPressed: _saveToGallery,
                            backgroundColor: const Color.fromARGB(255, 59, 59, 59),
                          ),
                        )
                    );
                }));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 59, 59, 59),
              ),
              child: const Text('Створити')),
        ],
      ),
    );
  }
}
