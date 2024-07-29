import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ALERTE SECURITE")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centrer verticalement dans le Column
          children: <Widget>[
            const Text('Voulez-vous signaler l\'alerte de Sécurité?'),
            const SizedBox(height: 20), // Ajouter un espace
            ElevatedButton(
              onPressed: () => _showPhoneDialog(context),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Définir la couleur de fond du bouton
                  shape: const CircleBorder(), // Rendre le bouton rond
                  padding: const EdgeInsets.all(24) // Espace interne pour agrandir le bouton
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min, // Pour que la colonne ne prenne pas toute la largeur disponible
                children: <Widget>[
                  Icon(
                    Icons.warning,
                    color: Colors.white,
                    size: 50,
                  ), // Icône de l'alerte
                  Text(
                      'ALERTER',
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white
                      )
                  ), // Texte sous l'icône
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPhoneDialog(BuildContext context) {
    TextEditingController phoneController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Entrer votre numéro de téléphone"),
          content: TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(hintText: "Numéro de téléphone"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
            ),
            TextButton(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.greenAccent
                ),
                  child: Text(
                      "Valider"
                  )
              ),
              onPressed: () {
                // Ici, vous pouvez ajouter la logique pour traiter le numéro de téléphone
                print('Le numéro de téléphone est : ${phoneController.text}');
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
            ),
          ],
        );
      },
    );
  }
}