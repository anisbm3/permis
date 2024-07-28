import 'package:flutter/material.dart';
import 'database_helper.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Login Page';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appTitle,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1b418c),
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
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/signup');
          },
          child: Text('Créer un compte', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez entrer votre email et mot de passe.')),
      );
      return;
    }

    final user = await DatabaseHelper().getUser(email);
    if (user != null && user['password'] == password) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connexion réussie !')),
      );
      Navigator.pushReplacementNamed(context, '/home1');  // Navigate to home1
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email ou mot de passe incorrect.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFE59900),
      foregroundColor: Color(0xFF1b418c), // Text color
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
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 35, right: 35, top: 10),
            child: TextField(
              controller: _emailController,
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
          ),
          Padding(
            padding: EdgeInsets.only(left: 35, right: 35, top: 10),
            child: Text(
              'Votre Mot de Passe:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 35, right: 35, top: 10),
            child: TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                prefixIcon: Icon(Icons.lock),
                suffixIcon: Icon(Icons.remove_red_eye),
                hintText: 'Entrer votre mot de passe',
              ),
              obscureText: true,
            ),
          ),
          SizedBox(height: 20), // Add space between the last TextField and the button
          Padding(
            padding: EdgeInsets.only(left: 120, right: 60, top: 50),
            child: ElevatedButton(
              style: style,
              onPressed: _login,
              child: const Text('Se connecter'),
            ),
          ),
        ],
      ),
    );
  }
}
