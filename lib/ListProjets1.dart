import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:pp/permis2.dart';
import 'models/Permis.dart';
import 'models/Projets.dart';
import 'package:path/path.dart' as Path;

class Projet1page extends StatefulWidget {
  const Projet1page({Key? key}) : super(key: key);

  @override
  _Projet1pageState createState() => _Projet1pageState();
}

class _Projet1pageState extends State<Projet1page> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _dateDebutController = TextEditingController();
  final TextEditingController _dateFinController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _responsableController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _lieuController = TextEditingController();
  final TextEditingController _projetController = TextEditingController();


  File? _pickedPdf;
  void _showPermisDialog(BuildContext context, int idprojet) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: const Text('Gérer les Permis'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('ID Projet: $idprojet', style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                ListTile(
                  leading: Icon(Icons.view_list),
                  title: Text('Afficher les permis'),
                  onTap: () {
                    Navigator.of(context).pop();
                   _viewPermis(context, idprojet);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.add),
                  title: Text('Ajouter un permis'),
                  onTap: () {
                    Navigator.of(context).pop();
                  FormPermis(context, idprojet);
                  },
                ),

              ],
            ),
          ),
          actions: [
            ElevatedButton(
              child: const Text("Fermer"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _viewPermis(BuildContext context, int idProjet) async {
    try {
      List<Map<String, dynamic>> permits = await Permis.instance.getPermisByProjectId(idProjet);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Permis2Page(idProjet: idProjet),
        ),
      );
    } catch (e) {
      // Handle the error by showing a snack bar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la récupération des permis: $e')),
      );
    }
  }

  void FormPermis(BuildContext context, int idprojet) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _dateDebutController = TextEditingController();
    final TextEditingController _dateFinController = TextEditingController();
    final TextEditingController _statusController = TextEditingController();
    final TextEditingController _lieuController = TextEditingController();
    final TextEditingController _projetController = TextEditingController(text: idprojet.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: const Text('Créer un nouveau permis'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _dateDebutController,
                    decoration: InputDecoration(
                      labelText: 'Date Début',
                      icon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () => _selectDate(context, _dateDebutController),
                  ),
                  TextFormField(
                    controller: _dateFinController,
                    decoration: InputDecoration(
                      labelText: 'Date Fin',
                      icon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () => _selectDate(context, _dateFinController),
                  ),
                  TextFormField(
                    controller: _statusController,
                    decoration: const InputDecoration(
                      labelText: 'Statut',
                      icon: Icon(Icons.info),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer le statut';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _lieuController,
                    decoration: const InputDecoration(
                      labelText: 'Lieu',
                      icon: Icon(Icons.location_on),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer le lieu';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _projetController,
                    decoration: const InputDecoration(
                      labelText: 'ID Projet',
                      icon: Icon(Icons.work_outlined),
                    ),
                    readOnly: true,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              child: const Text("Soumettre"),
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _addPermis(
                    context,
                    idprojet,
                    _dateDebutController.text,
                    _dateFinController.text,
                    _statusController.text,
                    _lieuController.text,
                  );
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Veuillez remplir le formulaire correctement')),
                  );
                }
              },
            ),
            ElevatedButton(
              child: const Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  void dispose() {
    _codeController.dispose();
    _dateDebutController.dispose();
    _dateFinController.dispose();
    _designationController.dispose();
    _statusController.dispose();
    _responsableController.dispose();
    _descriptionController.dispose();
    _lieuController.dispose();
    _projetController.dispose();
    super.dispose();
  }

  void _deleteProject(int id, BuildContext context) async {
    try {
      await Projets.instance.deleteProjets(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Projet supprimé avec succès!')),
      );
      setState(() {}); // Refresh the UI after deleting the project
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la suppression du projet: $e')),
      );
    }
  }

  void _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _pickedPdf = File(result.files.single.path!);
      });
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }
  void _addPermis(
      BuildContext context,
      int idprojet,
      String dateDebut,
      String dateFin,
      String status,
      String lieu,
      ) async {
    // Add debug prints
    print('ID Projet: $idprojet');
    print('Date Début: $dateDebut');
    print('Date Fin: $dateFin');
    print('Status: $status');
    print('Lieu: $lieu');

    if (dateDebut.isNotEmpty && dateFin.isNotEmpty) {
      try {
        await Permis.instance.insertPermis(
          dateDebut,
          dateFin,
          status,
          lieu,
          idprojet,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permis ajouté avec succès!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'ajout du permis: $e')),
        );
        print('Erreur lors de l\'ajout du permis: $e');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Les dates doivent être valides')),
      );
    }
  }


  void _addProjet(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final code = _codeController.text;
      final dateDebut = _dateDebutController.text;
      final dateFin = _dateFinController.text;
      final designation = _designationController.text;
      final status = _statusController.text;
      final responsable = _responsableController.text;
      final description = _descriptionController.text;
      final lieu = _lieuController.text;
      final pdfPath = _pickedPdf?.path;

      if (dateDebut != null && dateFin != null) {
        try {
          await Projets.instance.insertProjet(
            code,
            dateDebut,
            dateFin,
            designation,
            status,
            responsable,
            description,
            lieu,
            pdfPath ?? '',
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Projet ajouté avec succès!')),
          );
          _formKey.currentState!.reset();
          _pickPdf();
          setState(() {}); // Refresh the UI after adding the project
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur lors de l\'ajout du projet: $e')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Les dates doivent être valides')),
        );
      }
    }
  }

  Future<List<Map<String, dynamic>>> _getAllProjects() async {
    return await Projets.instance.getAllProjects();
  }

  void _editProject(Map<String, dynamic> project, BuildContext context) {
    final _codeController = TextEditingController(text: project['code']);
    final _dateDebutController = TextEditingController(text: (project['datedebut']));
    final _dateFinController = TextEditingController(text: (project['datefin']));
    final _designationController = TextEditingController(text: project['designation']);
    final _statusController = TextEditingController(text: project['status']);
    final _responsableController = TextEditingController(text: project['responsable']);
    final _descriptionController = TextEditingController(text: project['description']);
    final _lieuController = TextEditingController(text: project['lieu']);
    final _pdfPathController = TextEditingController(text: project['pdf']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier le Projet'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView( // Ajout du scroller
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      controller: _codeController,
                      decoration: const InputDecoration(
                        labelText: 'Code',
                      ),
                    ),
                    TextFormField(
                      controller: _dateDebutController,
                      decoration: const InputDecoration(
                        labelText: 'Date Début',
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context, _dateDebutController),
                    ),
                    TextFormField(
                      controller: _dateFinController,
                      decoration: const InputDecoration(
                        labelText: 'Date Fin',
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context, _dateFinController),
                    ),
                    TextFormField(
                      controller: _designationController,
                      decoration: const InputDecoration(
                        labelText: 'Désignation',
                      ),
                    ),
                    TextFormField(
                      controller: _statusController,
                      decoration: const InputDecoration(
                        labelText: 'Statut',
                      ),
                    ),
                    TextFormField(
                      controller: _responsableController,
                      decoration: const InputDecoration(
                        labelText: 'Responsable',
                      ),
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                    TextFormField(
                      controller: _lieuController,
                      decoration: const InputDecoration(
                        labelText: 'Lieu',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final code = _codeController.text;
                        final dateDebut = _dateDebutController.text;
                        final dateFin = _dateFinController.text;
                        final designation = _designationController.text;
                        final status = _statusController.text;
                        final responsable = _responsableController.text;
                        final description = _descriptionController.text;
                        final lieu = _lieuController.text;
                        final pdfPath = _pdfPathController.text;

                        try {
                          await Projets.instance.updateProjet(
                            project['idprojet'],
                            code,
                            dateDebut,
                            dateFin,
                            designation,
                            status,
                            responsable,
                            description,
                            lieu,
                            pdfPath,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Projet mis à jour avec succès!')),
                          );
                          Navigator.of(context).pop(); // Fermer la boîte de dialogue
                          setState(() {}); // Rafraîchir l'interface utilisateur
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erreur lors de la mise à jour du projet: $e')),
                          );
                        }
                      },
                      child: const Text('Mettre à jour'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vos Projets', style: TextStyle(color: Colors.white)),
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
            future: _getAllProjects(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erreur: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Aucun projet trouvé.'));
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final project = snapshot.data![index];
                      return Card(
                        margin: EdgeInsets.all(10),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Code: ${project['code']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                      Text('Date Debut: ${project['datedebut']}', style: TextStyle(fontSize: 16)),
                                      Text('Date Fin: ${project['datefin']}', style: TextStyle(fontSize: 16)),
                                      Text('Designation: ${project['designation']}', style: TextStyle(fontSize: 16)),
                                      Text('Status: ${project['status']}', style: TextStyle(fontSize: 16)),
                                      Text('Responsable: ${project['responsable']}', style: TextStyle(fontSize: 16)),
                                      Text('Description: ${project['description']}', style: TextStyle(fontSize: 16)),
                                      Text('Lieu: ${project['lieu']}', style: TextStyle(fontSize: 16)),
                                      // Text('PDF: ${project['pdf']}', style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () {
                                          print(project);
                                          _editProject(project,context);


                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          _deleteProject(project['idprojet'], context);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.document_scanner, color: Colors.greenAccent),
                                        onPressed: () {
                                          _showPermisDialog(context, project['idprojet']);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
          ElevatedButton(
            child: const Text("Créer un nouveau Projet"),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: true,
                    title: const Text('Créer un nouveau Projet'),
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextFormField(
                              controller: _codeController,
                              decoration: const InputDecoration(
                                labelText: 'Code',
                                icon: Icon(Icons.code),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the code';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _dateDebutController,
                              decoration: InputDecoration(
                                labelText: 'Date Debut',
                                icon: Icon(Icons.calendar_today),
                              ),
                              readOnly: true,
                              onTap: () => _selectDate(context, _dateDebutController),
                            ),
                            TextFormField(
                              controller: _dateFinController,
                              decoration: InputDecoration(
                                labelText: 'Date Fin',
                                icon: Icon(Icons.calendar_today),
                              ),
                              readOnly: true,
                              onTap: () => _selectDate(context, _dateFinController),
                            ),
                            TextFormField(
                              controller: _designationController,
                              decoration: const InputDecoration(
                                labelText: 'Designation',
                                icon: Icon(Icons.design_services),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the designation';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _statusController,
                              decoration: const InputDecoration(
                                labelText: 'Status',
                                icon: Icon(Icons.info),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the status';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _responsableController,
                              decoration: const InputDecoration(
                                labelText: 'Responsable',
                                icon: Icon(Icons.person),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the responsable';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _descriptionController,
                              decoration: const InputDecoration(
                                labelText: 'Description',
                                icon: Icon(Icons.description),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the description';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _lieuController,
                              decoration: const InputDecoration(
                                labelText: 'Lieu',
                                icon: Icon(Icons.location_on),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the location';
                                }
                                return null;
                              },
                            ),
                            ElevatedButton(
                              onPressed: _pickPdf,
                              child: const Text('Choisir un fichier PDF'),
                            ),
                            if (_pickedPdf != null)
                              Text('Fichier sélectionné: ${basename(_pickedPdf!.path)}'),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        child: const Text("Soumettre"),
                        onPressed: () {
                          _addProjet(context);


                          Navigator.of(context).pop();
                        },
                      ),
                      ElevatedButton(
                        child: const Text("Annuler"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
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
                  icon: const Icon(Icons.view_list),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/projets1');
                  },
                ),
                title: const Text('Liste des Projets', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                selected: true,
              ),
              ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.list),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/permis1');
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