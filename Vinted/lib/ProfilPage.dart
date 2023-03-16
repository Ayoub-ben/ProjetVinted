import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_register_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();

}

class _ProfilePageState extends State<ProfilePage> {
  final _villeController = TextEditingController();
  final _codePostalController = TextEditingController();
  final _anniversaireController = TextEditingController();
  final _adresseController = TextEditingController();
  final _emailController = TextEditingController();
  final _motdepasseController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  String? _password;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    user = _auth.currentUser;
    FirebaseAuth.instance.currentUser!.getIdToken().then((idToken) {
      setState(() {
        _password = idToken;
      });
    });

  }

  @override
  void dispose() {
    _villeController.dispose();
    _codePostalController.dispose();
    _anniversaireController.dispose();
    _adresseController.dispose();
    _emailController.dispose();
    _motdepasseController.dispose();
    super.dispose();
  }

  void _loadProfile() async {
    final document = await FirebaseFirestore.instance.collection('users').doc('mon-profil').get();
    if (document.exists) {
      final data = document.data() as Map<String, dynamic>;
      _villeController.text = data['ville'];
      _codePostalController.text = data['code Postal'];
      _anniversaireController.text = data['anniversaire'];
      _adresseController.text = data['adresse'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
               'Mail : '
            ),
            Text(
                user?.email ?? 'Non connecté',
                style: TextStyle(
                  fontSize: 18,
                ),
            ),
            SizedBox(height: 16),
            Text(
                'Mot de passe : '
            ),
            Text(
              user?.providerData[0].providerId == 'password'
                  ? '********'
                  : 'Non disponible',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _villeController,
              decoration: InputDecoration(
                labelText: 'Ville',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _codePostalController,
              decoration: InputDecoration(
                labelText: 'code Postal',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _anniversaireController,
              decoration: InputDecoration(
                labelText: 'anniversaire',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _adresseController,
              decoration: InputDecoration(
                labelText: 'adresse',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('users').doc('mon-profil').set({
                  'ville': _villeController.text,
                  'code Postal': _codePostalController.text,
                  'anniversaire': _anniversaireController.text,
                  'adresse': _adresseController.text,
                });
              },
              child: Text('Valider'),
            ),
            ElevatedButton(child: Text('Déconnexion'),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
