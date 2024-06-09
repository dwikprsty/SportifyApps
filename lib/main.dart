import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportify_app/cubit/auth/auth_cubit.dart';
import 'package:sportify_app/cubit/balance/balance_cubit.dart';
import 'package:sportify_app/cubit/counter_cubit.dart';
import 'package:sportify_app/screens/about_page.dart';
import 'package:sportify_app/screens/customer_service/cs_form.dart';
import 'package:sportify_app/screens/customer_service/cs_screen.dart';
import 'package:sportify_app/screens/latihan/datas_screen.dart';
import 'package:sportify_app/screens/form_screen.dart';
import 'package:sportify_app/screens/history_page.dart';
import 'package:sportify_app/screens/home_page.dart';
import 'package:sportify_app/screens/landing_page.dart';
import 'package:sportify_app/screens/login_screen.dart';
import 'package:sportify_app/screens/latihan/latihan_api.dart';
import 'package:sportify_app/screens/latihan/latihan_sqllite.dart';
import 'package:sportify_app/screens/notification_page.dart';
import 'package:sportify_app/screens/profile_page.dart';
import 'package:sportify_app/screens/register_page.dart';
import 'package:sportify_app/screens/routes/BalanceScreen/balance_screen.dart';
import 'package:sportify_app/screens/routes/SpendingScreen/spending_form_screen.dart';
import 'package:sportify_app/screens/routes/SpendingScreen/spending_screen.dart';
import 'package:sportify_app/screens/routes/counter_screen.dart';
import 'package:sportify_app/screens/routes/welcome_screen.dart';
import 'package:sportify_app/screens/setting_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sportify_app/utils/constants.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
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
      providers: [
        BlocProvider<CounterCubit>(create: (context) => CounterCubit()),
        BlocProvider<BalanceCubit>(create: (context) => BalanceCubit()),
        BlocProvider<AuthCubit>(create: (context) => AuthCubit())
      ],
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
    case "/setting":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const SettingPage();
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
    case "/latihan-API":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const LatihanAPI();
      });
    case "/latihan-CRUD":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const LatihanSQLlite();
      });
    case "/datas":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const DataScreen();
      });
    case "/form-screen":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const FormScreen();
      });
    case "/customer-screen":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const CustomerScreen();
      });
    case "/cs-form-screen":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const CSFormScreen();
      });
    // case "/division-screen":
    //   return MaterialPageRoute(builder: (BuildContext context) {
    //     return const CSFormScreen();
    //   });
    case "/counter":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const CounterScreen();
      });
    case "/welcome":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const WelcomeScreen();
      });
    case "/balance":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const BalanceScreen();
      });
    case "/spending":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const SpendingScreen();
      });
    // case "/spending-form":
    //   return MaterialPageRoute(builder: (BuildContext context) {
    //     return const SpendingFormScreen(onSubmi)
    //   });
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

  final List<Widget> _page = [
    const HomePage(),
    const HistoryPage(),
    const SettingPage(),
  ];

  final List<String> _appBarTitles = const ['Sportify', 'History', 'Setting'];

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
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                nextScreen(context, '/profile');
              },
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Constants.primaryColor,
                child: CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage('assets/images/basketball.jpg'),
                ),
              ),
            ),
          ),
        ],
      ),

      //drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/home_bg.png"),
                    fit: BoxFit.cover),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      nextScreen(context, '/profile');
                    },
                    child: const CircleAvatar(
                      radius: 40,
                      backgroundColor: Constants.primaryColor,
                      child: CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/basketball.jpg'),
                        radius: 38,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Dwi Prasetyanti',
                    style: TextStyle(
                        color: Constants.primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
              child: Text("Latihan", style: TextStyle(color:Colors.grey),), 
            ),
            const Divider(),
            ListTile(
              title: const Row(
                children: [
                  Text('Latihan API'),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                  ),
                ],
              ),
              onTap: () {
                nextScreen(context, '/latihan-API');
              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Text('Latihan CRUD'),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                  ),
                ],
              ),
              onTap: () {
                nextScreen(context, '/latihan-CRUD');
              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Text('Latihan Data'),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                  ),
                ],
              ),
              onTap: () {
                nextScreen(context, '/datas');
              },
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 25, 0, 0),
              child: Text('UTS (Customer Service)', style: TextStyle(color: Colors.grey),),
            ),
            const Divider(),
            ListTile(
              title: const Row(
                children: [
                  Text('Customer Service'),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                  ),
                ],
              ),
              onTap: () {
                nextScreen(context, '/customer-screen');
              },
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 25, 0, 0),
              child: Text('Latihan BLoC Cubit', style: TextStyle(color: Colors.grey),),
            ),
            const Divider(),
            ListTile(
              title: const Row(
                children: [
                  Text('Welcome Screen'),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                  ),
                ],
              ),
              onTap: () {
                nextScreen(context, '/welcome');
              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Text('Counter Screen'),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                  ),
                ],
              ),
              onTap: () {
                nextScreen(context, '/counter');
              },
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 25, 0, 0),
              child: Text('Latihan BLoC Cubit', style: TextStyle(color: Colors.grey),),
            ),
            const Divider(),
            ListTile(
              title: const Row(
                children: [
                  Text('Balance Screen'),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                  ),
                ],
              ),
              onTap: () {
                nextScreen(context, '/balance');
              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Text('Spending Screen'),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                  ),
                ],
              ),
              onTap: () {
                nextScreen(context, '/spending');
              },
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 25, 0, 0),
              child: Text('Others', style: TextStyle(color: Colors.grey),),
            ),
            const Divider(),
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
                nextScreen(context, '/');
              },
            ),
          ],
        ),
      ),
      body: _page[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Constants.scaffoldBackgroundColor,
        buttonBackgroundColor: Constants.primaryColor,
        items: const [
          CurvedNavigationBarItem(
            child: Icon(
              Icons.home,
              color: Constants.activeMenu,
            ),
            label: 'Home',
            labelStyle: TextStyle(color: Constants.activeMenu),
          ),
          CurvedNavigationBarItem(
              child: Icon(
                Icons.history,
                color: Constants.activeMenu,
              ),
              label: 'History',
              labelStyle: TextStyle(color: Constants.activeMenu)),
          CurvedNavigationBarItem(
              child: Icon(
                Icons.settings,
                color: Constants.activeMenu,
              ),
              label: 'Setting',
              labelStyle: TextStyle(color: Constants.activeMenu)),
        ],
        onTap: _onItemTapped,
        color: Constants.primaryColor,
      ),
    );
  }
}
