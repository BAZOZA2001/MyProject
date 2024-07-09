import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:calculator/services/connectivity_service.dart';
import 'package:calculator/services/battery_service.dart';
import 'package:calculator/provider/theme_provider.dart';
import 'package:calculator/screens/sign_in_screen.dart';
import 'package:calculator/screens/sign_up_screen.dart';
import 'package:calculator/screens/calculator_screen.dart';
import 'package:calculator/contact_list.dart'; // Adjust path as per your project structure
import 'package:calculator/widgets/profile_drawer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: themeProvider.themeData,
            home: MyHomePage(),
            routes: {
              '/contacts': (context) => ContactListPage(), // Route for contact list screen
            },
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    SignInScreen(),
    SignUpScreen(),
    CalculatorScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ConnectivityService.instance.initialize(context);
      BatteryService.instance.initialize(context);
      
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      drawer: ProfileDrawer(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Sign In',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.app_registration),
            label: 'Sign Up',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Calculator',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var status = await Permission.contacts.request();
          if (status.isGranted) {
            Navigator.pushNamed(context, '/contacts');
          } else {
            // Handle the case when the user denies permission
            // You may want to show a message or navigate somewhere else
            print('Permission denied for contacts');
          }
        },
        tooltip: 'Contacts',
        child: Icon(Icons.contacts),
      ),
    );
  }
}
