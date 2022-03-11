import 'package:firebase_database/firebase_database.dart';
import 'package:herewego/model/post_model.dart';

class RTDBService{
  static final _db = FirebaseDatabase.instance.ref('posts');

  static Future<Stream<DatabaseEvent>> addPost(Post post) async{
    _db.push().set(post.toJson());
    return _db.onChildAdded;
  }

  static Future<List<Post>> getPosts(String id) async{
    List<Post> items = [];
    Query query = _db.orderByChild('userId').equalTo(id);
    DatabaseEvent event = await query.once();
    var result = event.snapshot.children.cast();

    for(var item in result){
      items.add(Post.fromJson(Map<String,dynamic>.from(item.value)));
    }
    return items;
  }
}