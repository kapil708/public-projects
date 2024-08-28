import 'package:flutter/material.dart';
import 'package:shopifydemo/models/shopify_mixin.dart';
import 'package:shopifydemo/models/user.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({Key? key}) : super(key: key);

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> with ShopifyMixin {
  TextEditingController txtFName = TextEditingController();
  TextEditingController txtLName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtPhone = TextEditingController();

  List<User> userList = [];
  var formKey = GlobalKey<FormState>();

  void createUser() async {
    User data = await shopifyService.createUser(
      firstName: txtFName.text,
      lastName: txtLName.text,
      email: txtEmail.text,
      password: txtPassword.text,
      phoneNumber: txtPhone.text,
    );
    userList.add(data);

    txtFName.clear();
    txtLName.clear();
    txtEmail.clear();
    txtPassword.clear();
    txtPhone.clear();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create User Account")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("First Name"),
                TextFormField(controller: txtFName),
                const SizedBox(height: 10),
                const Text("Last Name"),
                TextFormField(controller: txtLName),
                const SizedBox(height: 10),
                const Text("Email"),
                TextFormField(controller: txtEmail),
                const SizedBox(height: 10),
                const Text("Password"),
                TextFormField(controller: txtPassword),
                const SizedBox(height: 10),
                const Text("Phone No"),
                TextFormField(controller: txtPhone),
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const Text("Create User"),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      createUser();
                    }
                  },
                ),
                const SizedBox(height: 20),
                ...userList.map((user) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.toJson().toString()),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
