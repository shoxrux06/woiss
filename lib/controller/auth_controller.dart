import 'package:furniture_app/data/model/user.dart';
import 'package:furniture_app/data/repository/auth_repo.dart';
import 'package:furniture_app/screens/custom_snackbar.dart';
import 'package:furniture_app/utils/cache_manager.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController implements GetxService {
  late AuthRepo authRepo;
  late SharedPreferences? sharedPreferences;

  AuthController({required this.sharedPreferences,required this.authRepo});

  bool _isLogged = false;

  bool get isLogged => _isLogged;

  Future<dynamic> loginMethod(String email, String password) async {
    final cacheManager = CacheManager();
    // List<MyUser> users =  await cacheManager.getUsers();
    dynamic response;
    response = await authRepo.loginMethod(email: email, password: password);
    if(response['status'] == true){
      // users.add(MyUser(userId: response['message']['user_id'], token: response['message']['token']));
      // await cacheManager.saveToken(response['message']['token']);
      await cacheManager.saveUserId(response['message']['user_id']);
      await cacheManager.saveUserEmail(response['message']['email']);
      await cacheManager.saveUserName(response['message']['usename']);
      await cacheManager.saveBranchPhone(response['message']['branch_phone']);
      // print('UserList>>>>>$users');
      print('response ---------------->${response}');
    }
    // await cacheManager.saveUser(users);
    return response;
  }

  Future<dynamic> checkPassword(String email, String token) async{
    dynamic response;
    response = await authRepo.checkPassword(email: email, token: token);
    final cacheManager = CacheManager();
    if(response['status'] == true){
      // users.add(MyUser(userId: response['message']['user_id'], token: response['message']['token']));
      await cacheManager.saveToken(token);
      // await cacheManager.saveUserId(response['message']['user_id']);
      // await cacheManager.saveUserEmail(response['message']['email']);
      // await cacheManager.saveUserName(response['message']['usename']);
      // await cacheManager.saveBranchPhone(response['message']['branch_phone']);
      // print('UserList>>>>>$users');
      print('response ---------------->${response}');
    }
    print('########${response} in Auth Controller checkPassword');
    return response;
  }

  Future<dynamic> getBranchAgentList() async {
    dynamic response;
    response = await authRepo.getBranchAgentList();
    update();
    print('Brach Agent List >>>>>$response');
    return response;
  }

  void checkLoginStatus() async {
    final cacheManager = CacheManager();
    String? token = await cacheManager.getToken();
    if (token != null) {
      _isLogged = true;
      update();
    }else{
      _isLogged = false;
      update();
    }
  }

  bool _isActiveRememberMe = false;

  bool get isActiveRememberMe => _isActiveRememberMe;

  void toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    update();
  }
}
