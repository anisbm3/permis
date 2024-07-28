import 'package:flutter/material.dart';
import 'database_helper.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Sign Up Page';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            appTitle,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF1b418c),
          // leading property removed
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
            MySignUpForm(),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FloatingActionButton(
                  backgroundColor: Color(0xFFE59900),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MySignUpForm extends StatefulWidget {
  const MySignUpForm({super.key});

  @override
  MySignUpFormState createState() {
    return MySignUpFormState();
  }
}

class MySignUpFormState extends State<MySignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signUp() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez entrer votre email et mot de passe.')),
      );
      return;
    }

    final user = await DatabaseHelper().getUser(email);
    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cet email est déjà utilisé.')),
      );
    } else {
      await DatabaseHelper().insertUser(email, password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Inscription réussie !')),
      );
      Navigator.pushReplacementNamed(context, '/login');
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
              onPressed: _signUp,
              child: const Text('S\'inscrire'),
            ),
          ),
        ],
      ),
    );
  }
}
