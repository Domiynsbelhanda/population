import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:population/services.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {

  bool _isLoading = false;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60 * 10; // 10 minutes


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
              child: _isLoading ? const CircularProgressIndicator() : const Column(
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
                _sendAlert(phoneController.text);
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
            ),
          ],
        );
      },
    );
  }

  void _sendAlert(String phoneNumber) async {
    setState(() {
      _isLoading = true;  // Activer l'indicateur de chargement
    });

    try {
      Position position = await determinePosition();

      // Construire l'URL de l'API
      var url = Uri.parse('https://tableau.ourworldtkpl.com/api/alertes');

      // Préparer le corps de la requête
      var body = jsonEncode({
        'pseudo': UserPreferences.getPseudo(),  // Assurez-vous de récupérer le pseudo stocké localement
        'telephone': phoneNumber,
        'latitude': position.latitude.toString(),
        'longitude': position.longitude.toString(),
      });

      // Envoyer la requête POST
      var response = await http.post(url, headers: {
        'Content-Type': 'application/json'
      }, body: body);

      if (response.statusCode == 201) {
        _showSuccessDialog(context);
      } else {
        _showErrorDialog(context, phoneNumber, 'Erreur ${response.statusCode}');
      }
    }
    catch (e) {
      _showErrorDialog(context, phoneNumber, 'Erreur $e');
    }
    finally {
      setState(() {
        _isLoading = false;  // Désactiver l'indicateur de chargement après la requête
      });
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        int remainingMinutes = 10;  // Initialiser avec 10 minutes

        return AlertDialog(
          title: const Text("Alerte envoyée avec succès!"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              Timer.periodic(const Duration(minutes: 1), (Timer timer) {
                if (remainingMinutes == 0) {
                  timer.cancel();
                  Navigator.of(context).pop();
                } else {
                  setState(() {
                    remainingMinutes--;
                  });
                }
              });

              return Text("Si vous ne recevez pas un appel à la fin du compteur de $remainingMinutes minutes, rélancez l'alerte");
            },
          ),
          actions: <Widget>[
            Center(
            child: CountdownTimer(
              endTime: endTime,
              widgetBuilder: (_, CurrentRemainingTime? time) {
                if (time == null) {
                  return const Text("Le compteur est terminé",
                      style: TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold));
                }
                return Text(
                  'Temps restant: ${time.min ?? 0} minutes ${time.sec ?? 0} secondes',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                );
              },
              onEnd: () {
                Navigator.of(context).pop();
              },
            )),
            TextButton(
              child: const Text("Fermer"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  void _showErrorDialog(BuildContext context, String phoneNumber, String e) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Une erreur s'est produite"),
          content: Text('$e'),
          actions: <Widget>[
            TextButton(
              child: Text("Annuler"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Recommencer"),
              onPressed: () {
                Navigator.of(context).pop();
                _sendAlert(phoneNumber); // Réessayer avec les mêmes informations
              },
            ),
          ],
        );
      },
    );
  }


}