import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'models/Projets.dart';

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
  File? _pickedPdf;

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
    super.dispose();
  }

  void _deleteProject(int id,BuildContext context) async {
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

  void _addProjet(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final code = _codeController.text;
      final dateDebut = DateTime.tryParse(_dateDebutController.text);
      final dateFin = DateTime.tryParse(_dateFinController.text);
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

  void _editProject(Map<String, dynamic> project) {
    // Implement edit functionality here
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
                                          _editProject(project);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          _deleteProject(project['idprojet'],context);
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
