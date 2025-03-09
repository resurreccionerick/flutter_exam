import 'dart:convert';

import 'package:flutter_exam/models/SocialsModel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_exam/constants/api_endpoints.dart';
import 'package:flutter_exam/models/UserModel.dart'; 
import 'package:flutter_exam/api/api_service.dart'; 
import 'app_test.mocks.dart';

void main() {
  late MockClient mockClient;
  late ApiService apiService;

  setUp(() {
    mockClient = MockClient(); 
    apiService = ApiService(mockClient); 
  });

/** -------------------------------------- LOGIN ----------------------------------------------------- **/

  test('Login test sucess if valid credentials', () async {
      final mockResponse = '''
      {
        "userId": "123",
        "userName": "wewwew",
        "loginStatus": "success",
        "profilePicture": "https://wew.com/profile.jpg"
      }
      ''';

    // Mock the HTTP POST request
    when(mockClient.post(
      Uri.parse(ApiEndpoints.login), 
      body: jsonEncode({
        'userName': 'wewwew',
        'otp': '123123',
      }),
      headers: {
        "CLIENT_ID": "rgbexam",
        "Content-Type": "application/json",
      },
    )).thenAnswer((_) async => http.Response(mockResponse, 200));

    // Act
    final result = await apiService.login('wewwew', '123123'); // Call the login method on ApiService

    // Assert
    expect(result, isA<UserModel>());  // Check if the result is a UserModel
    expect(result.userName, 'wewwew'); // Check if the username is correct
  });



  // Test for failed login
   test('login failed if with invalid credentials', () async {
    // Arrange
    when(mockClient.post(
      Uri.parse(ApiEndpoints.login),
      body: jsonEncode({
        'userName': 'wew_wew', 
        'otp': '1111111', 
      }),
      headers: {
        "CLIENT_ID": "rgbexam",
        "Content-Type": "application/json",
      },
    )).thenAnswer((_) async => http.Response('invalid otp', 400));

    // Act and Assert
    expect(() async => await apiService.login('wew_wew', '1111111'),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Failed to login'), // Check the exception message
        )));
  });

  /** -------------------------------------- SOCIALS ----------------------------------------------------- **/
  test ('getSocial test success',() async{
    final mockResponse = '''
    [{
      "name":"YouTube",
      "webUrl": "https://youtube.com."
    }]
    ''';

    when(mockClient.get(Uri.parse(ApiEndpoints.socials),headers: anyNamed("headers")))
    .thenAnswer((_) async => http.Response(mockResponse, 200));

    // Act
    final result = await apiService.getSocials();

    // Assert
    expect(result, isA<List<SocialsModel>>());

  });


  
    test('getSocial failed API call ', () async {
      // Arrange
      when(mockClient.get(
        Uri.parse(ApiEndpoints.socials),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Not Found', 404));

      // Act and Assert
      expect(() => apiService.getSocials(), throwsException);
    });
}