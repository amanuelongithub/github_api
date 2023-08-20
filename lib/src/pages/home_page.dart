import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:git_hub_clone/src/controllers/leading_controller.dart';
import 'package:git_hub_clone/src/model/user.dart';
import 'package:git_hub_clone/src/pages/detail_page.dart';

import '../api/api_controller.dart';
import '../model/userlist.dart';

class HomePage extends StatelessWidget {
  var leadingController = Get.find<LeadingController>();

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
        borderSide: Divider.createBorderSide(context),
        borderRadius: BorderRadius.circular(10));

    return SafeArea(
      child: Obx(() {
        return Scaffold(
          backgroundColor: Color.fromARGB(255, 34, 33, 43),
          body: Column(children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Adjust as needed
                children: [
                  InkWell(
                    onTap: () {
                      Get.find<LeadingController>().searchisTaped.value = false;
                      Get.find<LeadingController>().searchgitUser.value.clear();
                    },
                    child: Image.asset(
                      'assets/github.png',
                      scale: 2,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: leadingController.searchgitUser.value,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "search",
                        hintStyle: TextStyle(
                            color: Color.fromARGB(255, 136, 136, 136),
                            fontSize: 14),
                        fillColor: Color.fromARGB(191, 45, 39, 53),
                        filled: true,
                        border: inputBorder,
                        enabledBorder: inputBorder,
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
                        Get.find<LeadingController>().searchisTaped.value =
                            true;

                        leadingController.searchText.value = value;
                      },
                    ),
                  ),
                  // const SizedBox(width: 8.0),
                  // ElevatedButton(
                  //     style:
                  //         ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  //     onPressed: () {
                  //       Get.find<LeadingController>().searchisTaped.value =
                  //           false;
                  //       searchgitUser.text = '';
                  //     },
                  //     child: Text('Clear'))
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
                            if (snapshot.data == null) {
                              return const Center(
                                  child: Text(
                                "User not found",
                                style: TextStyle(color: Colors.grey),
                              ));
                            } else if (snapshot.hasError) {
                              return const Center(
                                child: Text(
                                  "User not found",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              );
                            } else if (snapshot.hasData &&
                                snapshot.data!.name != '') {
                              if (snapshot.data == null) {
                                return const Center(
                                  child: Text(
                                    "Empty",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                              } else {
                                return ListTile(
                                  onTap: () {
                                    Get.to(() => DetailePage(
                                        username: snapshot.data!.login));
                                  },
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        NetworkImage(snapshot.data!.avatarUrl),
                                  ),
                                  title: Text(
                                    snapshot.data!.name ?? 'Anonymouss',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    snapshot.data!.createdAt.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              }
                            }
                          }
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.red,
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
                                  child: Text(
                                    "Empty",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              }
                              return ListView.separated(
                                  keyboardDismissBehavior:
                                      ScrollViewKeyboardDismissBehavior.onDrag,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                        height: 10,
                                      ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    UserList user = snapshot.data![index];
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 53, 51, 67),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: ListTile(
                                        onTap: () {
                                          Get.to(() => DetailePage(
                                              username: user.login));
                                        },
                                        leading: CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.grey,
                                          backgroundImage:
                                              NetworkImage(user.avatarUrl),
                                        ),
                                        title: Text(
                                          user.login,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        subtitle: Text(
                                          '${user.type}',
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 147, 147, 147)),
                                        ),
                                      ),
                                    );
                                  });
                            }
                          }
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.green,
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
