import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:time_manager_mobile/api/clock_service.dart';
import 'package:time_manager_mobile/api/working_time_service.dart';
import 'package:time_manager_mobile/storage/local_storage.dart';

class ClockPage extends StatefulWidget {
  const ClockPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ClockPageState createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  bool _isButtonVisible = true;
  bool isConnect = true;
  DateTime startDateTime = DateTime(0);
  late Timer _timer;
  late DateTime _currentTime;
  int _seconds = 0;
  bool _isTicking = false;
  SecureStorageService secureStorageService = SecureStorageService();

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime(0).add(Duration(seconds: _seconds));
    _updateConnectionStatus();
  }

  void _updateConnectionStatus() async {
    bool isConnected = await _isConnected();
    setState(() {
      isConnect = isConnected;
      _isButtonVisible = true;
    });
    Timer(const Duration(seconds: 3), () {
      setState(() {
        _isButtonVisible = false;
      });
    });
  }

  Future<bool> _isConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
  }

  void _saveTimeData(bool status) async {
    bool isConnected = await _isConnected();
    List<dynamic>? timeData = await secureStorageService.getTimeData();
    DateTime now = DateTime.now();
    dynamic clockData = {
      'clock': {
        'time': now.toString(),
        'status': status,
      }
    };
    String? xsrfToken = await secureStorageService.getXSRF();
    String? token = await secureStorageService.getToken();
    String? userId = await secureStorageService.getUserId();

    if (isConnected) {
      if (timeData.isNotEmpty) {
        for (var time in timeData) {
          if (xsrfToken != null && token != null && userId != null) {
            await ClockService.createClock(time, xsrfToken, token, userId);
          }
        }
        for (var i = 0; i < timeData.length; i = i + 2) {
          Map<String, Map<String, Object>> workingTimeData = {
            'working_time': {
              'start': timeData[i]['clock']['time'],
              'end': timeData[i + 1]['clock']['time'],
            }
          };
          if (xsrfToken != null && token != null && userId != null) {
            await WorkingTimeService.createWorkingTime(
                workingTimeData, xsrfToken, token, userId);
          }
        }
      }
      secureStorageService.clearTimeData();
      if (xsrfToken != null && token != null && userId != null) {
        await ClockService.createClock(clockData, xsrfToken, token, userId);
      }
    } else {
      timeData.add(clockData);
      secureStorageService.writeTimeData(timeData);
    }
  }

  void _startClock() {
    startDateTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
        _currentTime = DateTime(0).add(Duration(seconds: _seconds));
      });
    });
    setState(() {
      _isTicking = true;
      _saveTimeData(true);
    });
  }

  void _stopClock() async {
    _timer.cancel();
    setState(() {
      _isTicking = false;
      _seconds = 0;
      _currentTime = DateTime(0).add(Duration(seconds: _seconds));
      _saveTimeData(false);
    });
    String? xsrfToken = await secureStorageService.getXSRF();
    String? token = await secureStorageService.getToken();
    String? userId = await secureStorageService.getUserId();
    final workingTimeData = {
      'working_time': {
        'start': startDateTime.toString(),
        'end': DateTime.now().toString(),
      }
    };
    if (xsrfToken != null && token != null && userId != null) {
      await WorkingTimeService.createWorkingTime(
          workingTimeData, xsrfToken, token, userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      floatingActionButton: _isButtonVisible
          ? SizedBox(
              height: 8.h,
              width: 75.w,
              child: RawMaterialButton(
                onPressed: _updateConnectionStatus,
                elevation: 2.0,
                fillColor: isConnect ? Colors.green : Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isConnect
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 30,
                          )
                        : const Icon(
                            Icons.offline_bolt,
                            color: Colors.white,
                            size: 30,
                          ),
                    const SizedBox(width: 20),
                    Text(
                      isConnect ? 'You are connected' : 'You are offline',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            )
          : null,
      backgroundColor: const Color.fromARGB(255, 92, 153, 163),
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
              child: Container(
                height: 50.h,
                padding: EdgeInsets.all(3.w),
                margin: EdgeInsets.all(3.w),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _isTicking
                        ? const Text(
                            "Clock out",
                            style: TextStyle(fontSize: 30),
                          )
                        : const Text(
                            "Clock in",
                            style: TextStyle(fontSize: 30),
                          ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      '${_currentTime.hour.toString().padLeft(2, '0')} : ${_currentTime.minute.toString().padLeft(2, '0')} : ${_currentTime.second.toString().padLeft(2, '0')}',
                      style: TextStyle(fontSize: 10.w),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        backgroundColor:
                            const Color.fromARGB(255, 92, 153, 163),
                      ),
                      onPressed: _isTicking ? _stopClock : _startClock,
                      child: Text(
                        _isTicking ? 'Stop' : 'Start',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }
}
