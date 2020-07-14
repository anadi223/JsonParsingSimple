import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future data;
  @override
  void initState() { // using initstate so that when our app runs it will show the data without holding the user to wait.
    super.initState();
    data = getData(); //initialising the getdata method.
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
       appBar: AppBar(
         title: Text("Json Parsing Simple"),
       ),
        body: Center(
          child: Container(
            child: FutureBuilder(        ///This future builder is used to get the data displayed on the screen
              future: getData(),   // This future variable tells us where the data is being coming from
                builder: (context, AsyncSnapshot snapshot){  //builder builds the data and ASYNCSNAPSHOT is the dynamic type of snapshot
                if(snapshot.hasData){  ///This is used because we have to check first whether the data is ready to be displayed or not
                  //return Text(snapshot.data[0]['title']);
                  return createListView(snapshot.data,context);
                }
                return CircularProgressIndicator(); // This is returned in case data is not ready to be displayed
                }),
          ),
        ),
      ),
    );


  }
  Future getData() async{ //this is the process to get the data
    var data;
    String url = "https://jsonplaceholder.typicode.com/posts";
    Network network = new Network(url);
    data = network.fetchData();
    return data;
  }

  Widget createListView(List data, BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: data.length,
          itemBuilder: (context,int index){
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Divider(height: 5.0,),
              ListTile(
                title: Text("${data[index]['title']}"),
                subtitle: Text("${data[index]['body']}"),
                leading: CircleAvatar(
                  child: Text("${data[index]['id']}"),
                ),
              )
            ],
          );
          })
    );
  }
}

//-----------------------------------------------------------------------//-------------------------//---------------
//This is the class responsible for fetching the data.
class Network{

  final String url;//url from where the data to be fetched.

  Network(this.url);

  Future fetchData() async{   // A future method responsible to get data from the url that we will provide.
    print('$url');

    Response response = await get(Uri.encodeFull(url)); //this encodefull is used to remove any error like typo or space in the url.
    if(response.statusCode ==200){     //Status Code = 200 meaning everything is fine.
      return jsonDecode(response.body); //encoding to json because the body is of type string and we want data in json type.
    }else {
      print(response.statusCode);
    }

  }

}