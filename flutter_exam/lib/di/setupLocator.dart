
import 'package:flutter_exam/api/api_service.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final GetIt locator = GetIt.instance;

void setupLocator(){
  locator.registerLazySingleton(() => http.Client());
  locator.registerSingleton<ApiService>(ApiService(locator()));
}