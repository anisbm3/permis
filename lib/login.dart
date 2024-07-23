import 'package:flutter/material.dart';



class Loginpage extends StatelessWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    const appTitle = 'Form Validation Demo';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
          'Login Page',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF1b418c),
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.refresh),
                color: Color(0xFFE59900),

                onPressed: () {
                  Navigator.popAndPushNamed(context, '/');
                },
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle),
              color: Color(0xFFE59900),
              onPressed: () {
                Navigator.popAndPushNamed(context, '/home');
              },
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/flask1.jpg"),
                  fit: BoxFit.cover,

                  alignment: Alignment.center,
                ),
              ),
            ),
            MyCustomForm(),
          ],
        ),      ),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}


class MyCustomFormState extends State<MyCustomForm> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFE59900),
      foregroundColor:Color(0xFF1b418c) ,  // Text color
      minimumSize: Size(double.infinity, 40), // Full width button
      padding: EdgeInsets.only(left: 40, right: 40, top: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30), // Rounded corners
      ),
    );
    return Form(
      key: _formKey,
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(

            padding: EdgeInsets.only(left: 35, right: 35, top: 140),

            child: Text(
              'Votre Email:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,color: Colors.white
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 35, right: 35, top: 10),
            child: TextField(

              decoration: InputDecoration(
                filled: true,

                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                prefixIcon: Icon(Icons.mail),
                hintText: 'Entrez votre email',
              ),
            ),
          )
,
          Padding(
            padding: EdgeInsets.only(left: 35, right: 35, top: 10),
            child: Text(
              'Votre Mot de Passe:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,color: Colors.white
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 35, right: 35, top: 10),
            child: TextField(
              decoration: InputDecoration(
                filled: true,

                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                prefixIcon: Icon(Icons.lock),
                suffixIcon: Icon(Icons.remove_red_eye) ,
                hintText: 'Entrer votre  mot de passe',
              ),
            ),
          ),
          SizedBox(height: 20), // Add space between the last TextField and the button
          Padding(
            padding: EdgeInsets.only(left: 120, right: 60, top: 50),
            child: ElevatedButton(
              style: style,
              onPressed: () {},
              child: const Text('Se connecter'),
            ),
          ),
        ],

      ),

    );
  }
}