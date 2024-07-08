import 'package:blog_app/components/text_component.dart';
import 'package:blog_app/screens/add_blog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import '../utils/Utils.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbRef = FirebaseDatabase.instance.ref().child('Blogs');
  final auth = FirebaseAuth.instance;
  final searchCon = TextEditingController();

  void logout() {
    auth.signOut().then((value) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }).onError((error, stackTrace) {
      Utils().toastmessage(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Textt(text: 'Blogs', fontsize: 25),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.cyan,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const AddBlog()));
              },
              icon: const Icon(Icons.add_sharp)),
          SizedBox(
            width: 15,
          ),
          IconButton(
              onPressed: () {
                logout();
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: searchCon,
              decoration: InputDecoration(
                fillColor: Colors.grey[50],
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  hintText: 'Search blogs'),
              onChanged: (value) {
                setState(() {}); // Trigger rebuild to apply search filter
              },
            ),
            SizedBox(height: 10),
            Expanded(
              child: FirebaseAnimatedList(
                query: dbRef.child('Post List'),
                itemBuilder: (context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  if (snapshot.value == null || snapshot.value is! Map) {
                    return Container(); // Return an empty container or any placeholder widget
                  }

                  Map<String, dynamic> data =
                  Map<String, dynamic>.from(snapshot.value as Map);

                  if (searchCon.text.isEmpty ||
                      data['postTitle']
                          .toString()
                          .toLowerCase()
                          .contains(searchCon.text.toLowerCase())) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: FadeInImage.assetNetwork(
                              height: MediaQuery.of(context).size.height * 0.4,
                              placeholder: 'images/placeholder.png',
                              image: data['postImage'] ?? 'images/default.png',
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Textt(text: 'Title: ', fontsize: 15),
                            Text(
                              data['postTitle'],
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                        
                          children: [
                            Textt(text: 'Description: ', fontsize: 15),
                            Flexible(
                              child: Text(
                                data['postDescription'],
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return Container(); // Return an empty container if search doesn't match
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
