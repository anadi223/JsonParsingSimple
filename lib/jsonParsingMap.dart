import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(JsonParsingMap());
}

class JsonParsingMap extends StatefulWidget {
  @override
  _JsonParsingMapState createState() => _JsonParsingMapState();
}

class _JsonParsingMapState extends State<JsonParsingMap> {
  Future<PostList> data;

  @override
  void initState() {
    super.initState();
    Network network = new Network("https://jsonplaceholder.typicode.com/posts");
    data = network.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            child: FutureBuilder(
              future: data,
              builder: (context, AsyncSnapshot<PostList> snapshot) {
                List<Post> allPosts;
                if (snapshot.hasData) {
                  allPosts = snapshot.data.posts;
                  return createListView(allPosts, context);
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget createListView(List<Post> data, BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, int index) {
            return Column(
              children: <Widget>[
                Divider(
                  height: 5.0,
                ),
                ListTile(
                  title: Text("${data[index].title}"),
                  subtitle: Text("${data[index].body}"),
                  leading: CircleAvatar(
                    child: Text("${data[index].id}"),
                  ),
                )
              ],
            );
          }),
    );
  }
}

class Network {
  final String url;

  Network(this.url);

  Future<PostList> loadData() async {
    final response = await get(url);
    if (response.statusCode == 200) {
      return PostList.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("failed to get posts");
    }
  }
}

class PostList {
  ///creating this postlist because we want that the post is of list type but we are getting only 1 item from the list.
  final List<Post> posts;

  PostList({this.posts});

  factory PostList.fromJson(List<dynamic> parsedJson) {
    List<Post> posts = new List<Post>();
    posts = parsedJson.map((i) => Post.fromJson(i)).toList();
    return new PostList(posts: posts);
  }
}

class Post {
  int userId;
  int id;
  String title;
  String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        userId: json['userId'],
        id: json['id'],
        title: json['title'],
        body: json['body']);
  }
}
