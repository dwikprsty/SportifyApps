import 'package:flutter/material.dart';
import 'package:sportify_app/dto/news.dart';
import 'package:sportify_app/services/data_service.dart';
import 'package:sportify_app/utils/constants.dart';

class LatihanAPI extends StatefulWidget {
  const LatihanAPI({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LatihanAPIState createState() => _LatihanAPIState();
}

class _LatihanAPIState extends State<LatihanAPI> {
  late Future<List<News>> _news;

  @override
  void initState() {
    super.initState();
    _news = DataService.fetchNews();
  }

  void _addData(String title, String body, String photo) async {
    try {
      // Tentukan foto default jika photo kosong
      if (photo.isEmpty) {
        // Misalnya, gunakan URL foto default yang telah ditentukan sebelumnya
        photo = 'https://loremflickr.com/640/480';
      }

      await DataService.addNews(title, body, photo);
      setState(() {
        _news = DataService.fetchNews();
      });
    } catch (e) {
      // Handle error
      Text('Failed to add data: $e');
    }
  }

  void _editData(String id, String title, String body, String photo) async {
    try {
      await DataService.updateNews(id, title, body, photo);
      setState(() {
        _news = DataService.fetchNews();
      });
    } catch (e) {
      // Handle error
      Text('Failed to update data: $e');
    }
  }

  void _removeData(String id) async {
    try {
      await DataService.removeNews(id);
      setState(() {
        _news = DataService.fetchNews();
      });
    } catch (e) {
      // Handle error
      Text('Failed to remove data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Latihan API"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/home_bg.png"),
              fit: BoxFit.cover),
        ),
        child: FutureBuilder<List<News>>(
          future: _news,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final post = snapshot.data![index];
                  return ListTile(
                    title: Text(
                      post.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(post.body),
                    leading: Image.network(post.photo),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Show dialog for editing data
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                String editedTitle = post.title;
                                String editedBody = post.body;
                                String editedPhoto = post.photo;

                                return AlertDialog(
                                  title: const Text('Edit Data'),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        TextField(
                                          controller: TextEditingController(
                                            text: editedTitle,
                                          ),
                                          onChanged: (value) {
                                            editedTitle = value;
                                          },
                                          decoration: const InputDecoration(
                                              labelText: 'Title',
                                              hintText: "input title"),
                                        ),
                                        TextField(
                                          controller: TextEditingController(
                                            text: editedBody,
                                          ),
                                          onChanged: (value) {
                                            editedBody = value;
                                          },
                                          decoration: const InputDecoration(
                                              labelText: 'Subtitle',
                                              hintText: 'input subtitle'),
                                        ),
                                        TextField(
                                          controller: TextEditingController(
                                            text: editedPhoto,
                                          ),
                                          onChanged: (value) {
                                            editedPhoto = value;
                                          },
                                          decoration: const InputDecoration(
                                            labelText: 'Photo URL',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _editData(
                                          post.id,
                                          editedTitle,
                                          editedBody,
                                          editedPhoto,
                                        );
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Save'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _removeData(post.id);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show dialog for adding data
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String newTitle = '';
              String newBody = '';
              String newPhoto = '';

              return AlertDialog(
                title: const Text('Add Data'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        onChanged: (value) {
                          newTitle = value;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Title',
                        ),
                      ),
                      TextField(
                        onChanged: (value) {
                          newBody = value;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Subtitle',
                        ),
                      ),
                      TextField(
                        onChanged: (value) {
                          newPhoto = value;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Photo URL',
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Call method to add data
                      _addData(newTitle, newBody, newPhoto);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Constants.primaryColor,
        child: const Icon(Icons.add, color: Constants.activeMenu),
      ),
    );
  }
}
