import 'package:flutter/material.dart';
import 'package:time_manager_mobile/index/clock.dart';

class PageHome extends StatelessWidget {
  const PageHome({super.key});

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
        body: const Center(
          child: ClockPage(),
        ));
  }
}
