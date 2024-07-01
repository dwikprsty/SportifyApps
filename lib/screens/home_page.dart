import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportify_app/cubit/auth/auth_cubit.dart';
import 'package:sportify_app/dto/fields.dart';
import 'package:sportify_app/endpoints/endpoints.dart';
import 'package:sportify_app/screens/field_detail_screen.dart';
import 'package:sportify_app/services/data_service.dart';
import 'package:sportify_app/utils/constants.dart';
import 'package:sportify_app/widgets/search_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedActivity = 'Badminton';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _currentPage = 1;
  final int _pageSize = 5;
  final List<FieldDetail> _fields = [];
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _loadFields();
  }

  void _fetchUserData() {
    final user = context.read<AuthCubit>().state.dataUser;
    if (user != null) {
      user.nickname;
    }
  }

  void _selectActivity(String activity) {
    setState(() {
      _selectedActivity = activity;
      _searchQuery = '';
      _searchController.clear();
      _fields.clear();
      _currentPage = 1;
      _loadFields();
    });
  }

  void _updateSearchQuery(String? query) {
    setState(() {
      _searchQuery = query ?? '';
      _fields.clear();
      _currentPage = 1;
      _loadFields();
    });
    if (kDebugMode) {
      print('Search query updated: $_searchQuery');
    }
  }

  Future<void> _loadFields() async {
  if (_isLoadingMore) return;

  setState(() {
    _isLoadingMore = true;
  });

  try {
    List<FieldDetail> newFields = await DataService.fetchFields(_currentPage, _pageSize);
    if (!mounted) return; // Tambahkan pengecekan ini
    setState(() {
      _fields.addAll(newFields);
      _currentPage++;
    });
  } catch (e) {
    if (kDebugMode) {
      print('Error loading fields: $e');
    }
  } finally {
    if (!mounted) return; // Tambahkan pengecekan ini
    setState(() {
      _isLoadingMore = false;
    });
  }
}


  Widget _buildFieldList(String sport) {
    List<FieldDetail> filteredList = _fields
        .where((field) =>
            field.jenisLapangan == sport &&
            (field.courtName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             field.location.toLowerCase().contains(_searchQuery.toLowerCase())))
        .toList();

    return Expanded(
      child: filteredList.isEmpty
          ? const Center(
              child: Text(
                'No results found',
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: filteredList.length + 1,
              itemBuilder: (context, index) {
                if (index == filteredList.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: _loadFields,
                        child: _isLoadingMore
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Load More'),
                      ),
                    ),
                  );
                }

                FieldDetail field = filteredList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FieldDetailScreen(
                          fieldDetail: field,
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
                                    FadeInImage.assetNetwork(
                                      placeholder: 'assets/images/loading_image.png',
                                      image: '${Endpoints.showImage}/${field.gambarLapangan}',
                                      fit: BoxFit.cover,
                                      placeholderErrorBuilder: (context, error, stackTrace) {
                                        debugPrint('Error loading image: $error');
                                        return Image.asset(
                                          'assets/images/failed_placeholder.png',
                                          fit: BoxFit.cover,
                                        );
                                      },
                                      imageErrorBuilder: (context, error, stackTrace) {
                                        debugPrint('Error: $error');
                                        return Image.asset(
                                          'assets/images/failed_image.png',
                                          fit: BoxFit.cover,
                                        );
                                      },
                                      fadeOutDuration: const Duration(seconds: 30),
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
                                      field.courtName,
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
                                          field.location,
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
                  padding: const EdgeInsets.fromLTRB(20, 20, 10, 30),
                  child: Stack(
                    children: [
                      Container(
                        width: 350,
                        height: 180,
                        decoration: const BoxDecoration(
                          color: Constants.primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          image: DecorationImage(
                            image: AssetImage("assets/images/home_bg.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        width: 350,
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color.fromARGB(255, 1, 42, 58).withOpacity(0.8),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 30, 20, 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BlocBuilder<AuthCubit, AuthState>(
                              builder: (context, state) {
                                return Text(
                                  'Hi, ${state.dataUser?.nickname ?? ""}',
                                  style: const TextStyle(
                                    color: Constants.scaffoldBackgroundColor,
                                  ),
                                );
                              },
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
                            SearchWidget(
                              hintText: "Find a field",
                              height: 35,
                              controller: _searchController,
                              onChanged: _updateSearchQuery,
                            ),
                          ],
                        ),
                      ),
                    ],
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

  Widget _buildActivityButton({
    required String image,
    required String label,
    required String activity,
  }) {
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
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
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