import 'package:bloc_with_services_boilerplate/environment.dart';

class ApiMethods {
  static String login = '${Environment.apiUrl}/v1/machine/login';
  static String machine = '${Environment.apiUrl}/v1/machine';
  static String inventory = '${Environment.apiUrl}/v1/inventory';
  static String inventoryDispense = '${Environment.apiUrl}/v1/inventory/dispense';
}
