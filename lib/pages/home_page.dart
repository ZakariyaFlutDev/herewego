import 'package:flutter/material.dart';
import 'package:herewego/model/post_model.dart';
import 'package:herewego/pages/detail_page.dart';
import 'package:herewego/pages/signIn_page.dart';
import 'package:herewego/services/auth_service.dart';
import 'package:herewego/services/prefs_service.dart';
import 'package:herewego/services/rtdb_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String id = "home_page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> items = [];

  @override
  void initState() {
    super.initState();
    _apiGetPost();
  }

  _apiGetPost() async {
    var id = await Prefs.loadUserId();
    RTDBService.getPosts(id!).then((value) => {
          _respPosts(value),
        });
  }

  _respPosts(List<Post> posts) {
    setState(() {
      items = posts;
    });
  }

  _openDetail() async {
    Map result = await Navigator.of(context)
        .push(new MaterialPageRoute(builder: (BuildContext context) {
      return new DetailPage();
    }));
    if (result != null && result.containsKey('data')) {
      print(result['data']);
      _apiGetPost();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Posts"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                AuthService.signOut(context);
                Navigator.pushReplacementNamed(context, SignInPage.id);
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ))
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (ctx, i) {
          return _itemsOfPosts(items[i]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _openDetail,
      ),
    );
  }

  Widget _itemsOfPosts(Post post) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${post.firstName} ${post.lastName}",
            style: TextStyle(color: Colors.black, fontSize: 22),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            post.data,
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            post.content,
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
