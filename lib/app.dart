import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/services/constants/colors.dart';
import 'package:tiktok_clone/views/screens/add_video_screen.dart';
import 'package:tiktok_clone/views/screens/profile_screen.dart';
import 'package:tiktok_clone/views/screens/auth/sign_in_screen.dart';
import 'package:tiktok_clone/views/screens/auth/sign_up_screen.dart';
import 'package:tiktok_clone/views/screens/comment_screen.dart';
import 'package:tiktok_clone/views/screens/confirm_screen.dart';
import 'package:tiktok_clone/views/screens/home_screen.dart';
import 'package:tiktok_clone/views/screens/search_screen.dart';
import 'package:tiktok_clone/views/screens/video_screen.dart';

class TikTokClone extends StatelessWidget {
  const TikTokClone({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TikTok Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: CustomColors.backgroundColor,
      ),
      routes: {
        '/sign_up_screen': (_) => const SignUpScreen(),
        '/sign_in_screen': (_) => const SignInScreen(),
        '/profile_screen': (_) => const ProfileScreen(),
        '/home_screen': (_) => const HomeScreen(),
        '/video_screen': (_) => const VideoScreen(),
        '/add_video_screen': (_) => const AddVideoScreen(),
        '/confirm_screen': (_) => const ConfirmScreen(),
        '/comment_screen': (_) => const CommentScreen(),
        '/search_screen': (_) => const SearchScreen(),
      },
      initialRoute: '/sign_in_screen',
    );
  }
}
