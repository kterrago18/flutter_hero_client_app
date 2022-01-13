import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_hero_client_app/models/models.dart';

import 'package:flutter_hero_client_app/res/res.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static MaterialPage page() {
    return MaterialPage(
      name: HeroClientPages.loginPath,
      key: ValueKey(HeroClientPages.loginPath),
      child: const LoginScreen(),
    );
  }

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late bool _passwordVisible;
  final _passwordTextEditingController = TextEditingController();
  final _emailTextEditingController = TextEditingController();

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  void dispose() {
    _passwordTextEditingController.dispose();
    _emailTextEditingController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: PaddingSpacing.paddingAll8,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const FlutterLogo(
                  size: 80,
                ),
                SizedBoxSpacing.height16,
                buildText(
                  label: 'Login to your account',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBoxSpacing.height10,
                buildText(label: 'and start hiring Heroes!'),
                SizedBoxSpacing.height16,
                buildTextfield(
                  controller: _emailTextEditingController,
                  hintText: 'Email',
                  isEmail: true,
                ),
                SizedBoxSpacing.height16,
                buildTextfield(
                    controller: _passwordTextEditingController,
                    hintText: 'Password',
                    isPassword: true,
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    obscureText: !_passwordVisible),
                SizedBoxSpacing.height16,
                buildButton(
                  context,
                  _emailTextEditingController,
                  _passwordTextEditingController,
                ),
                SizedBoxSpacing.height10,
                GestureDetector(
                  onTap: () {
                    Provider.of<LoginStateManager>(context, listen: false)
                        .tapOnForgotPassword(true);
                  },
                  child: buildText(
                    label: 'Forgot password?',
                    style: const TextStyle(
                        color: kPrimaryColor, fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                buildTextSpan(
                    onTap: () =>
                        Provider.of<LoginStateManager>(context, listen: false)
                            .tapOnCreateAccount(true)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context, TextEditingController email,
      TextEditingController password) {
    return SizedBox(
      height: 55,
      child: MaterialButton(
        color: kPrimaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          final appStateManager =
              Provider.of<AppStateManager>(context, listen: false);

          if (_formKey.currentState!.validate()) {
            await appStateManager.login(email.text, password.text);
            print('## email: ${email.text}, pwd: ${password.text}');
            if (!appStateManager.isEmailExist) {
              ScaffoldMessenger.of(context).showSnackBar(
                setSnackBarContent('The account you entered does not exist.'),
              );

              return;
            }
            if (!appStateManager.isAuthorized && appStateManager.isEmailExist) {
              ScaffoldMessenger.of(context).showSnackBar(
                setSnackBarContent(
                    'Wrong credentials! Incorrect email address or password'),
              );
              return;
            }
            if (appStateManager.isLoggedIn) {
              print('succesfull');
              return;
            }
          } else {
            print("UnSuccessfull");
          }
        },
      ),
    );
  }

  SnackBar setSnackBarContent(String content) {
    return SnackBar(content: Text(content));
  }

  Widget buildTextfield(
      {String? hintText,
      Widget? suffixIcon,
      bool obscureText = false,
      bool isEmail = false,
      bool isPassword = false,
      required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      // cursorColor: rwColor,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          // focusedBorder: const OutlineInputBorder(
          //   borderSide: BorderSide(color: Colors.green),
          // ),
          filled: true,
          hintText: hintText,
          fillColor: Colors.white70,
          // hintStyle: const TextStyle(height: 0.5),
          suffixIcon: suffixIcon),
      obscureText: obscureText,
      enableSuggestions: false,
      autocorrect: false,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],

      validator: (value) {
        if (value!.isEmpty) {
          return 'Please a enter $hintText';
        }
        if (isEmail &&
            !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(value.toLowerCase())) {
          return 'Invalid Email';
        }

        if (isPassword) {
          if (value.length < 8) {
            return "Password must be atleast 8 characters long";
          }
          // if (!value.contains(RegExp(r'[0-9]'))) {
          //   return "Password must contain a number";
          // }

        }
        return null;
      },
    );
  }
}

Widget buildTextSpan({VoidCallback? onTap}) {
  return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      text: 'Don\'t have an account? ',
      style: const TextStyle(color: Colors.black),
      children: [
        TextSpan(
          text: 'Register',
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: kPrimaryColor),
          recognizer: TapGestureRecognizer()..onTap = onTap,
        ),
      ],
    ),
  );
}

Widget buildText({required String label, TextStyle? style}) {
  return Text(
    label,
    style: style,
    textAlign: TextAlign.center,
  );
}
