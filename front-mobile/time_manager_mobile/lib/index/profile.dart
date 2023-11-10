import 'package:flutter/material.dart';
import 'package:time_manager_mobile/index/authentification.dart';
import 'package:time_manager_mobile/storage/local_storage.dart';

class PageProfile extends StatefulWidget {
  const PageProfile({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PageProfileState createState() => _PageProfileState();
}

class _PageProfileState extends State<PageProfile> {
  SecureStorageService secureStorageService = SecureStorageService();

  void logOut() {
    secureStorageService.clearData();

    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => LoginSignupPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 92, 153, 163),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 145, 188, 194),
        title: const Text('Time Manager'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: logOut,
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.logout,
          color: Color.fromARGB(255, 92, 153, 163),
          size: 28,
        ),
      ),
      body: Stack(children: [
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
          top: 350,
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
          child: FutureBuilder(
            future: Future.wait([
              secureStorageService.getUsername(),
              secureStorageService.getEmail(),
            ]),
            builder: (context, AsyncSnapshot<List<String?>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasData) {
                String username = snapshot.data![0]!;
                String email = snapshot.data![1]!;
                return Center(
                  child: Container(
                    height: 350,
                    margin: const EdgeInsets.all(20.0),
                    padding: const EdgeInsets.all(16.0),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 20),
                        const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'User informations',
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                'Username:',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    hintText: 'Username',
                                    border: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                  enabled: false,
                                  initialValue: username,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              const Text(
                                'Email:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 15.0),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    hintText: 'Email adress',
                                    border: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                  enabled: false,
                                  initialValue: email,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ]),
    );
  }
}
