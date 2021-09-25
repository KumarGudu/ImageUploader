import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final _firestore = FirebaseFirestore.instance;


// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       home: MyHomePage(),
//     );
//   }
// }


class GalleryPage extends StatefulWidget {

  static const String id = 'gallery_screen';

  @override _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Storage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Flexible(
              child: _buildBody(context),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: getImage,
      //   child: Icon(Icons.add_a_photo),
      // ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('storage').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        return _buildList(context, snapshot.data.docs);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
        padding: const EdgeInsets.only(top: 20.0),
        children: snapshot.map((data) => _buildListItem(context, data)).toList()
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.store),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  record.store,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Image.network(record.url),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text(
                      record.location,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                    Text(
                      record.longitude,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                    Text(
                      record.latitude,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Record {
  final String location;
  final String url;
  final String store;
  final String latitude;
  final String longitude;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['location'] != null),
        assert(map['url'] != null),
        assert(map['store'] != null),
        assert(map['latitude'] != null),
        assert(map['longitude'] != null),
        location = map['location'],
        url = map['url'],
        latitude = map['latitude'],
        longitude = map['longitude'],
        store = map['store'];



  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
      snapshot.data(),
      reference: snapshot.reference,
  );

  @override
  String toString() => "Record<$location:$url:$store:$latitude:$longitude>";
}


// Future<Map<String, double>> _getLocation() async {
// //var currentLocation = <String, double>{};
//   Map<String,double> currentLocation;
//   try {
//     currentLocation = await location.getLocation();
//   } catch (e) {
//     currentLocation = null;
//   }
//   setState(() {
//      userLocation = currentLocation;
//   });
//   return currentLocation;
//
// }




// getUserLocation() async {//call this async method from whereever you need
//
//   LocationData myLocation;
//   String error;
//   Location location = new Location();
//   try {
//     myLocation = await location.getLocation();
//   } on PlatformException catch (e) {
//     if (e.code == 'PERMISSION_DENIED') {
//       error = 'please grant permission';
//       print(error);
//     }
//     if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
//       error = 'permission denied- please enable it from app settings';
//       print(error);
//     }
//     myLocation = null;
//   }
//   currentLocation = myLocation;
//   final coordinates = new Coordinates(
//       myLocation.latitude, myLocation.longitude);
//   var addresses = await Geocoder.local.findAddressesFromCoordinates(
//       coordinates);
//   var first = addresses.first;
//   print(' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
//   return first;
// }














// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
//
// import 'home.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MaterialApp(
//     home: MyApp(),
//     debugShowCheckedModeBanner: false,
//   ));
// }
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return HomePage();
//   }
// }