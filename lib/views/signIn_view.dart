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
                    color: Colors.blue,
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
                        Text('Don\'t have an account? '),
                        Text('Sign Up'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          isLoading?  Center(
            child: CircularProgressIndicator(),
          ): SizedBox.shrink(),
        ],
      ),
    );
  }
  void _doSignin(){
    String email = _emailController.text.toString().trim();
    String password = _passwordController.text.toString().trim();
    if (email.isEmpty || password.isEmpty) return;
    AuthService.signinUser(context, email, password).then((user) => {
      _getFireBaseUser(user!),
    });
    setState(() {
      isLoading = true;
    });
  }
  _getFireBaseUser(User user)async {
    setState(() {
      isLoading = false;
    });
    if(user != null){
      await Prefs.saveUserId(user.uid);
      Navigator.pushReplacementNamed(context, MainPage.id);
    } else{
      Utils.fireToast('Check your email or password once again!');
    }
  }
}
