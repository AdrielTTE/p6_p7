import 'dart:io';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Practical 6 & 7 Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Login Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> _loadProfile() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      emailController.text = prefs.getString('email')?? "";
      passwordController.text = prefs.getString('password') ?? "";

      if (emailController.text != "" && passwordController.text != ""){
        rememberMe = true;
      }
    });
  }

  Future<void> _clearProfile() async{
    final prefs = await SharedPreferences.getInstance();
        setState((){
          prefs.remove('password');
          prefs.remove('email');
        }

        );
  }

  Future<void> _saveProfile() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('email', emailController.text);
      prefs.setString('password', passwordController.text);
    });
  }


  Future<void> _updateProfile() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('name', emailController.text);
      prefs.setString('email', passwordController.text);
    });
  }

  @override
  void initState() {
    _loadProfile();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Form(
        key:_formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value){
                if (value== null || value.isEmpty){
                  return 'Email is required';
                } else {
                  return null;
                }

              },
            ),

            SizedBox(height: 16),

            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
              validator: (value){
                if (value== null || value.isEmpty){
                  return 'Password is required';
                } else {
                  return null;
                }

              },
            ),

            SizedBox(height: 16),

            Row(
              children: [
                Checkbox(
                  value: rememberMe,
                  onChanged: (bool? value) {
                    setState(() {
                      rememberMe = value ?? false;
                    });
                  },
                ),
                Text('Remember me'),
              ],
            ),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                ElevatedButton(onPressed: () {
                  if(_formKey.currentState!.validate()){


                    if(rememberMe){
                      _updateProfile();
                      _saveProfile();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profile info saved.'),
                        ),
                      );
                    } else{
                      _clearProfile();
                    }

                  }
                }, child: Text('Login')),

                ElevatedButton(
                  onPressed: () {
                    exit(0);
                  },
                  child: Text('Exit'),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
