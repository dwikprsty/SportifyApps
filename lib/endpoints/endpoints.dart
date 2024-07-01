class Endpoints {
  static String baseURL = "http://10.0.2.2:5000";
  static void updateBaseURL(String url) {
    baseURL = url;
  }

//endpoints auth
  static String get register => "$baseURL/api/auth/register";
  static String get login => "$baseURL/api/auth/login";
  static String get logout => "$baseURL/api/auth/logout";

//enpoints show image
  static String get showImage => "$baseURL/api/show_image";
  static String get showProfile => "$baseURL/api/show_profile";

//endpoints fields
  static String get readField => "$baseURL/api/read/lapangan";
  static String get createField => "$baseURL/api/create/lapangan";
  static String get updateField => "$baseURL/api/update/lapangan";
  static String get deleteField => "$baseURL/api/delete/lapangan";
  static String get readSession => "$baseURL/api/read/sessions";

//endpoints reservation
  static String get createReservation => "$baseURL/api/create/reservasi";

//endpoints users
  static String get readUser => "$baseURL/api/read/user";
  static String get createUser => "$baseURL/api/create/user";
  static String get updateUser => "$baseURL/api/user/update";
  static String get deleteUser => "$baseURL/api/delete/user";

  //endpoint history
  static String detailLapangan(String id) => "$baseURL/api/read/lapangan/$id";
  static String detailSesi(String id) => "$baseURL/api/read/session/$id";
  static String readReservation(int id) => "$baseURL/api/read/reservasi/$id";
}
