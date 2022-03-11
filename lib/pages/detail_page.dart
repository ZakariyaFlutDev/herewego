import 'package:flutter/material.dart';
import 'package:herewego/model/post_model.dart';
import 'package:herewego/pages/home_page.dart';
import 'package:herewego/services/prefs_service.dart';
import 'package:herewego/services/rtdb_service.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  static const String id = "detail_page";

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var contentController = TextEditingController();
  var dateController = TextEditingController();

  _addPost() async {
    String firstName = firstNameController.text.toString();
    String lastName = lastNameController.text.toString();
    String content = contentController.text.toString();
    String data = dateController.text.toString();

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        content.isEmpty ||
        data.isEmpty) return;

    _apiAddPost(firstName, lastName, content, data);

  }

  _apiAddPost(String firstName,String lastName,String content,String data) async{
    var id = await Prefs.loadUserId();
    RTDBService.addPost(Post(id!, firstName, lastName, content, data))
        .then((value) => {
          _respAddPost(),
    });
  }

  _respAddPost(){
    Navigator.of(context).pop({'data':'done'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Post"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                  hintText: "First Name",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(hintText: "Last Name"),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(hintText: "Content"),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(hintText: "Date"),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 50,
                width: double.infinity,
                color: Colors.deepOrangeAccent,
                child: ElevatedButton(
                  child: Text("Add"),
                  onPressed: _addPost,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
