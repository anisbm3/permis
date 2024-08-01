import 'package:flutter/material.dart';
import 'package:pp/Calendar.dart';
import 'package:pp/Calendar1.dart';
import 'package:pp/Entreprise.dart';
import 'package:pp/Entreprise1.dart';
import 'package:pp/ListProjets.dart';
import 'package:pp/ListProjets1.dart';
import 'package:pp/conf1.dart';
import 'package:pp/home.dart';
import 'package:pp/permis.dart';
import 'package:pp/login.dart';
import 'package:pp/permis1.dart';
import 'package:pp/signup.dart';

import 'conf.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp();

  static const appTitle = 'DWS';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primaryColor: const Color(0xFF1b418c),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: appTitle),
        '/home': (context) => const MyHomePage(title: appTitle),
        '/conf': (context) => const ConfPage(),
        '/conf1': (context) => const Conf1Page(),
        '/projets': (context) => const Projetpage(),
        '/projets1': (context) =>  Projet1page(),
        '/permis': (context) => const Permispage(),
        '/permis1': (context) => const Permis1page(),
        '/cal': (context) => const Calpage(),
        '/cal1': (context) =>  Cal1page(),
        '/ent': (context) => const Entreprisepage(),
        '/ent1': (context) =>  Entreprise1page(),
        '/login' : (context) => const LoginPage(),
        '/signup' : (context) => const SignUpPage(),
        '/home1'   :(context) =>const Home1page()
      },
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Accueil',
      style: optionStyle,
    ),
    Text(
      'Index 1: Liste des projets',
      style: optionStyle,
    ),
    Text(
      'Index 2: Liste des permis',
      style: optionStyle,
    ),
    Text(
      'Index 3: Calendrier',
      style: optionStyle,
    ),
    Text(
      'Index 4: Gestion des entreprises',
      style: optionStyle,
    ),
    Text(
      'Index 5: Configuration',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1b418c),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
                color: Color(0xFFE59900),

              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            color: Color(0xFFE59900),
            onPressed: () {
              Navigator.popAndPushNamed(context, '/login');
            },
          ),
        ],
      ),

      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1b418c),
                Color(0xFF071226),
              ],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Row(
                children: [
                  Container(
                    width: 150,
                    height: 75,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
                    ),
                  ),
                ],
              ),

              ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.home),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/home');
                  },
                ),
                title: const Text('Accueil', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                selected: true,
              ),
              ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.list),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/projets');
                  },
                ),
                title: const Text('Liste des Projets', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                selected: true,
              ),
              ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.view_list),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/permis');
                  },
                ),
                title: const Text('Liste des permis', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                selected: true,
              ),
              ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.calendar_month),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/cal');
                  },
                ),
                title: const Text('Calendrier', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                selected: true,
              ),
              ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.assured_workload),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/ent');
                  },
                ),
                title: const Text('Gestion des entreprises', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                selected: true,
              ),
              ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.settings),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/conf');
                  },
                ),
                title: const Text('Configuration', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                selected: true,
              ),
            ],
          ),
        ),
      ),

    );
  }

}
