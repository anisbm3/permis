import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'models/Entreprises.dart';

class Entreprise1page extends StatefulWidget {
  const Entreprise1page({Key? key}) : super(key: key);

  @override
  _Entreprise1pageState createState() => _Entreprise1pageState();
}

class _Entreprise1pageState extends State<Entreprise1page> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _raisonSocialeController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _utilisateurController = TextEditingController();

  @override
  void dispose() {
    _nomController.dispose();
    _raisonSocialeController.dispose();
    _adresseController.dispose();
    _telephoneController.dispose();
    _utilisateurController.dispose();
    super.dispose();
  }

  void _addEntreprise() async {
    if (_formKey.currentState!.validate()) {
      final nom = _nomController.text;
      final raisonSociale = _raisonSocialeController.text;
      final adresse = _adresseController.text;
      final telephone = _telephoneController.text;
      final utilisateur = int.tryParse(_utilisateurController.text);

      if (utilisateur != null) {
        try {
          await Entreprise.instance.insertEntreprise(nom, raisonSociale, adresse, telephone, utilisateur);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Entreprise ajoutée avec succès!')),
          );
          _formKey.currentState!.reset();
          setState(() {}); // Refresh the UI after adding the company
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur lors de l\'ajout de l\'entreprise: $e')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Utilisateur doit être un ID valide')),
        );
      }
    }
  }

  Future<List<Map<String, dynamic>>> _getAllCompanies() async {
    return await Entreprise.instance.getAllCompanies();
  }

  Future<String> _getUserEmail(int userId) async {
    final user = await DatabaseHelper.instance.getUserById(userId);
    return user?['email'] ?? 'No email available';
  }

  void _editCompany(Map<String, dynamic> company) {
    final _nomController = TextEditingController(text: company['nom']);
    final _raisonSocialeController = TextEditingController(text: company['raisonsocial']);
    final _adresseController = TextEditingController(text: company['adress']);
    final _telephoneController = TextEditingController(text: company['tel']);
    final _utilisateurController = TextEditingController(text: company['iduser'].toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier l\'entreprise'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: _nomController,
                    decoration: const InputDecoration(
                      labelText: 'Nom',
                    ),
                  ),
                  TextFormField(
                    controller: _raisonSocialeController,
                    decoration: const InputDecoration(
                      labelText: 'Raison Sociale',
                    ),
                  ),
                  TextFormField(
                    controller: _adresseController,
                    decoration: const InputDecoration(
                      labelText: 'Adresse',
                    ),
                  ),
                  TextFormField(
                    controller: _telephoneController,
                    decoration: const InputDecoration(
                      labelText: 'Téléphone',
                    ),
                  ),
                  TextFormField(
                    controller: _utilisateurController,
                    decoration: const InputDecoration(
                      labelText: 'ID Utilisateur',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final nom = _nomController.text;
                      final raisonSocial = _raisonSocialeController.text;
                      final adresse = _adresseController.text;
                      final telephone = _telephoneController.text;
                      final utilisateur = int.tryParse(_utilisateurController.text);

                      if (utilisateur != null) {
                        try {
                          await Entreprise.instance.updateEntreprise(
                            company['identreprise'], // Assuming this is the ID of the company
                            nom,
                            raisonSocial,
                            adresse,
                            telephone,
                            utilisateur,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Entreprise mise à jour avec succès!')),
                          );
                          Navigator.of(context).pop(); // Close the dialog
                          setState(() {}); // Refresh the UI
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erreur lors de la mise à jour de l\'entreprise: $e')),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('ID Utilisateur doit être un nombre valide')),
                        );
                      }
                    },
                    child: const Text('Mettre à jour'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _deleteCompany(int id) async {
    try {
      await Entreprise.instance.deleteEntreprise(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entreprise supprimée avec succès!')),
      );
      setState(() {}); // Refresh the UI after deleting the company
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la suppression de l\'entreprise: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vos Entreprises', style: TextStyle(color: Colors.white)),
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _getAllCompanies(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erreur: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Aucune entreprise disponible.'));
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final company = snapshot.data![index];
                      return FutureBuilder<String>(
                        future: _getUserEmail(company['iduser']),
                        builder: (context, emailSnapshot) {
                          if (emailSnapshot.connectionState == ConnectionState.waiting) {
                            return Card(
                              margin: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text('Chargement de l\'email...'),
                              ),
                            );
                          } else if (emailSnapshot.hasError) {
                            return Card(
                              margin: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text('Erreur de chargement de l\'email'),
                              ),
                            );
                          } else {
                            return Card(
                              margin: const EdgeInsets.all(8.0),
                              elevation: 4.0,
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16.0),
                                title: Text(company['nom']),
                                subtitle: Text(
                                  'Nom: ${company['nom']}\n'
                                      'Raison Sociale: ${company['raisonsocial']}\n'
                                      'Adresse: ${company['adress']}\n'
                                      'Téléphone: ${company['tel']}\n'
                                      'Email utilisateur: ${emailSnapshot.data}',
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color:Colors.blue),
                                      onPressed: () {
                                        _editCompany(company);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color:Colors.red),
                                      onPressed: () {
                                        _deleteCompany(company['identreprise']);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                );
              }
            },
          ),
          Center(
            child: ElevatedButton(
              child: const Text("Créer une nouvelle entreprise"),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      scrollable: true,
                      title: const Text('Ajouter une entreprise'),
                      content: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: _nomController,
                                decoration: const InputDecoration(
                                  labelText: 'Nom',
                                  icon: Icon(Icons.text_fields),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer un nom';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _raisonSocialeController,
                                decoration: const InputDecoration(
                                  labelText: 'Raison Sociale',
                                  icon: Icon(Icons.business),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer une raison sociale';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _adresseController,
                                decoration: const InputDecoration(
                                  labelText: 'Adresse',
                                  icon: Icon(Icons.location_on),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer une adresse';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _telephoneController,
                                decoration: const InputDecoration(
                                  labelText: 'Téléphone',
                                  icon: Icon(Icons.phone),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer un numéro de téléphone';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _utilisateurController,
                                decoration: const InputDecoration(
                                  labelText: 'ID Utilisateur',
                                  icon: Icon(Icons.person),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty || int.tryParse(value) == null) {
                                    return 'Veuillez entrer un ID utilisateur valide';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          child: const Text("Ajouter"),
                          onPressed: _addEntreprise,
                        )
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
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
