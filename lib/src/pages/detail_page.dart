import 'package:flutter/material.dart';
import 'package:git_hub_clone/src/api/api_controller.dart';

import '../model/user.dart';

class DetailePage extends StatelessWidget {
  final String username;
  const DetailePage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('User Detaile'),
        backgroundColor: const Color.fromARGB(255, 43, 37, 62),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: FutureBuilder<User?>(
          future: AppAPI().searchUser(username),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
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
              } else if (snapshot.hasData && snapshot.data!.name != '') {
                if (snapshot.data == null) {
                  return const Center(
                    child: Text(
                      "Empty",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 80),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 44, 36, 52),
                                borderRadius: BorderRadius.circular(20)),
                            width: double.infinity,
                            height: 300,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 28.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Flexible(flex: 2, child: Container()),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        // ElevatedButton(
                                        //     onPressed: () {},
                                        //     style: ElevatedButton.styleFrom(
                                        //         backgroundColor: Colors.green,
                                        //         shape: RoundedRectangleBorder(
                                        //             borderRadius:
                                        //                 BorderRadius.circular(5)),
                                        //         minimumSize: Size(110, 38)),
                                        //     child: Text()),
                                        // OutlinedButton(
                                        //     onPressed: () {},
                                        //     style: OutlinedButton.styleFrom(
                                        //         foregroundColor: Colors.red,
                                        //         shape: RoundedRectangleBorder(
                                        //             borderRadius:
                                        //                 BorderRadius.circular(5)),
                                        //         minimumSize: Size(110, 38)),
                                        //     child: Text('Unfollow'))
                                        Row(
                                          children: [
                                            const Text(
                                              'Followers  ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              snapshot.data!.followers
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Following  ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              snapshot.data!.following
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: Colors.green),
                                            ),
                                          ],
                                        ),
                                      ]),
                                  Expanded(
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          snapshot.data!.bio ?? '_',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 185, 185, 185),
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                              top: 30,
                              left: 0,
                              right: 0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Colors.green,
                                    child: CircleAvatar(
                                      radius: 58,
                                      backgroundImage: NetworkImage(
                                          snapshot.data!.avatarUrl),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    snapshot.data!.name,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  const SizedBox(height: 13),
                                  Text(
                                    snapshot.data!.location,
                                    style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 134, 134, 134),
                                        fontSize: 17),
                                  ),
                                ],
                              ))
                        ],
                      )
                    ],
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
    ));
  }
}
