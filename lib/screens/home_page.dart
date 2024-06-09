import 'package:flutter/material.dart';
import 'package:sportify_app/dto/fields.dart';
import 'package:sportify_app/screens/field_detail_screen.dart';
import 'package:sportify_app/utils/constants.dart';
import 'package:sportify_app/widgets/flexible_form_input.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedActivity = 'Badminton';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  void _selectActivity(String activity) {
    setState(() {
      _selectedActivity = activity;
      _searchQuery = ''; // Reset search query when activity changes
      _searchController.clear(); // Clear search input field
    });
  }

  void _updateSearchQuery(String? query) {
    setState(() {
      _searchQuery = query ?? '';
    });
  }

  Widget _buildFieldList(String sport) {
    List<Map<String, String>> fieldList = [];

    switch (sport) {
      case 'Badminton':
        fieldList = [
          {
            'fileName': 'catra_badminton.jpg',
            'courtName': 'Catra Badminton',
            'location': 'Penglatan, Buleleng'
          },
          {
            'fileName': 'padma_badminton.jpg',
            'courtName': 'Padma Badminton Hall',
            'location': 'Banyuning, Buleleng'
          },
          {
            'fileName': 'pradnya_badminton.jpg',
            'courtName': 'Pradnya Badminton Hall',
            'location': 'Jl Kartini, Singaraja'
          },
          {
            'fileName': 'undiksha_badminton.jpg',
            'courtName': 'Undiksha Badminton Hall',
            'location': 'Jl Udayana, Singaraja'
          },
        ];
        break;
      case 'Volleyball':
        fieldList = [
          {
            'fileName': 'gunaksa_volley.jpg',
            'courtName': 'Gunaksa Volley',
            'location': 'Jl Ahmad Yani, Singaraja'
          },
          {
            'fileName': 'merdeka_volley.jpg',
            'courtName': 'Merdeka Volley',
            'location': 'Jl Gatot Subroto, Singaraja'
          },
          {
            'fileName': 'bina_volley.jpg',
            'courtName': 'Bina Volley',
            'location': 'Gitgit, Buleleng'
          },
          {
            'fileName': 'garuda_volley.jpg',
            'courtName': 'Garuda Volley',
            'location': 'Jl Kartini, Singaraja'
          },
          {
            'fileName': 'pratama_volley.jpg',
            'courtName': 'Pratama Volley',
            'location': 'Kubutambahan, Buleleng'
          },
        ];
        break;
      case 'Basketball':
        fieldList = [
          {
            'fileName': 'bhuana_patra_basketball.jpg',
            'courtName': 'GOR Bhuana Patra',
            'location': 'Jl Udayana, Singaraja'
          },
          {
            'fileName': 'pelita_agung_basketball.jpg',
            'courtName': 'Pelita Agung Basketball',
            'location': 'Jl Kartini, Singaraja'
          },
          {
            'fileName': 'senayan_basketball.jpeg',
            'courtName': 'Senayan Basketball',
            'location': 'Jl Ahmad Yani, Singaraja'
          },
          {
            'fileName': 'undiksha_basketball.jpg',
            'courtName': 'Undiksha Basketball',
            'location': 'Jl Udayana, Singaraja'
          },
        ];
        break;
      case 'Futsal':
        fieldList = [
          {
            'fileName': 'amerta_futsal.jpg',
            'courtName': 'Amerta Futsal',
            'location': 'Banyuasri, Singaraja'
          },
          {
            'fileName': 'catra_futsal.jpg',
            'courtName': 'Catra Futsal',
            'location': 'Penglatan, Buleleng'
          },
          {
            'fileName': 'sifut_futsal.jpg',
            'courtName': 'Singaraja Futsal',
            'location': 'Jl Udayana, Singaraja'
          },
          {
            'fileName': 'tirta_futsal.jpg',
            'courtName': 'Tirta Futsal',
            'location': 'Seririt, Buleleng'
          },
        ];
        break;
      case 'Tennis':
        fieldList = [
          {
            'fileName': 'amed_tennis.jpg',
            'courtName': 'Amed Tennis',
            'location': 'Banyuning, Singaraja'
          },
          {
            'fileName': 'bintang_tennis.jpg',
            'courtName': 'Bintang Tennis',
            'location': 'Jl Ahmad Yani, Singaraja'
          },
          {
            'fileName': 'dinata_tennis.jpg',
            'courtName': 'Dinata Tennis Court',
            'location': 'Jl Gatot Subroto, Singaraja'
          },
          {
            'fileName': 'handara_tennis.jpg',
            'courtName': 'Handara Tennis',
            'location': 'Gitgit, Buleleng'
          },
          {
            'fileName': 'rans_tennis.jpg',
            'courtName': 'RANS Tennis',
            'location': 'Kubutambahan, Buleleng'
          },
        ];
        break;
    }

    // Filter fieldList based on search query
    List<Map<String, String>> filteredList = fieldList.where((field) {
      return field['courtName']!
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          field['location']!.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    if (filteredList.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text(
            'No fields found.',
            style: TextStyle(
              color: Constants.primaryColor,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          String fileName = filteredList[index]['fileName']!;
          String courtName = filteredList[index]['courtName']!;
          String location = filteredList[index]['location']!;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FieldDetailScreen(
                    fieldDetail: FieldDetail(
                      fileName: fileName,
                      courtName: courtName,
                      location: location,
                      description: '', 
                      price: 0.0, imageFile: '', 
                    ),
                  ),
                ),
              );
            },
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Stack(
                    children: [
                      SizedBox(
                        width: 350,
                        height: 170,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                'assets/images/$fileName',
                                fit: BoxFit.cover,
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Constants.primaryColor,
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                courtName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    location,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                gradient: RadialGradient(colors: [
                  Color.fromARGB(255, 90, 137, 158),
                  Constants.scaffoldBackgroundColor
                ], focal: Alignment.center, radius: 1.0),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 30),
                  child: Container(
                    //container slide banner
                    width: 350,
                    height: 180,
                    decoration: const BoxDecoration(
                      color: Constants.primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Hi, Dwik!",
                            style: TextStyle(
                              color: Constants.scaffoldBackgroundColor,
                            ),
                          ),
                          const Text(
                            "What you would \nlike to do?",
                            style: TextStyle(
                              color: Constants.scaffoldBackgroundColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 10),
                          FlexibleInputWidget(
                            hintText: "Find a field",
                            height: 35,
                            prefixIcon: Icons.search,
                            controller: _searchController,
                            onChanged: _updateSearchQuery,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      color: Constants.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Select activity",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildActivityButton(
                                image: "assets/images/badminton.jpg",
                                label: "Badminton",
                                activity: 'Badminton',
                              ),
                              _buildActivityButton(
                                image: "assets/images/basketball.jpg",
                                label: "Basketball",
                                activity: 'Basketball',
                              ),
                              _buildActivityButton(
                                image: "assets/images/futsal.jpg",
                                label: "Futsal",
                                activity: 'Futsal',
                              ),
                              _buildActivityButton(
                                image: "assets/images/tennis.jpg",
                                label: "Tennis",
                                activity: 'Tennis',
                              ),
                              _buildActivityButton(
                                image: "assets/images/volley.jpg",
                                label: "Volleyball",
                                activity: 'Volleyball',
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _selectedActivity,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const Text("Choose Your Field, Start the Match!"),
                          const SizedBox(height: 10),
                          _buildFieldList(_selectedActivity),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk membangun tombol aktivitas
  Widget _buildActivityButton(
      {required String image,
      required String label,
      required String activity}) {
    bool isSelected = _selectedActivity == activity;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            _selectActivity(activity);
          },
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(image),
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isSelected ? Constants.primaryColor : Colors.transparent,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? Constants.secondaryColor.withOpacity(0.5)
                      : Colors.transparent,
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}