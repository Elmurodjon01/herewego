import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:herewego/views/signIn_view.dart';

import '../services/auth_service.dart';
import '../services/prefs_service.dart';
import '../services/utilities.dart';
import 'main_page.dart';



class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  static String id = 'signuppage';
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}
bool isLoading = false;
TextEditingController nameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passController = TextEditingController();
class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in Page'),
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller:nameController,
                  decoration: const InputDecoration(
                    hintText: 'Full name',
                  ),
                ),
                const SizedBox(height: 10,),
                TextField(
                  controller:emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                ),
                const SizedBox(height: 10,),
                TextField(
                  controller:passController,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                  ),
                ),
                const SizedBox(height: 10,),
                GestureDetector(
                  onTap: _doSignUp,
                  child: Container(
                    color: Colors.blue,
                    width: double.infinity,
                    height: 45,
                    child: const Center(
                      child: Text('Sign Up', style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 45,
                  child: TextButton(
                    onPressed: (){
                      Navigator.pushReplacementNamed(context, SignInPage.id);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text('Already have an account? '),
                        Text('Sign In'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          isLoading ? Center(
            child: CircularProgressIndicator(),
          ) : SizedBox.shrink(),
        ],
      ),
    );
  }
  void _doSignUp(){
    setState(() {
      isLoading = true;
    });
    String email = emailController.text.toString().trim();
    String password = passController.text.toString().trim();
    String name = nameController.text.toString().trim();
    AuthService.signUpUser(context, name, email, password).then((firebaseUser) => {
      _getFireBaseUser(firebaseUser),

    });

  }



  _getFireBaseUser(User? firebaseUser)async {
    setState(() {
      isLoading = false;
    });
    if(firebaseUser != null){
      await Prefs.saveUserId(firebaseUser.uid);
      Navigator.pushReplacementNamed(context, MainPage.id);
    } else{
      Utils.fireToast('Check your information once again!');
    }
  }
}
