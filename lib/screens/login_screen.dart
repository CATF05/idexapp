import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/firebase/controlers/auth_controler.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/screens/DE/de_screen.dart';
import 'package:frontend/screens/DG/dg_screen.dart';
import 'package:frontend/screens/comptable/account_screen.dart';
import 'package:frontend/screens/secretaire/secretaire.dart';
import 'package:frontend/screens/surveillant/surveillant_screen.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/widgets/button.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController role = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false; // Variable pour l'indicateur de chargement
  bool passwordVisibility = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Fonction de connexion sans authentification Firebase
  void _signIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = emailController.text;
      final password = passwordController.text;

      try {
        // Authentification avec Firebase Auth
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Vérification dans Firestore si l'utilisateur existe
        final adminsCollection = FirebaseFirestore.instance.collection('admins');
        final querySnapshot = await adminsCollection.where('email', isEqualTo: email).get();

        if (querySnapshot.docs.isNotEmpty) {
          // Utilisateur trouvé
          UserModel userM = UserModel.fromMap(querySnapshot.docs.first.data()); 
          // UserModel userM = await ref.watch(authControllerProvider.notifier)
          //   .getUserData(userCredential.user!.uid).first;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                switch (userM.role) {
                  case "Directeur Général":
                      return DGScreen();
                  case "Comptable":
                    return AccountantScreen();
                  case "Directeur des Etudes":
                    return DirecteurEtudesScreen();
                  case "Sécrétaire":
                    return SecretaryScreen();
                  default:
                    return SurveillantGeneralScreen();
                }
              }
            ),
          );
        }  else {
          // Si l'utilisateur n'existe pas dans Firestore, déconnecter l'utilisateur
          await FirebaseAuth.instance.signOut();
          _showErrorDialog('Utilisateur non trouvé dans la base de données.');
        }
      } catch (e) {
        // Gérer les erreurs d'authentification
        _showErrorDialog('Échec de la connexion: $e');
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Veuillez entrer votre email';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) return 'Email invalide';
    return null;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erreur'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  _showPicker() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(5.0))),
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
                  child: Text(
                    "Rôles",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ),
                for(var r in Constants.admins)
                  ListTile(
                      leading: const Icon(
                        CupertinoIcons.person_alt_circle,
                        color: Colors.black,
                      ),
                      title: Text(
                        r,
                        style:
                            const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        role.text = r;
                        setState(() {});
                        Navigator.pop(context);
                      }),
              ],
            ),
          );
        }
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // title: const Row(
        //   children: [
        //     Icon(Icons.school, color: Colors.white),
        //     SizedBox(width: 8),
        //     Text(
        //       'IDEX2025',
        //       style: TextStyle(
        //         fontSize: 24,
        //         fontWeight: FontWeight.bold,
        //         color: Colors.white,
        //       ),
        //     ),
        //   ],
        // ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4A90E2), canvasColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.school, color: Colors.white, size: 34),
                    SizedBox(width: 12),
                    Text(
                      'IDEX2025',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Connexion',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(seconds: 1),
                  child: Text(
                    'Veuillez saisir votre email et votre mot de passe',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 4),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: TextFormField(
                            controller: emailController,
                            autofillHints: const [AutofillHints.username],
                            cursorColor: Colors.white,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: "Email",
                              fillColor: const Color(0x1AFAFAFA),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Color(0x1AFAFAFA)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelStyle:
                                  GoogleFonts.roboto(color: Colors.white70),
                              suffixIcon: const Icon(Icons.email,
                                  color: Colors.white70),
                            ),
                            style: GoogleFonts.roboto(color: Colors.white),
                            keyboardType: TextInputType.emailAddress,
                            validator: _validateEmail,
                          ),
                        ),
                        const SizedBox(height: 20),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: !passwordVisibility,
                            textInputAction: TextInputAction.done,
                            cursorColor: Colors.white,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer un mot de passe';
                              }
                              return null;
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: "Mot de passe",
                              fillColor: const Color(0x1AFAFAFA),
                              filled: true,
                              // prefixIcon: prefixIcon,
                              suffixIcon: IconButton(
                                icon: Icon(!passwordVisibility ? Icons.visibility : Icons.visibility_off, color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    passwordVisibility = !passwordVisibility;
                                  });
                                },
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Color(0x1AFAFAFA)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelStyle:
                                  GoogleFonts.roboto(color: Colors.white70),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: TextFormField(
                            controller: role,
                            // textInputAction: TextInputAction.done,
                            readOnly: true,
                            onTap: _showPicker,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer un mot de passe';
                              }
                              return null;
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: "Rôle",
                              fillColor: const Color(0x1AFAFAFA),
                              filled: true,
                              suffixIcon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Colors.white70,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Color(0x1AFAFAFA)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelStyle:
                                  GoogleFonts.roboto(color: Colors.white70),
                            ),
                          ),
                        ),
                        ButtonWidget(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                          onTap: () => _signIn(),
                          text: "Se connecter",
                          color: canvasColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
