import 'package:flutter/material.dart';
import 'package:sportify_app/database/database_instance.dart';
import 'package:sportify_app/database/field_model.dart';
import 'package:sportify_app/utils/constants.dart';

class LatihanSQLlite extends StatefulWidget {
  const LatihanSQLlite({super.key});

  @override
  State<LatihanSQLlite> createState() => _LatihanSQLliteState();
}

class _LatihanSQLliteState extends State<LatihanSQLlite> {
  DatabaseInstance databaseInstance = DatabaseInstance();
  Future<List<FieldModel>>? listData;

  @override
  void initState() {
    databaseInstance.database();
    super.initState();
  }

  void refreshScreen() async {
    try {
      await databaseInstance.database();
      setState(() {
        listData = databaseInstance.all();
      });
    } catch (error) {
      debugPrint('Error fetching Tour Plan: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Latihan CRUD"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/home_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<FieldModel>>(
          future: listData,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: Text('There is no data'));
            }
            if (snapshot.hasData) {
              return generateList(snapshot.data!);
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          refreshScreen();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String name = '';
              String activity = '';
              String location = '';
              return AlertDialog(
                title: const Text('Add Field Data'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) {
                        name = value;
                      },
                      decoration:
                          const InputDecoration(labelText: 'Field name'),
                    ),
                    TextField(
                      onChanged: (value) {
                        activity = value;
                      },
                      decoration: const InputDecoration(labelText: 'Activity'),
                    ),
                    TextField(
                      onChanged: (value) {
                        location = value;
                      },
                      decoration: const InputDecoration(labelText: 'Location'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (name.isNotEmpty &&
                          activity.isNotEmpty &&
                          location.isNotEmpty) {
                        await databaseInstance.insert({
                          'name': name,
                          'activity': activity,
                          'location': location,
                          'createdAt': DateTime.now().toString(),
                          'updatedAt': DateTime.now().toString(),
                        });
                        setState(() {
                          refreshScreen();
                        });
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill in all fields.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
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

  Widget generateList(
    List<FieldModel> dataList,
  ) {
    return ListView.builder(
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            '${dataList[index].activity ?? ''} - ${dataList[index].name ?? ''}',
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on),
                  Text(dataList[index].location ?? ''),
                ],
              ),
              Text(
                'Created At: ${dataList[index].createdAt}',
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                'Updated At: ${dataList[index].updatedAt}',
                style: const TextStyle(fontSize: 12),
              ),
              Text('id: ${dataList[index].id}'),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _editDataDialog(dataList[index]);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _deleteData(dataList[index].id!, dataList);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _editDataDialog(FieldModel fieldModel) async {
    String name = fieldModel.name ?? '';
    String activity = fieldModel.activity ?? '';
    String location = fieldModel.location ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  name = value;
                },
                decoration: const InputDecoration(labelText: 'Name'),
                controller: TextEditingController(text: name),
              ),
              TextField(
                onChanged: (value) {
                  activity = value;
                },
                decoration: const InputDecoration(labelText: 'Activity'),
                controller: TextEditingController(text: activity),
              ),
              TextField(
                onChanged: (value) {
                  location = value;
                },
                decoration: const InputDecoration(labelText: 'Location'),
                controller: TextEditingController(text: location),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (name.isNotEmpty &&
                    activity.isNotEmpty &&
                    location.isNotEmpty) {
                  await databaseInstance.update(fieldModel.id!, {
                    'name': name,
                    'activity': activity,
                    'location': location,
                    'updatedAt': DateTime.now().toString(),
                  });
                  setState(() {
                    refreshScreen();
                  });
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteData(int id, List<FieldModel> dataList) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Data'),
          content: const Text('Are you sure you want to delete this data?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await databaseInstance.delete(id);
                setState(() {
                  refreshScreen();
                });

                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
