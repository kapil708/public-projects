import 'package:flutter/material.dart';

class OnBoardPage extends StatelessWidget {
  const OnBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          FilledButton(onPressed: () {}, child: const Text("Login")),
          OutlinedButton(onPressed: () {}, child: const Text("Singup")),
        ],
      ),
    );
  }
}
