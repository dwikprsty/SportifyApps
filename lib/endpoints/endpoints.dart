class Endpoints {
  static  String baseURL = "http://10.0.2.2:5000";
  static void updateBaseURL(String url) {
    baseURL = url;
  }

  static String get register => "$baseURL/api/auth/register";
  static String get showImage => "$baseURL/api/show_image";
  static String get login => "$baseURL/api/auth/login";
  static String get logout => "$baseURL/api/auth/logout";
  static String get readField => "$baseURL/api/read/lapangan";
  static String get createField => "$baseURL/api/create/lapangan";
  static String get updateField => "$baseURL/api/update/lapangan";
  static String get deleteField => "$baseURL/api/delete/lapangan";
  static String get createReservation => "$baseURL/api/create/reservation";
  static String get readSession => "$baseURL/api/read/sessions";
  static String get readUser => "$baseURL/api/read/user";
  static String get createUser => "$baseURL/api/create/user";
  static String get updateUser => "$baseURL/api/user/update";
  static String get deleteUser => "$baseURL/api/delete/user";

  // static void updateBaseURL(String url) {}
}