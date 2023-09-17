import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_app/loginpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {

  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formfield = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final contactnoController = TextEditingController();
  final passwordController = TextEditingController();
  bool passToggle = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Form(
            key: _formfield,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment:  MainAxisAlignment.center,

              children: [
                Image.asset("assets/user_icon.jpg", height: 200, width: 200,),

                const SizedBox(height: 50,),

                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.supervised_user_circle),
                  ),

                  validator: (value){
                    if(value!.isEmpty){
                      return "Enter Name";
                    }
                  },
                ),

                const SizedBox(height: 20,),

                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),

                  validator: (value){
                    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!);

                    if(value!.isEmpty){
                      return "Enter Email";
                    }
                    else if(!emailValid){
                      return "Enter Valid Email";
                    }
                  },
                ),

                const SizedBox(height: 20,),

                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: contactnoController,
                  decoration: const InputDecoration(
                    labelText: "Contact No",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (value){
                    if(value!.isEmpty){
                      return "Enter Contact No";
                    }
                    else if(contactnoController.text.length != 10){
                      return "Please enter valid contact no";
                    }
                  },
                ),

                const SizedBox(height: 20,),

                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: passwordController,
                  obscureText: passToggle,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: InkWell(
                      onTap: (){
                        setState(() {
                          passToggle = !passToggle;
                        });
                      },
                      child: Icon(passToggle ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                  validator: (value){
                    if(value!.isEmpty){
                      return "Enter Password";
                    }
                    else if(passwordController.text.length < 4){
                      return "Password must be of 4 characters";
                    }
                  },
                ),

                const SizedBox(height: 60,),

                InkWell(
                  onTap: (){
                    if(_formfield.currentState!.validate()){
                      print("Success");
                      nameController.clear();
                      emailController.clear();
                      contactnoController.clear();
                      passwordController.clear();
                    }
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(5),
                    ),

                    child: Center(
                      child: ElevatedButton(
                          onPressed: () {
                            // Authentication
                            FirebaseAuth.instance.createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text).then((value){

                                  print('User has been created.');

                                  // Storing User Information to Firebase
                                  CollectionReference collRef = FirebaseFirestore.instance.collection('User-Info');

                                  collRef.add({
                                    'name': nameController.text,
                                    'email_id': emailController.text,
                                    'contact_no': contactnoController.text,
                                    'password': passwordController.text,
                                  });

                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                            }).onError((error, stackTrace){
                              print('Error: ${error}');
                            });

                          },

                          child: Text("Sign Up", style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),)
                      ),
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? ', style: TextStyle(fontSize: 20),),

                    TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                    },
                      child: const Text("Log In", style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      ),),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
