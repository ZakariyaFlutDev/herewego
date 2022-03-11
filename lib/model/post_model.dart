class Post {
  String userId;
  String firstName;
  String lastName;
  String content;
  String data;

  Post(this.userId, this.firstName, this.lastName, this.content, this.data);

  Post.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        content = json['content'],
        data = json['data'];

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'firstName': firstName,
        'lastName': lastName,
        'content': content,
        'data': data,
      };
}
