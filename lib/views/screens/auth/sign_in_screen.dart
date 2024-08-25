import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/services/constants/colors.dart';
import 'package:tiktok_clone/services/constants/get_x.dart';
import 'package:tiktok_clone/utils/helpers/show_snack_bar.dart';
import 'package:tiktok_clone/views/widgets/text_input_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _initAllController();
  }

  @override
  void dispose() {
    _disposeAllControllers();
    super.dispose();
  }

  void _initAllController() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  void _disposeAllControllers() {
    _emailController.dispose();
    _passwordController.dispose();
  }

  void _navigateToSignUpScreen() =>
      Navigator.pushReplacementNamed(context, '/sign_up_screen');

  void _signInButtonOnPressed() {
    if (_formKey.currentState!.validate()) {
      CustomGetX.authController.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } else {
      showSnackBar(context, 'Please fill out all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// #tiktok clone text
                  Text(
                    'TikTok Clone',
                    style: TextStyle(
                      fontSize: 35,
                      color: CustomColors.buttonColor,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  /// #sign in text
                  const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 25),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        /// #email text input field
                        TextInputField(
                          controller: _emailController,
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email),
                        ),
                        const SizedBox(height: 15),

                        /// #password text input field
                        TextInputField(
                          controller: _passwordController,
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          isObscure: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  /// #sign in button
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: CustomColors.buttonColor,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    child: GestureDetector(
                      onTap: _signInButtonOnPressed,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        height: 50,
                        child: const Center(
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  /// #navigate to sign up
                  Align(
                    child: RichText(
                      text: TextSpan(
                        text: 'Do You Have An Account? ',
                        children: [
                          TextSpan(
                            text: 'Sign Up',
                            recognizer: TapGestureRecognizer()
                              ..onTap = _navigateToSignUpScreen,
                            style: TextStyle(color: CustomColors.buttonColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
