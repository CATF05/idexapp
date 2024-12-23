import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/screens/comptable/account_screen.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false; // Variable pour l'indicateur de chargement

  // Fonction de connexion sans authentification Firebase
  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true; // Afficher l'indicateur de chargement
      });

      try {
        // Vous pouvez commenter cette partie si vous ne souhaitez pas utiliser Firebase Auth
        /*
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Récupérer l'ID Token
        String idToken = await userCredential.user?.getIdToken() ?? '';
        print("ID Token: $idToken");

        if (idToken.isNotEmpty) {
          // Vous pouvez décommenter cette partie si vous souhaitez faire une requête à votre API
          final url = Uri.parse('http://localhost:5001/addUser'); // Remplacer par votre URL d'API

          final response = await http.post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $idToken', // Ajouter le token dans l'en-tête
            },
            body: json.encode({
              'email': emailController.text,
              'password': passwordController.text,
            }),
          );

          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            print("Réponse API: ${data}");
          } else {
            print('Échec de la connexion à l\'API : ${response.statusCode}');
          }
        }
        */

        // Même si aucune authentification n'est effectuée, vous redirigez l'utilisateur
        // vers la page AccountantScreen après un "login" sans vérification
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AccountantScreen()),
        );
      } catch (e) {
        print('Erreur lors de la connexion : $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la connexion : $e'))
        );
      } finally {
        setState(() {
          isLoading = false; // Cacher l'indicateur de chargement
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.school, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'CATF05',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4A90E2), Color(0xFF004080)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(seconds: 1),
                    child: Text(
                      'Veuillez vous connecter',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 28,
                            color: Colors.white,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 50),

                  // Champ Email avec animation et icône
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              BorderSide(color: Colors.white.withOpacity(0.5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                              color: Colors.blueAccent, width: 2),
                        ),
                        prefixIcon:
                            const Icon(Icons.email, color: Colors.white),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Veuillez entrer un email valide';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Champ Mot de Passe avec animation et icône
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        labelStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              BorderSide(color: Colors.white.withOpacity(0.5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                              color: Colors.blueAccent, width: 2),
                        ),
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un mot de passe';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Bouton Connexion avec animation de survol
                  ElevatedButton(
                    onPressed: isLoading ? null : _login,
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blueAccent),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      elevation: MaterialStateProperty.all(5),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            'Se Connecter',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
