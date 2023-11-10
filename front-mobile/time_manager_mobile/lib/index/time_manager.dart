import 'package:flutter/material.dart';
import 'package:time_manager_mobile/api/working_time_service.dart';
import 'package:time_manager_mobile/storage/local_storage.dart';

// ignore: must_be_immutable
class PageTimeManager extends StatelessWidget {
  PageTimeManager({super.key});
  SecureStorageService secureStorageService = SecureStorageService();
  List<dynamic> workingTimes = [];

  Future<List<dynamic>> getWorkingTimes() async {
    String? xsrfToken = await secureStorageService.getXSRF();
    String? token = await secureStorageService.getToken();
    String? userId = await secureStorageService.getUserId();
    if (xsrfToken != null && token != null && userId != null) {
      await WorkingTimeService.getWorkingTime(xsrfToken, token, userId)
          .then((value) => workingTimes = value);
    }
    return workingTimes;
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
            future: Future.wait([getWorkingTimes()]),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                return workingTimes.isEmpty
                    ? const Center(
                        child: Text(
                          "No recorded times yet",
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Start",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "End",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                                children: List.generate(
                                    workingTimes.length,
                                    (index) => Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          margin:
                                              const EdgeInsets.only(top: 10.0),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 15),
                                          height: 50,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(workingTimes[index]
                                                    ['start']),
                                                Text(
                                                    workingTimes[index]['end']),
                                              ]),
                                        ))),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      );
              }
            },
          ),
        ),
      ]),
    );
  }
}
