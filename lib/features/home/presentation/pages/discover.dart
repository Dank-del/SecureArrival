// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/data/location/get.dart';
import 'package:intl/intl.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

import '../../../../core/data/service/location_service.dart';

class Discover extends StatefulWidget {
  const Discover({Key? key}) : super(key: key);

  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  late Future<Position> positionFuture;
  TextEditingController timeInput = TextEditingController();

  @override
  void initState() {
    super.initState();
    timeInput.text = "";
    positionFuture = determinePosition();
  }

  Future openDialog(PickedData pickedData) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            scrollable: true,
            title: const Text("Set ETA"),
            content: Center(
              child: TextField(
                  controller: timeInput,
                  //editing controller of this TextField
                  decoration: const InputDecoration(
                      icon: Icon(Icons.timer), //icon of text field
                      labelText: "Enter Time" //label text of field
                      ),
                  readOnly: true,
                  //set it true, so that user will not able to edit text
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                    );

                    if (pickedTime != null) {
                      if (kDebugMode) {
                        print(pickedTime.format(context));
                      } //output 10:51 PM
                      DateTime parsedTime = DateFormat.jm()
                          .parse(pickedTime.format(context).toString());
                      //converting to DateTime so that we can further format on different pattern.
                      if (kDebugMode) {
                        print(parsedTime);
                      } //output 1970-01-01 22:53:00.000
                      String formattedTime =
                          DateFormat('HH:mm:ss').format(parsedTime);
                      if (kDebugMode) {
                        print(formattedTime);
                      } //output 14:59:00
                      //DateFormat() is from intl package, you can format the time on any pattern you need.

                      setState(() {
                        timeInput.text =
                            formattedTime; //set the value of text field.
                      });
                    } else {
                      if (kDebugMode) {
                        print("Time is not selected");
                      }
                    }
                  }),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    var txt = Text('Set Destination to ${pickedData.address}, '
                        'estimated arrival time ${timeInput.text}');
                    try {
                      await LocationService.instance.addNewTrail(
                          pickedData.latLong.latitude,
                          pickedData.latLong.longitude,
                          timeInput.text);
                    } catch (e) {
                      txt = Text(
                          "Failed to connect to AppWrite service\n Error: $e");
                    }
                    Navigator.of(context).pop();
                    final snackBar = SnackBar(
                      content: txt,
                      action: SnackBarAction(
                        label: 'Dismiss',
                        onPressed: () {},
                      ),
                    );

                    // Find the ScaffoldMessenger in the widget tree
                    // and use it to show a SnackBar.
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: const Text("Confirm"))
            ],
          ));

  @override
  Widget build(BuildContext context) {
    return Center(
        child: FutureBuilder<Position>(
            future: positionFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return OpenStreetMapSearchAndPick(
                    center: LatLong(
                        snapshot.data!.latitude, snapshot.data!.longitude),
                    locationPinIconColor: Theme.of(context).primaryColor,
                    buttonColor: Theme.of(context).primaryColor,
                    buttonText: 'Set Destination Location',
                    onPicked: (pickedData) {
                      if (kDebugMode) {
                        print(pickedData.latLong.latitude);
                        print(pickedData.latLong.longitude);
                        print(pickedData.address);
                        openDialog(pickedData);
                      }
                    });
              } else {
                return const CircularProgressIndicator();
              }
            }));
    // body: ListView(
    //   padding: const EdgeInsets.all(20),
    //   children: <Widget>[
    //     Container(
    //       height: 50,
    //       color: Colors.purple[200],
    //       child: const Center(child: Text('Current Location')),
    //     ),
    //     AspectRatio(
    //       aspectRatio: 16 / 9,
    //       child: OpenStreetMapSearchAndPick(
    //           center: LatLong(23, 89),
    //           buttonColor: Colors.blue,
    //           buttonText: 'Set Destination Location',
    //           onPicked: (pickedData) {
    //             if (kDebugMode) {
    //               print(pickedData.latLong.latitude);
    //               print(pickedData.latLong.longitude);
    //               print(pickedData.address);
    //             }
    //           }),
    //     ),
    //     const Padding(
    //       padding: EdgeInsets.symmetric(vertical: 16),
    //       child: TextField(
    //         decoration: InputDecoration(
    //           border: OutlineInputBorder(),
    //           hintText: 'Enter new destination',
    //         ),
    //       ),
    //     ),
    //   ],
    // ),
  }
}
