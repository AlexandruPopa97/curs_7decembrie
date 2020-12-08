import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Flags(),
    );
  }
}

class Flags extends StatefulWidget {
  @override
  _FlagsState createState() => _FlagsState();
}

class _FlagsState extends State<Flags> {
  Response response;
  final List<String> countries = [];
  final List<String> urls = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCountries();
  }

  Future<void> getCountries() async {
    response =
    await get('https://www.worldometers.info/geography/flags-of-the-world/');
    final String data = response.body;
    final List<String> parts = data.split('<a href="/img/flags/')
        .skip(1)
        .toList();
    for (final String part in parts) {
      String country = part.split('10px">')[1].split('<')[0];
      countries.add(country);
      String file = part.substring(0, part.indexOf('"'));
      urls.add('https://www.worldometers.info/img/flags/' + file);
    }
    setState(() {
      //Countries List changed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flags'),
        backgroundColor: Colors.grey[600],
      ),
      backgroundColor: Colors.grey[350],
      body: GridView.builder(
        itemCount: countries.length,
        padding: EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 0.0,
          childAspectRatio: 0.66,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(child: Image.network(urls[index], fit: BoxFit.fill)),
                  Expanded(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          countries[index],
                          style: TextStyle(color: Colors.black),
                        ),
                      )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
