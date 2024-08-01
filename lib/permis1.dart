import 'package:flutter/material.dart';

class Permis1page extends StatefulWidget {
  const Permis1page({Key? key}) : super(key: key);

  @override
  _Permis1pageState createState() => _Permis1pageState();
}

class _Permis1pageState extends State<Permis1page> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _dateController1 = TextEditingController();


  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }
  Future<void> _selectDate1(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController1.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vos Permis', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1b418c),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              color: const Color(0xFFE59900),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            color: const Color(0xFFE59900),
            onPressed: () {
              // Handle profile icon tap
            },
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text("Créer un nouveau Permis"),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  scrollable: true,
                  title: const Text('Login'),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _dateController,
                            decoration: InputDecoration(
                              labelText: 'DateDebut',
                              icon: Icon(Icons.calendar_today),
                            ),
                            readOnly: true,
                            onTap: () => _selectDate(context),
                          ),
                          TextFormField(
                            controller: _dateController1,
                            decoration: InputDecoration(
                              labelText: 'DateFin',
                              icon: Icon(Icons.calendar_today),
                            ),
                            readOnly: true,
                            onTap: () => _selectDate1(context),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Lieu',
                              icon: Icon(Icons.code),
                            ),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Projet',
                              icon: Icon(Icons.work),
                            ),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Status',
                              icon: Icon(Icons.done),
                            ),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Responsable',
                              icon: Icon(Icons.man),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      child: const Text("Submit"),
                      onPressed: () {
                        // your code
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
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
                    Navigator.popAndPushNamed(context, '/home1');
                  },
                ),
                title: const Text('Accueil', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.list),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/projets1');
                  },
                ),
                title: const Text('Liste des projets', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.view_list),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/permis1');
                  },
                ),
                title: const Text('Liste des Permis', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                selected: true,
              ),
              ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.calendar_month),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/cal1');
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
                    Navigator.popAndPushNamed(context, '/ent1');
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
                    Navigator.popAndPushNamed(context, '/conf1');
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
