import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hero_client_app/models/models.dart';
import 'package:flutter_hero_client_app/res/app_spacing.dart';
import 'package:flutter_hero_client_app/res/res.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  static MaterialPage page() {
    return MaterialPage(
      name: HeroClientPages.forgotPasswordPath,
      key: ValueKey(HeroClientPages.forgotPasswordPath),
      child: ForgotPasswordScreen(),
    );
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Provider.of<LoginStateManager>(context, listen: false)
                .tapOnForgotPassword(false);
          },
        ),
      ),
      body: Padding(
        padding: PaddingSpacing.paddingAll8,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBoxSpacing.height24,
              Text(
                'Reset password',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBoxSpacing.height10,
              Text(
                  'Enter the email associated with your account and we\'ll send an email with instructions to reset your password'),
              SizedBoxSpacing.height16,
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  filled: true,
                  hintText: 'Email Address',
                  fillColor: Colors.white70,
                ),
                enableSuggestions: false,
                autocorrect: false,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(50),
                ],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please a enter Email address';
                  }

                  if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value.toLowerCase())) {
                    return 'Invalid Email';
                  }

                  return null;
                },
              ),
              SizedBoxSpacing.height10,
              SizedBox(
                height: 55,
                child: MaterialButton(
                  color: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  child: const Text(
                    'Send instructions',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    // Provider.of<AppStateManager>(context, listen: false)
                    //     .login('mockUsername', 'mockPassword');

                    if (_formKey.currentState!.validate()) {
                      print("successful");
                      return;
                    } else {
                      print("UnSuccessfull");
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
