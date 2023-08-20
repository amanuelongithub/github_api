import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:git_hub_clone/src/controllers/leading_controller.dart';
import 'package:git_hub_clone/src/model/user.dart';

import '../api/api_controller.dart';
import '../model/userlist.dart';

class HomePage extends StatelessWidget {
  TextEditingController searchgitUser = TextEditingController();
  var leadingController = Get.find<LeadingController>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        return Scaffold(
          body: Column(children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Adjust as needed
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchgitUser,
                      decoration: InputDecoration(
                        hintText: "search",
                        hintStyle:
                            TextStyle(color: Colors.grey[400], fontSize: 14),
                        filled: true,
                        errorStyle: const TextStyle(fontSize: 0.01),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onChanged: (value) {
                        leadingController.searchText.value = value;
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                      onPressed: () {
                        Get.find<LeadingController>().searchisTaped.value =
                            true;
                      },
                      child: Text('Search')),
                  ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        Get.find<LeadingController>().searchisTaped.value =
                            false;
                        searchgitUser.text = '';
                      },
                      child: Text('Clear'))
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Get.find<LeadingController>().searchisTaped.value
                ? Expanded(
                    key: ValueKey(leadingController.searchText.value),
                    child: FutureBuilder<User?>(
                        future: leadingController.getUser(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              return const Center(
                                child: Text("User not found"),
                              );
                            }
                            if (snapshot.hasData) {
                              if (snapshot.data == null) {
                                return const Center(
                                  child: Text("Empty"),
                                );
                              }
                              return ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      NetworkImage(snapshot.data!.avatarUrl),
                                ),
                                title: Text(snapshot.data!.name),
                                subtitle:
                                    Text(snapshot.data!.createdAt.toString()),
                              );
                            }
                          }
                          return const Center(
                            child: CircularProgressIndicator(
                                // color: ,
                                ),
                          );
                        }),
                  )
                : Expanded(
                    child: FutureBuilder<List<UserList>>(
                        future: Get.find<LeadingController>().getUserList(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              return const Center(
                                child: Text("An error occurred."),
                              );
                            }
                            if (snapshot.hasData) {
                              if (snapshot.data!.length == 0) {
                                return const Center(
                                  child: Text("Empty"),
                                );
                              }
                              return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    UserList user = snapshot.data![index];
                                    return ListTile(
                                      leading: CircleAvatar(
                                        radius: 30,
                                        backgroundImage:
                                            NetworkImage(user.avatarUrl),
                                      ),
                                      title: Text(user.login),
                                      subtitle: Text(user.type),
                                    );
                                  });
                            }
                          }
                          return const Center(
                            child: CircularProgressIndicator(
                                // color: ,
                                ),
                          );
                        }),
                  ),
          ]),
        );
      }),
    );
  }
}
