import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Map _quacks;
List _features;

void main() async{

  _quacks = await getQuacks();

  _features = _quacks['features'];

  print(_features[0]);

  //print(_quacks['features'][0]['properties']);

  runApp(new MaterialApp(
    title: "Quack",
    home: new Quack(),
  ));
}


class Quack extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return new Scaffold(

      appBar: new AppBar(
        title: new Text("Quack App"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: new Center(
        child: new ListView.builder(
          itemCount: _features.length,
          padding: const EdgeInsets.all(15.5),

          itemBuilder: (BuildContext context, int position){

            if(position.isOdd) return new Divider();
            final value = position ~/2;

            String time = readTimestamp(_features[value]['properties']['updated']);

            return ListTile(
              title: new Text('$time',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),),
              subtitle: new Text('${_features[value]['properties']['place']}',
              style: new TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.normal,
                color: Colors.black54
              ),),
              leading: new CircleAvatar(
                backgroundColor: Colors.red,
                child: new Text('${_features[value]['properties']['mag']}',
                style: new TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                ),),
              ),

              onTap: () {_showAllertDialog(context, "${_features[value]['properties']['place']}");},
            );
          },

        ),
      ),
    );
  }

  void _showAllertDialog(BuildContext context, String s) {
    var alretdialg = new AlertDialog(
      title: new Text("Quack"),
      content: new Text("${s}"),
      actions: <Widget>[
        new FlatButton(
          onPressed: (){Navigator.pop(context);},
          child: new Text("OK"),
        )
      ],
    );

    showDialog(context: context, child: alretdialg);
  }

}


String readTimestamp(int timestamp) {
  var now = DateTime.now();

  var df = DateFormat('dd-MM-yyyy hh:mm a');

  return df.format(new DateTime.fromMillisecondsSinceEpoch(timestamp*1000));

}


Future<Map> getQuacks() async{

    String apiURL = 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.geojson';
  // String apiURL = 'https://jsonplaceholder.typicode.com/posts';

  http.Response response = await http.get(apiURL);

  return json.decode(response.body);
}
