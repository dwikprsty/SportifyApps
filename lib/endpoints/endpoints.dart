class Endpoints {
  static const String baseURL = "http://10.0.2.2:5000";
  static const String register = "$baseURL/api/auth/register";
  static const String showImage = "$baseURL/api/show_image";
  static const String login = "$baseURL/api/auth/login";
  static const String logout = "$baseURL/api/auth/logout";
  static const String readField = "$baseURL/api/read/lapangan";
  static const String createField = "$baseURL/api/create/lapangan";
  static const String updateField = "$baseURL/api/update/lapangan";
  static const String deleteField = "$baseURL/api/delete/lapangan";
  static const String createReservation = "$baseURL/api/create/reservation";
  static const String readSession = "$baseURL/api/read/sessions";
  static const String readUser = "$baseURL/api/read/user";
  static const String createUser = "$baseURL/api/create/user";
  static const String updateUser = "$baseURL/api/update/user";
  static const String deleteUser = "$baseURL/api/delete/user";
}
