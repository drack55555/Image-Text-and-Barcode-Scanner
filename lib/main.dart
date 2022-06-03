import 'package:flutter/material.dart';
import 'package:ml_app_basic/details_screen.dart';

void main() {
  runApp(const MaterialApp(
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<String> itemList= ['Text Scanner', 'Barcode Scanner'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic ML App'),
      ),
      body: ListView.builder(
        itemCount: itemList.length,
        itemBuilder: (context, index){
          return Card(
            child: ListTile(
              title: Text(itemList[index]),
              onTap: (){
                Navigator.push(context,MaterialPageRoute(
                  builder: (context)=>const DetailsScreen(), //yaha navigate ho...
                  settings: RouteSettings(arguments: itemList[index]) //jis p itemList p click kiye..wo navigate hoga DetailsScreen p..
                ));
              },
            ),
          );
        }
      ),
    );
  }
}