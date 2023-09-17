import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_app/loginpage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final userinfo = ModalRoute.of(context)?.settings?.arguments as Map<String, String>;
    final username = userinfo['username'].toString();

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 330,),
            Text(
              'Welcome, $username',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: (){
                FirebaseAuth.instance.signOut().then((value){
                  print('Logged Out Successfully');
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                });
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
