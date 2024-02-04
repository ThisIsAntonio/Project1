import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:chat_app/screens/register_screen.dart';
import 'package:chat_app/screens/main_screen.dart';

// Define the LoginScreen widget
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

// Define the state for LoginScreen
class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  // Variables to store user input
  String _email = '';
  String _password = '';

  // Function to handle user login
  void _login() async {
    var url = Uri.parse(
        'https://serverchat2.onrender.com/login'); // Adjust the URL for your environment //localhost is 100.20.92.101:300
    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': _email,
          'password': _password,
        }),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        // Login successful
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Login successful')));

        var data = jsonDecode(response.body);
        String userEmail = data['email'];

        // Navigate to the MainScreen
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => MainScreen(userEmail: userEmail)));
      } else {
        // Login failed
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Failed to login. Please check your email and password.')));
      }
    } catch (e) {
      // Handle errors in sending the request or receiving the response
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error connecting to the server')));
    }
  }

  // Function to submit the login form
  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      _login();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize
              .min, // Asegura que el Row ocupe el mínimo espacio necesario
          children: [
            Image.asset(
              'lib/img/logo.png', // Asegúrate de que la ruta de la imagen sea correcta
              fit: BoxFit.contain,
              height: 20.0, // Ajusta la altura según necesites
            ),
            const SizedBox(width: 8.0), // Espacio entre el logo y el texto
            const Text('SocioLingo Chat - Log In'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircleAvatar(
                radius: 60, // Adjust the size to your liking
                backgroundColor: Colors.transparent, // Transparent background
                child: ClipOval(
                  child: Image.asset('lib/img/logo.png', // rute of your image
                      fit: BoxFit.cover, // Cover the space of the circle
                      width: 120, // Adjust the width
                      height: 120), //Adjust the height
                ),
              ),
              const SizedBox(height: 20),
              // Field TextFormField for Email and Password
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => _email = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email address.';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onSaved: (value) => _password = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 5) {
                    return 'Password must be at least 5 characters long.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Log In'),
              ),
              TextButton(
                onPressed: () {
                  // Navega a RegisterScreen cuando se presione el botón
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RegisterScreen()));
                },
                child: const Text(
                    'Register'), // Texto del botón para navegar a la pantalla de registro
              ),
            ],
          ),
        ),
      ),
    );
  }
}
