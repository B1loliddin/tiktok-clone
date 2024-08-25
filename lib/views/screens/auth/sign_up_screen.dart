import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/services/constants/colors.dart';
import 'package:tiktok_clone/services/constants/get_x.dart';
import 'package:tiktok_clone/utils/helpers/show_snack_bar.dart';
import 'package:tiktok_clone/views/widgets/text_input_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
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
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  void _disposeAllControllers() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void _navigateToSignInScreen() =>
      Navigator.pushReplacementNamed(context, '/sign_in_screen');

  void _signUpButtonOnPressed() {
    final profilePhoto = CustomGetX.authController.profilePhoto;

    if (_formKey.currentState!.validate() && profilePhoto != null) {
      CustomGetX.authController.signUp(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        profilePhoto: profilePhoto,
      );
    } else {
      showSnackBar(
        context,
        'Please fill out all the fields and pick some image',
      );
    }
  }

  void _pickAvatarImage() =>
      CustomGetX.authController.pickImage(ImageSource.gallery);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
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

                /// #register text
                const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 25),

                Stack(
                  children: [
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: _pickAvatarImage,
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const CircleAvatar(
                        radius: 65,
                        backgroundImage: NetworkImage(
                          'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png',
                        ),
                        backgroundColor: CustomColors.backgroundColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      /// #username text input field
                      TextInputField(
                        controller: _usernameController,
                        labelText: 'Username',
                        prefixIcon: const Icon(Icons.person),
                      ),
                      const SizedBox(height: 15),

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

                /// #sign up button
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: CustomColors.buttonColor,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  child: GestureDetector(
                    onTap: _signUpButtonOnPressed,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 50,
                      child: const Center(
                        child: Text(
                          'Sign Up',
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
                          text: 'Sign In',
                          recognizer: TapGestureRecognizer()
                            ..onTap = _navigateToSignInScreen,
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
    );
  }
}
