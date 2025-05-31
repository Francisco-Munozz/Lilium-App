import 'package:flutter/material.dart';
import 'package:lilium_app/theme/theme.dart';
import 'package:lilium_app/screens/screens.dart';
import 'package:lilium_app/widgets/widgets.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';

class GrabacionManualScreen extends StatefulWidget {
  const GrabacionManualScreen({super.key});

  @override
  State<GrabacionManualScreen> createState() => _GrabacionManualScreenState();
}

class _GrabacionManualScreenState extends State<GrabacionManualScreen> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  double _progress = 0;
  int _seconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    await Permission.microphone.request();
    await _recorder.openRecorder();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recorder.closeRecorder();
    super.dispose();
  }

  void _startRecording() async {
    try {
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/grabacion_temp.aac';

      await _recorder.startRecorder(toFile: filePath, codec: Codec.aacADTS);

      setState(() {
        _isRecording = true;
        _seconds = 0;
        _progress = 0;
      });

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _seconds++;
          _progress = _seconds / 33;
        });

        if (_seconds >= 30) {
          _stopRecording();
        }
      });
    } catch (e) {
      print("Error al iniciar la grabación: $e");
    }
  }

  void _stopRecording() async {
    await _recorder.stopRecorder();
    _timer?.cancel();
    setState(() {
      _isRecording = false;
      _progress = 0;
      _seconds = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenAncho = MediaQuery.of(context).size.width;
    double screenAlto = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Grabación manual"),
        backgroundColor: const Color(0xFFFFFBF1),
        elevation: 0,
        foregroundColor: Colors.black,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade300, height: 1.0),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: screenAlto * 0.38),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "${_seconds ~/ 60}:${(_seconds % 60).toString().padLeft(2, '0')}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Container(
                    width: screenAncho * 0.7,
                    height: screenAlto * 0.05,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBF1),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Stack(
                      children: [
                        Container(
                          width: screenAncho * 0.7 * _progress,
                          height: screenAlto * 0.03,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 180, 248, 200),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenAlto * 0.2),
            GestureDetector(
              onTap: _isRecording ? null : _startRecording,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _isRecording ? screenAncho * 0.23 : screenAncho * 0.2841,
                height: _isRecording ? screenAlto * 0.1148 : screenAlto * 0.13,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width:
                            _isRecording
                                ? screenAncho * 0.19
                                : screenAncho * 0.24,
                        height:
                            _isRecording
                                ? screenAlto * 0.09
                                : screenAlto * 0.1148,
                        decoration: BoxDecoration(
                          color: const Color(0xFFB4F8C8),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      const Icon(
                        Icons.mic_rounded,
                        size: 40, // Tamaño fijo del ícono
                        color: Color.fromARGB(255, 120, 220, 146),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
