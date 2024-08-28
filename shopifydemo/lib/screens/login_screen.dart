import 'package:flutter/material.dart';
import 'package:shopifydemo/models/shopify_mixin.dart';
import 'package:shopifydemo/models/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with ShopifyMixin {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  var formKey = GlobalKey<FormState>();
  User? user;

  void loginUser() async {
    user = await shopifyService.login(
      username: txtEmail.text,
      password: txtPassword.text,
    );

    txtEmail.clear();
    txtPassword.clear();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Screen")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Email"),
                TextFormField(controller: txtEmail),
                const SizedBox(height: 10),
                const Text("Password"),
                TextFormField(controller: txtPassword),
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const Text("Create User"),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      loginUser();
                    }
                  },
                ),
                const SizedBox(height: 20),
                if (user != null) Text(user!.toJson().toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
