import 'package:flutter/material.dart';
import 'package:population/services.dart';

import 'homePage.dart';

class SetPseudoScreen extends StatefulWidget {
  const SetPseudoScreen({super.key});

  @override
  _SetPseudoScreenState createState() => _SetPseudoScreenState();
}

class _SetPseudoScreenState extends State<SetPseudoScreen> {
  final TextEditingController _controller = TextEditingController();

  void _savePseudo() {
    if (_controller.text.isNotEmpty) {
      UserPreferences.setPseudo(_controller.text).then((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Entrez Votre PSEUDONYME")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Mettez un pseudo'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _savePseudo,
              child: const Text('VALIDER'),
            ),
          ],
        ),
      ),
    );
  }
}