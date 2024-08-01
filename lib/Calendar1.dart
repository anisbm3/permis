import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';


/// The app which hosts the home page which contains the calendar on it.
class Cal1page extends StatefulWidget {
  const Cal1page({Key? key}) : super(key: key);


  @override
  // ignore: library_private_types_in_public_api
  _Cal1pageState createState() => _Cal1pageState();

}
class _Cal1pageState extends State<Cal1page> {
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
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: SfCalendar(
          view: CalendarView.month,
          todayHighlightColor: const Color(0xFF1b418c),
          headerStyle: const CalendarHeaderStyle(
            textAlign: TextAlign.center,
            backgroundColor: const Color(0xFF1b418c),
            textStyle: TextStyle(
              color: const Color(0xFFE59900),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          viewHeaderStyle: const ViewHeaderStyle(
            dayTextStyle: TextStyle(
              color: const Color(0xFFE59900),
              fontWeight: FontWeight.bold,
            ),
          ),
          monthViewSettings: const MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            showAgenda: true,
            agendaStyle: AgendaStyle(
              backgroundColor: Colors.white,
              appointmentTextStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              dateTextStyle: TextStyle(
                color: const Color(0xFFE59900),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              dayTextStyle: TextStyle(
                color: const Color(0xFFE59900),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
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
