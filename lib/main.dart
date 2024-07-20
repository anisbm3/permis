import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp();

  static const appTitle = 'DWS';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
      color:Colors.white,
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
      'Index 0: Accueil',
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
              // Handle profile icon tap
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
                    width: 150, // Définissez la largeur souhaitée
                    height: 75, // Assurez-vous que la hauteur est la même que la largeur
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20), // Le rayon de bordure doit être la moitié de la largeur/hauteur pour un cercle parfait
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
                    // Handle profile icon tap
                  },
                ),
                title: const Text('Accueil',style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                )),
                selected: _selectedIndex == 0,
                onTap: () {
                  _onItemTapped(0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.list),
                  color: Colors.white,
                  onPressed: () {
                    // Handle profile icon tap
                  },
                ),
                title: const Text('Liste des projets',style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                )),
                selected: _selectedIndex == 1,
                onTap: () {
                  _onItemTapped(1);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.view_list),
                  color: Colors.white,
                  onPressed: () {
                    // Handle profile icon tap
                  },
                ),
                title: const Text('Liste des permis',style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                )),
                selected: _selectedIndex == 2,
                onTap: () {
                  _onItemTapped(2);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.calendar_month),
                  color: Colors.white,
                  onPressed: () {
                    // Handle profile icon tap
                  },
                ),
                title: const Text('Calendrier',style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                )),
                selected: _selectedIndex == 3,
                onTap: () {
                  _onItemTapped(3);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.assured_workload),
                  color: Colors.white,
                  onPressed: () {
                    // Handle profile icon tap
                  },
                ),
                title: const Text('Gestion des entreprises',style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                )),
                selected: _selectedIndex == 4,
                onTap: () {
                  _onItemTapped(4);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.settings),
                  color: Colors.white,
                  onPressed: () {
                    // Handle profile icon tap
                  },
                ),
                title: const Text('Configuration',style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                )),
                selected: _selectedIndex == 5,
                onTap: () {
                  _onItemTapped(5);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),

    );
  }
}
