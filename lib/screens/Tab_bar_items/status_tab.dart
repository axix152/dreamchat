import 'package:dreamchat/screens/StatusPage/HeadOwnStatus.dart';
import 'package:dreamchat/screens/StatusPage/OtherStatus.dart';
import 'package:flutter/material.dart';

class StatusTab extends StatelessWidget {
  const StatusTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        Container(
          height: 48,
          child: FloatingActionButton(
            backgroundColor: Colors.blueGrey[100],
            elevation: 8,
            onPressed: () {},
            child: Icon(
              Icons.edit,
              color: Colors.blueGrey[900],
            ),
          ),
        ),
        SizedBox(
          height: 13,
        ),
        FloatingActionButton(
          onPressed: () {},
          backgroundColor: Color.fromARGB(255, 73, 86, 255),
          elevation: 5,
          child: Icon(Icons.camera_alt),
        )
      ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //SizedBox(
            //height: 10,
            //),
            HeadOwnStatus(),
            label("Recent Updates", context),
            OtherStatus(
              name: "Chris Hismworth",
              imageName: "assets/4.jpeg",
              time: "05:27",
            ),

            OtherStatus(
              name: "Chris Evens",
              imageName: "assets/3.jpg",
              time: "01:27",
            ),

            OtherStatus(
              name: "Chris Super Main",
              imageName: "assets/2.jpg",
              time: "02:27",
            ),
          ],
        ),
      ),
    );
  }

  Widget label(String labelname, context) {
    return Container(
      height: 33,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey[300],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        child: Text(
          labelname,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
