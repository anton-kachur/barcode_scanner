import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_compare/image_compare.dart';
import 'package:image_picker/image_picker.dart';


class Fingerprint extends StatefulWidget {
  const Fingerprint({Key? key}) : super(key: key);

  @override
  _FingerprintState createState() => _FingerprintState();
}

class _FingerprintState extends State<Fingerprint> {
  var image1;
  var image2;
  int index = 1;
  double tolerance = 0.05;

  String resultText = '';
  
 
  void _compareAll() async {
    
    // Calculate euclidean color distance between two images
    var imageResult = await compareImages(
      src1: image1, src2: image2, 
      algorithm: PixelMatching(tolerance: tolerance, ignoreAlpha: true)
    );

    double difference = imageResult * 100;

    if (difference <= 2) {
      resultText = 'Відбитки ідентичні.';
    } else {
      resultText = 'Відбитки різні.';
    }

    setState(() {
      resultText += ' Різниця: ${difference.toStringAsFixed(1)}%';
    });
  }

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxHeight: 1800,
      maxWidth: 1800,
    );

    if (pickedFile != null) {
      setState(() {
        if (index == 1) { image1 = File(pickedFile.path); }
        else if (index == 2) { image2 = File(pickedFile.path); }
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fingerprint Auth'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 59, 59, 59),
      ),

      body: Center(
        child: Column (
          children: [
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                
                Column(
                  children: [
                    const SizedBox(height: 10),

                    if (image1 != null)
                      Container(
                        height: 200,
                        width: 185,
                        child: Image.file(
                          image1,
                          fit: BoxFit.cover,
                        ),
                      ),
                    
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          index = 1;
                          _getFromGallery();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 59, 59, 59),
                        ),
                        child: Text(
                          image1 == null ? 
                          'Вибрати 1-й відбиток' : 
                          'Змінити 1-й відбиток'
                        ),
                      ),
                    ),

                  ],
                ),

                Column(
                  children: [
                    const SizedBox(height: 10),
                    
                    if (image2 != null)
                      Container(
                        height: 200,
                        width: 185,
                        child: Image.file(
                          image2,
                          fit: BoxFit.cover,
                        ),
                      ),

                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          index = 2;
                          _getFromGallery();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 59, 59, 59),
                        ),
                        child: Text(
                          image2 == null ? 
                          'Вибрати 2-й відбиток' : 
                          'Змінити 2-й відбиток'
                        ),
                      ),
                    ),
                    
                  ],
                ),
              
              ],
            ),
            
            const SizedBox(height: 8),

            if (image1 != null && image2 != null) 
              Slider(
                value: tolerance, 
                label: tolerance.toStringAsFixed(2),
                thumbColor: const Color.fromARGB(255, 34, 34, 34),
                activeColor: const Color.fromARGB(255, 59, 59, 59),
                inactiveColor: const Color.fromARGB(255, 176, 176, 176),
                divisions: 30,
                onChanged: (double value) {
                  setState(() {
                    tolerance = value;
                  });
                }
              ),

            const SizedBox(height: 8),

            SelectableText(
              resultText,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center
            ),
            
          ],
        ),
      ),


      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.fingerprint_rounded),
        label: const Text("Порівняти"),
        onPressed: _compareAll,
        backgroundColor: const Color.fromARGB(255, 59, 59, 59),
      ),

    );
  }
}



