import 'package:flutter/material.dart';
import 'package:flutter_exam/api/app_strings.dart';
import 'package:flutter_exam/providers/app_provider.dart';
import 'package:flutter_exam/screens/login_screen.dart';
import 'package:flutter_exam/screens/others_screen.dart';
import 'package:flutter_exam/screens/social_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ApiProvider>(context);
    final user = provider.user;

    if (provider.isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text("Loading..."),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (user != null) ...[
              _buildUserInfo(provider, user, context),
              const SizedBox(height: 50),
              _buildSocialButtons(context, provider),
            ] else
              const Center(
                child:
                    Text(AppStrings.noUserData, style: TextStyle(fontSize: 18)),
              ),
          ],
        ),
      ),
    );
  }

  // ✅ Widget for User Info Box
  Widget _buildUserInfo(ApiProvider viewModel, user, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 56),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(100, 100, 100, 100),
                items: [
                  PopupMenuItem(
                    
                    onTap: () {
                      viewModel.logout(() {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      });
                    },
                    value: 'logout',
                    child: const Text(AppStrings.logout),
                  ),
                 const PopupMenuItem(
                    value: 'cancel',
                    child: Text(AppStrings.cancel),
                  ),
                ],
              ).then((value) {
                if (value == 'logout') {
                  print("Logging out...");
                } else if (value == 'cancel') {
                  print("Cancelled");
                }
              });
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                user.profilePicture,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.userName,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(user.userId, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ Widget for Social Media Buttons
  Widget _buildSocialButtons(BuildContext context, ApiProvider viewModel) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: _iconButton(
                  'YouTube', 'assets/youtube.png', context, viewModel),
            ),
            Expanded(
              child: _iconButton(
                  'Spotify', 'assets/spotify.png', context, viewModel),
            ),
          ],
        ),
        const SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: _iconButton(
                  'Facebook', 'assets/facebook.png', context, viewModel),
            ),
            Expanded(
              child: _iconButton(
                  'Others', 'assets/others.png', context, viewModel),
            ),
          ],
        ),
      ],
    );
  }

// ✅ Widget for Social Media Button with Click Event
  Widget _iconButton(String name, String assetPath, BuildContext context,
      ApiProvider viewModel) {
    return Container(
      width: 130,
      height: 130,
      child: IconButton(
        icon: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            assetPath,
            width: 130,
            height: 130,
            fit: BoxFit.cover,
          ),
        ),
        onPressed: () async {
          if (name != "Others") {
            await viewModel.getSocials(); // Fetch data first
            final selectedSocial =
                viewModel.social?.firstWhere((social) => social.name == name);

            if (selectedSocial != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SocialScreen(social: selectedSocial),
                ),
              );
            }
          } else {
            // ✅ Navigation for "Others"
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OthersScreen(),
              ),
            );
          }
        },
        style: IconButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
