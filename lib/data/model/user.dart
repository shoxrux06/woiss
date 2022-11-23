// import 'dart:convert';
//
// class MyUser {
//   final int userId;
//   final String token;
//
//   MyUser({
//     required this.userId,
//     required this.token,
//   });
//
//   factory MyUser.fromJson(Map<String, dynamic> jsonData) {
//     return MyUser(
//       userId: jsonData['user_id'],
//       token: jsonData['token'],
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//         'user_id': userId,
//         'token': token,
//       };
//
//   @override
//   String toString() {
//     return 'MyUser{userId: $userId, token: $token}';
//   }
//
// // static String encodeUsers(List<MyUser> users) => jsonEncode(
//   //     users.map<Map<String, dynamic>>((user) => MyUser.toMap()).toList());
//   //
//   // static List<MyUser> decodeUsers(String users) =>
//   //     (jsonDecode(users) as List<dynamic>)
//   //         .map<MyUser>((item) => MyUser.fromJson(item))
//   //         .toList();
// }
