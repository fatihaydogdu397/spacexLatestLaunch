import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'dart:convert';

// import 'package:flutter_samples/fetch_data/photo.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SpaceX(),
    );
  }
}

class SpaceX extends StatefulWidget {
  SpaceX({Key key}) : super(key: key);

  @override
  _SpaceXState createState() => _SpaceXState();
}

class _SpaceXState extends State<SpaceX> {
  Map map;
  var isLoading = false;

  Future<void> _veriCek() async {
    setState(() {
      isLoading = true;
    });
    final istek =
        await http.get("https://api.spacexdata.com/v4/launches/latest");
    setState(() {
      isLoading = true;
    });
    if (istek.statusCode == 200) {
      setState(() {
        map = jsonDecode(istek.body);
        print(map["links"]["patch"]["large"]);
        isLoading = false;
      });
    } else {
      throw Exception('Veri çekilirken bir hata oluştu.');
    }
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _veriCek());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: isLoading
              ? [
                  Center(child: CircularProgressIndicator()),
                ]
              : [
                  Column(
                    children: [
                      Material(
                        elevation: 6,
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image(
                                image: NetworkImage(
                                    "${map["links"]["patch"]["small"]}")),
                          ),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            "${map["name"]}",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w800),
                          )),
                      Container(
                          padding: EdgeInsets.all(20),
                          child: AutoSizeText(
                            "${map["details"]}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          )),
                    ],
                  ),
                ],
        ),
      ),
    );
  }
}

// class VeriCek extends StatefulWidget {
//   @override
//   VeriCekState createState() => _VeriCekState();
// }

// class _VeriCekState extends State<VeriCek> {
//   Map map;
//   var isLoading = false;

//   Future<Map> _VeriCek() async {
//     final istek =
//         await http.get("https://api.spacexdata.com/v4/launches/latest");
//     if (istek.statusCode == 200) {
//       map = json.decode(istek.body) as Map;
//     } else {
//       throw Exception('Veri çekilirken bir hata oluştu.');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Fetch Data JSON"),
//         ),
//         bottomNavigationBar: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: RaisedButton(
//             child: new Text("JSON Veri Çekmek"),
//             onPressed: _VeriCek,
//           ),
//         ),
//         body: yukleniyor
//             ? Center(
//                 child: CircularProgressIndicator(),
//               )
//             : ListView.builder(
//                 itemCount: list.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return ListTile(
//                     contentPadding: EdgeInsets.all(10.0),
//                     title: new Text(list[index]['title']),
//                     trailing: new Image.network(
//                       list[index]['thumbnailUrl'],
//                       fit: BoxFit.cover,
//                       height: 40.0,
//                       width: 40.0,
//                     ),
//                   );
//                 }));
//   }
// }
