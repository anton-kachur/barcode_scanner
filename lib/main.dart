// @dart=2.9
import 'dart:async';
import 'package:barcode_scanner/fingerprint.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:barcode_scanner/generate_qr_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barcode Scanner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _scanBarcode =
      'Натисніть на кнопку, щоб розпочати сканування штрих-коду.';
  var url;

  void _launchURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Не вдалося відкрити посилання $url';
    }
  }

  Future<void> scanBarcode() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#FF2C2C',
        'Скасувати',
        true,
        ScanMode.BARCODE,
      );
    } on PlatformException {
      barcodeScanRes = 'Не вдалося сканувати штрих-код.';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
      if (_scanBarcode.contains('http://') ||
          _scanBarcode.contains('https://')) {
        url = _scanBarcode;
      } else if (RegExp(r'^[0-9]+$').hasMatch(_scanBarcode)) {
        url =
            'https://www.google.com/search?q=$_scanBarcode&oq=$_scanBarcode&aqs=chrome.0.69i59j69i60.2057j0j7&sourceid=chrome&ie=UTF-8';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(

      appBar: AppBar(
        title: const Text('Barcode Scanner'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 59, 59, 59),
        actions: [
          
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GenerateQRCode()
                )
              );
            },
            icon: const Icon(Icons.add_box_rounded)
          ),

          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Fingerprint()
                )
              );
            },
            icon: const Icon(Icons.fingerprint_rounded)
          )

        ],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            if (_scanBarcode !=
                'Натисніть на кнопку, щоб розпочати сканування штрих-коду.'
              ) const Text('Результат сканування:'),
            
            SelectableText(
              _scanBarcode == '-1' ? '' : _scanBarcode,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center
            ),
            
            if (_scanBarcode.contains('http://') ||
                _scanBarcode.contains('https://') ||
                RegExp(r'^[0-9]+$').hasMatch(_scanBarcode)
              )
              Center(
                child: ElevatedButton(
                  onPressed: _launchURL,
                  child: const Text('Відкрити посилання'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 59, 59, 59),
                  ),
                ),
              ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.camera_alt),
        label: const Text("Сканувати"),
        onPressed: scanBarcode,
        backgroundColor: const Color.fromARGB(255, 59, 59, 59),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
