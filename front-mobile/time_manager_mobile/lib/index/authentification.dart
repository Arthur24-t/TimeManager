import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:time_manager_mobile/api/user_service.dart';
import 'package:time_manager_mobile/main.dart';
import 'package:time_manager_mobile/storage/local_storage.dart';

class LoginSignupPage extends StatefulWidget {
  @override
  _LoginSignupPageState createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  SecureStorageService secureStorageService = SecureStorageService();
  bool _isLoginForm = true;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void _registerUser() {
      Map<String, dynamic> data = {
        'user': {
          'username': usernameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'role': 'user',
        }
      };
      UserService.createUser(secureStorageService, data).then((response) {
        String token = response['token'];
        String idUser = response['user']['id'];
        String username = response['user']['username'];
        String email = response['user']['email'];
        secureStorageService.writeToken(token);
        secureStorageService.writeUserId(idUser);
        secureStorageService.writeUsername(username);
        secureStorageService.writeEmail(email);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const MyBottomNavigationBar()));
      }).catchError((error) {
        print('Erreur lors de la création de l\'utilisateur: $error');
      });
    }

    void _loginUser() async {
      Map<String, dynamic> data = {
        'user': {
          'email': emailController.text,
          'password': passwordController.text,
        }
      };
      await UserService.loginUser(secureStorageService, data).then((response) {
        String token = response['token'];
        String idUser = response['user']['id'];
        String username = response['user']['username'];
        String email = response['user']['email'];
        secureStorageService.writeToken(token);
        secureStorageService.writeUserId(idUser);
        secureStorageService.writeUsername(username);
        secureStorageService.writeEmail(email);
        //print(secureStorageService.getEmail());
        //print(secureStorageService.getUsername());
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const MyBottomNavigationBar()));
      }).catchError((error) {
        print('Erreur lors de la connexion de l\'utilisateur: $error');
      });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 92, 153, 163),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 145, 188, 194),
        title: const Text('Time Manager'),
        centerTitle: true,
      ),
      body: Sizer(
        builder: (context, orientation, deviceType) {
          return Stack(children: [
            Positioned(
              top: 30,
              left: -50,
              child: Transform.rotate(
                angle: 0.7,
                child: Container(
                  width: 200,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color.fromARGB(
                        255, 145, 188, 194), // Couleur du premier carré
                  ),
                ),
              ),
            ),
            Positioned(
              top: 450,
              left: 250,
              child: Transform.rotate(
                angle: 0.9,
                child: Container(
                  width: 200,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color.fromARGB(
                        255, 145, 188, 194), // Couleur du premier carré
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                height: _isLoginForm ? 58.h : 68.h,
                padding: EdgeInsets.all(5.w),
                margin: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(
                        height: 30,
                      ),
                      _isLoginForm
                          ? Text(
                              "Login to your account",
                              style: TextStyle(fontSize: 3.h),
                            )
                          : Text("Create an account",
                              style: TextStyle(fontSize: 3.h)),
                      SizedBox(
                        height: 3.h,
                      ),
                      if (!_isLoginForm)
                        TextFormField(
                          controller: usernameController,
                          decoration:
                              const InputDecoration(labelText: 'Username'),
                        ),
                      SizedBox(
                        height: 1.h,
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      TextFormField(
                        controller: passwordController,
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: 400,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 92, 153,
                                163), // Couleur de fond personnalisée
                          ),
                          child: Text(_isLoginForm ? 'Log in' : 'Register'),
                          onPressed: () {
                            _isLoginForm ? _loginUser() : _registerUser();
                          },
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isLoginForm = !_isLoginForm;
                          });
                        },
                        child: Text(
                          _isLoginForm ? 'Register' : 'Log in',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 92, 153, 163)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }
}
