import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:herewego/views/signUp_view.dart';

import '../services/auth_service.dart';
import '../services/prefs_service.dart';
import '../services/utilities.dart';
import 'main_page.dart';
class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);
  static String id = 'signinpage';
  @override
  State<SignInPage> createState() => _SignInPageState();
}
bool isLoading = false;
TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller:_emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                ),
                const SizedBox(height: 10,),
                TextField(
                  controller:_passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                  ),
                ),
                const SizedBox(height: 10,),
                GestureDetector(
                  onTap: _doSignin,
                  child: Container(
                    color: Colors.red,
                    width: double.infinity,
                    height: 45,
                    child: const Center(
                      child: Text('Sign In', style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 45,
                  child: TextButton(
                    onPressed: (){
                      Navigator.pushReplacementNamed(context, SignUpPage.id);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text('Don\'t have an account? ', style: TextStyle(color: Colors.black),),
                        Text('Sign Up', style: TextStyle(color: Colors.black),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          isLoading?  const Center(
            child: CircularProgressIndicator(),
          ): const SizedBox.shrink(),
        ],
      ),
    );
  }
  void _doSignin(){
    String email = _emailController.text.toString().trim();
    String password = _passwordController.text.toString().trim();
    if (email.isEmpty || password.isEmpty) return;
    AuthService.signinUser(context, email, password).then((firebaseUser) => {
      _getFireBaseUser(firebaseUser),
    });
    setState(() {
      isLoading = true;
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
      Utils.fireToast('Check your email or password once again!');
    }
  }
}
