import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sportify_app/cubit/auth/auth_cubit.dart';
import 'package:sportify_app/endpoints/endpoints.dart';
import 'package:sportify_app/screens/about_page.dart';
import 'package:sportify_app/screens/admin/create_field.dart';
import 'package:sportify_app/screens/history_page.dart';
import 'package:sportify_app/screens/home_page.dart';
import 'package:sportify_app/screens/landing_page.dart';
import 'package:sportify_app/screens/login_screen.dart';
import 'package:sportify_app/screens/notification_page.dart';
import 'package:sportify_app/screens/profile_page.dart';
import 'package:sportify_app/screens/register_page.dart';
import 'package:sportify_app/services/data_service.dart';
import 'package:sportify_app/utils/constants.dart';
import 'package:sportify_app/utils/helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<AuthCubit>(create: (context) => AuthCubit())],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            title: 'Sportify App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: Constants.scaffoldBackgroundColor,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              textTheme: GoogleFonts.montserratTextTheme(),
            ),
            initialRoute: "/landing",
            onGenerateRoute: _onGenerateRoute,
            routes: {
              '/home': (context) =>
                  MainScreen(title: 'Sportify', scaffoldKey: scaffoldKey),
            },
          );
        },
      ),
    );
  }
}

Route<dynamic> _onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case "/":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const LandingPage();
      });
    case "/login":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const LoginPage();
      });
    case "/register":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const RegisterPage();
      });
    case "/home":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const HomePage();
      });
    case "/history":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const HistoryPage();
      });
    case "/profile":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const ProfilePage();
      });
    case "/about":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const AboutPage();
      });
    case "/notification":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const NotificationPage();
      });
    default:
      return MaterialPageRoute(builder: (BuildContext context) {
        return const LandingPage();
      });
  }
}

class MainScreen extends StatefulWidget {
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const MainScreen({super.key, required this.title, required this.scaffoldKey});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<Widget> _pages = [];
  List<String> _appBarTitles = [];

  @override
  void initState() {
    super.initState();
    final isAdmin = context.read<AuthCubit>().state.dataUser!.isAdmin;
    if (isAdmin) {
      _pages = [
        const HomePage(),
        const HistoryPage(),
        const CreateFieldScreen(),
      ];
      _appBarTitles = ['Sportify', 'History', 'Add Field'];
    } else {
      _pages = [
        const HomePage(),
        const HistoryPage(),
        const ProfilePage(),
      ];
      _appBarTitles = ['Sportify', 'History', 'Profile'];
    }

    if (_selectedIndex >= _pages.length) {
      _selectedIndex = 0;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[_selectedIndex]),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              size: 38,
              color: Colors.black87,
            ),
            onPressed: () {
              nextScreen(context, '/notification');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                  gradient: RadialGradient(colors: [
                Color.fromARGB(255, 90, 137, 158),
                Constants.scaffoldBackgroundColor
              ], focal: Alignment.center, radius: 1.0)),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (!context.read<AuthCubit>().state.dataUser!.isAdmin) {
                        nextScreen(context, '/profile');
                      }
                    },
                    child: ClipOval(
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/avatar.png',
                        image:
                            '${Endpoints.showImage}/${context.read<AuthCubit>().state.dataUser!.fotoProfil}',
                        fit: BoxFit.cover,
                        placeholderErrorBuilder: (context, error, stackTrace) {
                          debugPrint('Error loading image: $error');
                          return Image.asset(
                            'assets/images/avatar_loading.png',
                            fit: BoxFit.cover,
                            width: 70,
                            height: 70,
                          );
                        },
                        imageErrorBuilder: (context, error, stackTrace) {
                          debugPrint('Error: $error');
                          return Image.asset(
                            'assets/images/avatar_error.png',
                            fit: BoxFit.cover,
                            width: 70,
                            height: 70,
                          );
                        },
                        fadeOutDuration: const Duration(seconds: 60),
                        width: 70,
                        height: 70,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    context.read<AuthCubit>().state.dataUser?.nickname ??
                        "User",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '@${context.read<AuthCubit>().state.dataUser?.namaPengguna ?? " "}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.info),
                  SizedBox(width: 5),
                  Text('About Apps'),
                ],
              ),
              onTap: () {
                nextScreen(context, '/about');
              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.logout),
                  SizedBox(width: 5),
                  Text('Logout'),
                ],
              ),
              onTap: () {
                context.read<AuthCubit>().logout();
                DataService.logoutData();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Constants.scaffoldBackgroundColor,
        buttonBackgroundColor: Constants.primaryColor,
        items: [
          const CurvedNavigationBarItem(
            child: Icon(
              Icons.home,
              color: Constants.activeMenu,
            ),
            label: 'Home',
            labelStyle: TextStyle(color: Constants.activeMenu),
          ),
          const CurvedNavigationBarItem(
            child: Icon(
              Icons.history,
              color: Constants.activeMenu,
            ),
            label: 'History',
            labelStyle: TextStyle(color: Constants.activeMenu),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              context.read<AuthCubit>().state.dataUser!.isAdmin
                  ? Icons.add
                  : Icons.person,
              color: Constants.activeMenu,
            ),
            label: context.read<AuthCubit>().state.dataUser!.isAdmin
                ? 'Add Field'
                : 'Profile',
            labelStyle: const TextStyle(color: Constants.activeMenu),
          ),
        ],
        onTap: _onItemTapped,
        color: Constants.primaryColor,
      ),
    );
  }
}
