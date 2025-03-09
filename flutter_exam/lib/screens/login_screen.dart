import 'package:flutter/material.dart';
import 'package:flutter_exam/api/app_strings.dart';
import 'package:flutter_exam/providers/app_provider.dart';
import 'package:flutter_exam/screens/home_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ApiProvider>(context);

    if (provider.isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10), 
              Text(AppStrings.loggingIn),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          
              Container(
                height: 150,
                width: double.infinity,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double containerWidth = constraints.maxWidth;
                    double iconSize = 120;

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // YouTube Icon (Bottom)
                        Positioned(
                          top: 20,
                          left:
                              (containerWidth - iconSize) / 2 - 80, // Centered
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/youtube.png',
                              width: iconSize,
                              height: iconSize,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Spotify Icon (Middle)
                        Positioned(
                          top: 45,
                          left: (containerWidth - iconSize) / 2, // Centered
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/spotify.png',
                              width: iconSize,
                              height: iconSize,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Facebook Icon (Top)
                        Positioned(
                          top: 65,
                          left:
                              (containerWidth - iconSize) / 2 + 80, // Centered
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/facebook.png',
                              width: iconSize,
                              height: iconSize,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 100),

              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  children: [
                    // Username TextField
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Username",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: provider.setUsername,
                    ),

                    if (provider.errorMessage.isNotEmpty)
                      Text(
                        provider.errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),

                    const SizedBox(height: 10),

                    // Enter Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        onPressed: provider.isEnterButtonEnabled
                            ? () {
                                _showPinDialog(provider);
                              }
                            : null,
                        child: const Text(AppStrings.enter),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }

void _showPinDialog(ApiProvider provider) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "${AppStrings.verifyPinTitle}\n",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: AppStrings.enterPinMessage,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // PIN Input
            TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 6,
              obscureText: true,
              style: const TextStyle(
                letterSpacing: 10, // Space between numbers
                fontSize: 24,
              ),
              decoration: const InputDecoration(
                hintText: "------",
                counterText: "",
                border: InputBorder.none,
              ),
              onChanged: provider.setPin,
            ),
            const SizedBox(height: 10),

            // Horizontal Divider
            const Divider(height: 1, thickness: 1),

            // Buttons Row
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      Navigator.pop(dialogContext);
                      await provider.login();
                      if (provider.user != null &&
                          provider.user!.loginStatus == "success") {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()),
                        );
                      } else {
                        _showErrorDialog();
                      }
                    },
                    child: const Text(AppStrings.enter,
                        style: TextStyle(color: Colors.green, fontSize: 16)),
                  ),
                ),

                // Vertical Separator
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.grey,
                ),

                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text(AppStrings.close,
                        style: TextStyle(color: Colors.red, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}


  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Error\n",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: AppStrings.loginFailed,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text(AppStrings.close,
                          style: TextStyle(color: Colors.red)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
