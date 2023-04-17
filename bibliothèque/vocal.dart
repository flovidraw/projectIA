import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VocalPage extends StatefulWidget {
  @override
  _VocalPageState createState() => _VocalPageState();
}

class _VocalPageState extends State<VocalPage> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = '';

  @override
  void initState() {
    super.initState();
    _initSpeechRecognizer();
  }

  void _initSpeechRecognizer() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('onStatus: $status'),
      onError: (error) => print('onError: $error'),
    );

    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) => setState(() {
          _text = result.recognizedWords;
        }),
      );
    } else {
      print('The user has denied the use of speech recognition.');
    }
  }

  void _stopSpeechRecognizer() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vocal Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Start listening'),
              onPressed: () {
                if (!_isListening) {
                  _initSpeechRecognizer();
                }
              },
            ),
            ElevatedButton(
              child: Text('Stop listening'),
              onPressed: _isListening ? _stopSpeechRecognizer : null,
            ),
            Text(_text),
          ],
        ),
      ),
    );
  }
}