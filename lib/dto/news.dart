//import 'package:uri/uri.dart';

class News {
  final String id;
  String title;
  String body;
  String photo;

  News(
      {required this.id,
      required this.title,
      required this.body,
      required this.photo}) {
    // Validasi URL gambar jika tidak kosong
    if (photo.isNotEmpty) {
      var uri = Uri.parse(photo);
      if (uri.scheme.isEmpty || uri.host.isEmpty) {
        throw ArgumentError('Invalid photo URL');
      }
    }
  }

  factory News.fromJson(Map<String, dynamic> json) => News(
        id: json['id'],
        title: json['title'],
        body: json['body'],
        photo: json['photo'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'photo': photo,
      };
}
