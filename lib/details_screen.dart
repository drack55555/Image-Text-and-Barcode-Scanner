import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({ Key? key }) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  String ?selectedItem ;

  //var textScanning=true;

  late File pickedImage;

  bool isImageLoaded = false;

  String text= '';
  getImageFromGallery() async{
    var tempStore = await ImagePicker().pickImage(source: ImageSource.gallery);
    
    setState(() {
      pickedImage = File(tempStore!.path); //Loading the image..
      isImageLoaded= true; // image when fully loaded make it true..
    });
  }

  readTextFromImage() async { //image ko extract krne ka algo....

    text= ''; //fresh image jab aayega to phir se text null hoga..wrna old text k sath show krega new v..
    final inputImage= InputImage.fromFile(pickedImage);
    final textDetector= GoogleMlKit.vision.textRecognizer();
    RecognizedText recognizedText= await textDetector.processImage(inputImage);

    await textDetector.close();
    for(TextBlock block in recognizedText.blocks){
      for(TextLine line in block.lines){
          text= text+ line.text + '\n';
      }
    }
    setState(() {});
  }

  decodeBarcode() async {
    text='';
    final inputImage= InputImage.fromFile(pickedImage);
    final barcodeScnnr= GoogleMlKit.vision.barcodeScanner();
    List barCodes= await barcodeScnnr.processImage(inputImage);

    for(Barcode readableCode in barCodes){
      text= readableCode.displayValue!;
    }

    setState(() {});
  }

detectWork(String? selectedFeature){
  switch (selectedFeature) {

    case 'Barcode Scanner': decodeBarcode();
      break;
    case 'Text Scanner': readTextFromImage();
      break;
    default: const Text('Select Something');
  }
}



  @override
  Widget build(BuildContext context) {
    selectedItem= ModalRoute.of(context)?.settings.arguments.toString(); //what we select..text scanner or barcode scanner...
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedItem!),
        actions: [
          ElevatedButton(
            onPressed: getImageFromGallery,
            child: const Icon(
              Icons.add_a_photo, //kis type ka icon rhegaa...
              color: Colors.white,
            ),
            style: ElevatedButton.styleFrom(
               primary: Colors.purple,   // Background color
               onPrimary: Colors.red, //text color on the button
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 100),
          isImageLoaded ? Center(
            child: Container(
              height: 250.0,
              width: 250.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(pickedImage), //image show kro screen pr after it's picked...
                  fit: BoxFit.cover,
                )
              ),
            ),            
          ) : const Text('Feed me an image!'),

          const SizedBox(height: 40),
          Text(
            text,
            textAlign: TextAlign.center,
            textScaleFactor: 1.5,
            style: const TextStyle(color: Colors.red, fontSize: 15),
          ),
        ],
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          detectWork(selectedItem);
        },
        child: const Icon(
          Icons.check,
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.black,
        splashColor: Colors.red,
      ),
    );
  }
}