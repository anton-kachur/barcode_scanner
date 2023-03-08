import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

OutlineInputBorder textFieldStyle = OutlineInputBorder(
  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
  borderSide: BorderSide(color: Colors.grey.shade700, width: 2.0),
);

class GenerateQRCode extends StatefulWidget {
  const GenerateQRCode();

  @override
  _GenerateQRCodeState createState() => _GenerateQRCodeState();
}

class _GenerateQRCodeState extends State<GenerateQRCode> {
  var text = '';

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
                    contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    focusedBorder: textFieldStyle,
                    enabledBorder: textFieldStyle,
                  ),
                  onChanged: (String value) {
                    text = value;
                  })),

          //This button when pressed navigates to QR code generation
          ElevatedButton(
              onPressed: () async {
                Navigator.pop(context, false);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return Scaffold(
                      appBar: AppBar(
                        title: const Text('Створений QR-код'),
                        centerTitle: true,
                        backgroundColor: const Color.fromARGB(255, 59, 59, 59),
                      ),
                      body: QrImage(
                        data: text,
                        padding: EdgeInsets.all(30),
                      ));
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
