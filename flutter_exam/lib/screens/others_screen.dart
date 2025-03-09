import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

 class OthersScreen extends StatelessWidget {
   const OthersScreen({super.key});
 
   @override
   Widget build(BuildContext context) {
     // screen size
     double screenWidth = MediaQuery.of(context).size.width;
     double screenHeight = MediaQuery.of(context).size.height;
 
     final List<Map<String, String>> items = [
       {
         "image": "assets/apple.png",
         "name": "Apple",
         "url": "https://www.apple.com"
       },
       {
         "image": "assets/samsung.png",
         "name": "Samsung",
         "url": "https://www.samsung.com"
       },
       {
         "image": "assets/windows.png",
         "name": "Windows",
         "url": "https://www.microsoft.com"
       },
     ];
 
     return Scaffold(
       appBar: AppBar(
         title: const Text("Others"),
         backgroundColor: Colors.amber,
       ),
       body: Center(
         child: Column(
           children: [
             const SizedBox(height: 20),
              const Text("You might also like"),

             // Carousel Slider
             CarouselSlider(
               options: CarouselOptions(
                 height: screenHeight * 0.45, 
                 autoPlay: true,
                 enlargeCenterPage: true,
                 viewportFraction: 0.70,
                 
               ),
               items: items.map((item) {
                 return Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [

          

                     // Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(8), 
                        child: Image.asset(
                          item["image"]!,
                          width: screenWidth * 0.7,
                          height: screenHeight * 0.2,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

 
                     const SizedBox(height: 10),
 
                     // Text
                     Text(
                       item["name"]!,
                       style: TextStyle(
                         fontSize: screenWidth * 0.06,
                         
                       ),
                     ),
 
                     const SizedBox(height: 10),
 
                     // Button
                     SizedBox(
                       width: screenWidth * 0.6, 
                       child: ElevatedButton(
                        onPressed: () async {
                          
                             final Uri url = Uri.parse(item["url"] ?? "");

                              print("URL WAS: $url");
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text("Could not launch ${item["url"]}"),
                                  ),
                                );
                              }
                            },
                         style: ElevatedButton.styleFrom(
                           backgroundColor: Colors.amber,
                           padding: const EdgeInsets.symmetric(vertical: 12),
                         ),
                         child: Text(
                           "Visit ${item["name"]} Website",
                           style: const TextStyle(fontSize: 16, color: Colors.white),
                         ),
                       ),
                     ),
                   ],
                 );
               }).toList(),
             ),
           ],
         ),
       ),
     );
   }
 }