import 'package:flutter/material.dart';
import 'package:pp/models/Permis.dart';

class Permis2Page extends StatefulWidget {
  final int idProjet;

  Permis2Page({required this.idProjet});

  @override
  _Permis2PageState createState() => _Permis2PageState();
}

class _Permis2PageState extends State<Permis2Page> {
  List<Map<String, dynamic>> permits = [];

  @override
  void initState() {
    super.initState();
    _loadPermits();
  }

  void _loadPermits() async {
    final permits = await Permis.instance.getPermisByProjectId(widget.idProjet);
    setState(() {
      this.permits = permits;
    });
  }

  void _deletePermis(int id) async {
    try {
      await Permis.instance.deletePermis(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permis supprimé avec succès!')),
      );
      _loadPermits(); // Refresh the UI after deleting the permit
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la suppression du permis: $e')),
      );
    }
  }
  void _editPermis(BuildContext context, Map<String, dynamic> permis) {
    TextEditingController debutController = TextEditingController(text: permis['datedebut']);
    TextEditingController finController = TextEditingController(text: permis['datefin']);
    TextEditingController statusController = TextEditingController(text: permis['status']);
    TextEditingController lieuController = TextEditingController(text: permis['lieu']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifier Permis'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: debutController,
                decoration: InputDecoration(labelText: 'Date Début'),
              ),
              TextField(
                controller: finController,
                decoration: InputDecoration(labelText: 'Date Fin'),
              ),
              TextField(
                controller: statusController,
                decoration: InputDecoration(labelText: 'Statut'),
              ),
              TextField(
                controller: lieuController,
                decoration: InputDecoration(labelText: 'Lieu'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                // Print data from controllers
                print('Date Début: ${debutController.text}');
                print('Date Fin: ${finController.text}');
                print('Statut: ${statusController.text}');
                print('Lieu: ${lieuController.text}');

                // Update the permit in the database
                await Permis.instance.updatePermis(
                  permis['idpermis'],
                  debutController.text,
                  finController.text,
                  statusController.text,
                  lieuController.text,
                  widget.idProjet,
                );

                Navigator.of(context).pop(); // Close the dialog
                _loadPermits(); // Refresh the list of permits
              },
              child: Text('Sauvegarder'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1b418c),
        title: Text('Permis pour le projet ID ${widget.idProjet}'),
      ),
      body: permits.isEmpty
          ? Center(child: Text('Aucun permis trouvé pour ce projet.'))
          : ListView.builder(
        itemCount: permits.length,
        itemBuilder: (BuildContext context, int index) {
          final permis = permits[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text('Permis ID: ${permis['idpermis']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date Début: ${permis['datedebut']}'),
                  Text('Date Fin: ${permis['datefin']}'),
                  Text('Statut: ${permis['status']}'),
                  Text('Lieu: ${permis['lieu']}'),
                ],
              ),
              isThreeLine: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      _editPermis(context,permis)                  ;
                      },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deletePermis(permis['idpermis']);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
