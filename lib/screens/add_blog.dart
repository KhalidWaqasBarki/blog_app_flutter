import 'dart:io';

import 'package:blog_app/components/round_button.dart';
import 'package:blog_app/components/text_component.dart';
import 'package:blog_app/screens/blogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../utils/Utils.dart';

class AddBlog extends StatefulWidget {
  const AddBlog({super.key});

  @override
  State<AddBlog> createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  File? _image;
  final picker = ImagePicker();
  final auth = FirebaseAuth.instance;
  final titleCon = TextEditingController();
  final descriptionCon = TextEditingController();
  final postRef = FirebaseDatabase.instance.ref().child('Blogs');
  final storage = firebase_storage.FirebaseStorage.instance;
  bool showSpinner = false;

  void getCameraImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {});
    if(pickedFile !=null){
      _image = File(pickedFile.path);
    }
  }

  void getGalleryImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {});
    if(pickedFile !=null){
      _image = File(pickedFile.path);
    }
  }

  void dialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.14,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      getCameraImage();
                      Navigator.pop(context);
                    },
                    child: const ListTile(
                      leading: Icon(Icons.camera),
                      title: Text('Camera'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      getGalleryImage();
                      Navigator.pop(context);
                    },
                    child: const ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Gallery'),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
  void uploadBlog()async{
    final user = auth.currentUser;
    showSpinner = true;
    setState(() {});
    try {
      int date = DateTime.now().millisecondsSinceEpoch;
      final ref = firebase_storage.FirebaseStorage.instance.ref('/blogapp$date');
      var uploadTask = ref.putFile(_image!.absolute);
      await Future.value(uploadTask);
      var imageUrl = await ref.getDownloadURL();

      postRef
          .child('Post List')
          .child(date.toString())
          .set({
        'postId' : date.toString(),
        'postImage' : imageUrl.toString(),
        'postTime' : date.toString(),
        'postTitle' : titleCon.text.toString(),
        'postDescription' : descriptionCon.text.toString(),
        'userEmail' : user!.email.toString(),
        'userId' : user.uid.toString(),


      })
          .then((value) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> HomeScreen()));
        Utils().toastmessage('post published');
        showSpinner =false;
        setState(() {

        });

      })
          .onError((error, stackTrace) {
        showSpinner =false;
        setState(() {

        });
        Utils().toastmessage(error.toString());
      });
    } catch (e) {
      showSpinner =false;
      setState(() {});

      Utils().toastmessage(e.toString());
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> HomeScreen()));

    }
  }

  @override
  Widget build(BuildContext context) {


    return ModalProgressHUD(

      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.cyan,
          title: Textt(text: 'Upload Blogs', fontsize: 25),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      dialog(context);
                    },
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(
                                _image!.absolute,
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width: MediaQuery.of(context).size.width * 0.1,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.width * 0.1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade300,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.blueGrey,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                    child: Column(
                  children: [
                    TextFormField(
                      maxLength: 15,
                      controller: titleCon,
                      decoration: InputDecoration(
                        filled: true,
                          fillColor: Colors.grey[50],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          hintText: 'Enter Blog Title',
                          hintStyle: const TextStyle(color: Colors.grey)),
                      validator: (value) {
                        return value!.isEmpty ? 'enter blog title' : null;
                      },
                    ),
                    TextFormField(
                      maxLines: 5,
                      controller: descriptionCon,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[50],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          hintText: 'Enter Blog Description',
                          hintStyle: const TextStyle(color: Colors.grey)),
                      validator: (value) {
                        return value!.isEmpty ? 'enter blog Description' : null;
                      },
                    ),
                  ],
                )),
                const SizedBox(
                  height: 30,
                ),
                RoundButton(
                    title: 'Upload',
                    onpress: () async {
                    uploadBlog();
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
