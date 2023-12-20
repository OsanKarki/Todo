import 'package:flutter/material.dart';
import 'package:todo_app/core/widgets/primary_textfield.dart';
import 'package:todo_app/core/widgets/secondary_textfield.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            height: 300,
            width: width,
            color: Colors.red,
            child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  "SignUP",
                  style: Theme.of(context).textTheme.titleLarge,
                )),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                SecondaryTextField(
                  hintText: "Email",
                  prefixIcon: Icons.email,

                ),
                SecondaryTextField(
                  hintText: "Password",
                  prefixIcon: Icons.key,
                  isPassword: true,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
