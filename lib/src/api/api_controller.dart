import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:git_hub_clone/src/model/user.dart';

import '../model/userlist.dart';

class AppUrl {
  static var baseUrl = 'https://api.github.com';
}

class AppAPI {
       String? message = 'Some error occurred';

  Future<List<UserList>> githubUsers() async {
    List<UserList> userList = <UserList>[];

    try {
      var pref = await SharedPreferences.getInstance();

      var dio = Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["Authorization"] =
          'Bearer ${pref.getString('token')}';

      Response response = await dio.get(
        '${AppUrl.baseUrl}/users',
        options: Options(
          responseType: ResponseType.plain,
        ),
      );
      if (response.statusCode == 200) {
        final responseBody = response.data;
        var parsedData = jsonDecode(responseBody.toString());
        for (var userMap in parsedData) {
          try {
            userList.add(UserList.fromJson(userMap));
            // var singleUser =await  AppAPI().searchUser('amanuelongithub');
            // if (singleUser != null) {
            //   userList.add(singleUser);
            // }
          } catch (error) {
            continue;
          }
        }
      } else {
        throw Exception(
            'Failed to fetch search results: server returned ${response.statusCode}');
      }
    } catch (e) {

      if (e is DioException) {
        if (e.response?.statusCode == 403) {
          message = e.response!.statusMessage;
        } else if (e.response?.data != null) {
          message = e.response!.data;
        }
      }
    }
    return userList;
  }

  Future<User?> searchUser(String username) async {
    User? user;
    try {
      var pref = await SharedPreferences.getInstance();

      var dio = Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["Authorization"] =
          'Bearer  ${pref.getString('token')}';

      Response response = await dio.get(
        '${AppUrl.baseUrl}/users/$username',
        options: Options(
          responseType: ResponseType.plain,
        ),
      );
      if (response.statusCode == 200) {
        var val = jsonDecode(response.data);

        user = User.fromJson(val);
      } else {
         message = response.data['message'];
      }
    } catch (e) {
   
      if (e is DioException) {
        if (e.response?.statusCode == 403) {
          message = e.response!.statusMessage;
        } else if (e.response?.data != null) {
          message = e.response!.data['message'];
        }
      }
    }
    return user;
  }
  

}
