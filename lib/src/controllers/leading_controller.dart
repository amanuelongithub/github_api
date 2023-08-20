import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:git_hub_clone/src/model/user.dart';
import 'package:git_hub_clone/src/model/userlist.dart';

import '../api/api_controller.dart';

class LeadingController extends GetxController {
  RxList<UserList> userList = RxList<UserList>([]);
  Rx<TextEditingController> searchgitUser = Rx(TextEditingController());

  var searchText = "".obs;
  User? user;
  RxBool searchisTaped = false.obs;

  Future<List<UserList>> getUserList() async {
    userList.value = await AppAPI().githubUsers();
    return userList;
  }

  Future<User?> getUser() async {
    user = await AppAPI().searchUser(searchText.value);
    return user;
  }
}
