import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:medi_remind_app/features/medication/data/models/medication_model.dart';

class PrescriptionScannerPage extends StatefulWidget {
  const PrescriptionScannerPage({super.key});

  @override
  State<PrescriptionScannerPage> createState() =>
      _PrescriptionScannerPageState();
}

class _PrescriptionScannerPageState extends State<PrescriptionScannerPage> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isProcessing = false;
  final TextRecognizer _textRecognizer = GoogleMlKit.vision.textRecognizer();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _cameraController = CameraController(
        _cameras![0],
        ResolutionPreset.high,
        enableAudio: false,
      );
      await _cameraController!.initialize();
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Prescription'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: _pickFile,
            tooltip: 'Upload File',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildCameraPreview()),
          _buildControlButtons(),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        CameraPreview(_cameraController!),
        if (_isProcessing)
          Container(
            color: Colors.black54,
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Processing prescription...',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        Positioned(
          top: 20,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Position the prescription within the frame and tap the capture button',
              style: TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildControlButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: _takePicture,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.camera),
          ),
          FloatingActionButton(
            onPressed: _pickFile,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: const Icon(Icons.upload_file),
          ),
        ],
      ),
    );
  }

  Future<void> _takePicture() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final XFile image = await _cameraController!.takePicture();
      await _processImage(File(image.path));
    } catch (e) {
      _showError('Failed to capture image: $e');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);
        await _processImage(file);
      }
    } catch (e) {
      _showError('Failed to pick file: $e');
    }
  }

  Future<void> _processImage(File imageFile) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final inputImage = InputImage.fromFile(imageFile);
      final RecognizedText recognizedText = await _textRecognizer.processImage(
        inputImage,
      );

      // Parse the recognized text to extract medication information
      final medications = _parsePrescriptionText(recognizedText.text);

      if (medications.isNotEmpty) {
        // Navigate back with the detected medications
        Navigator.of(context).pop(medications);
      } else {
        _showError(
          'No medication information found in the image. Please try again.',
        );
      }
    } catch (e) {
      _showError('Failed to process image: $e');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  List<Medication> _parsePrescriptionText(String text) {
    // This is a basic implementation. In a real app, you'd use more sophisticated
    // NLP and pattern matching to extract medication information accurately.

    List<Medication> medications = [];
    List<String> lines = text.split('\n');

    // Simple pattern matching for common medication formats
    for (String line in lines) {
      line = line.trim();
      if (line.isEmpty) continue;

      // Look for patterns like "Medication Name 50mg" or "Drug 25mg twice daily"
      RegExp medPattern = RegExp(
        r'([A-Za-z\s]+)\s+(\d+(?:\.\d+)?\s*(?:mg|g|ml|mcg|units?))\s*(.*)?',
      );
      Match? match = medPattern.firstMatch(line);

      if (match != null) {
        String name = match.group(1)?.trim() ?? '';
        String dosage = match.group(2)?.trim() ?? '';
        String additionalInfo = match.group(3)?.trim() ?? '';

        // Extract frequency information
        String frequency = 'Once daily'; // default
        if (additionalInfo.toLowerCase().contains('twice') ||
            additionalInfo.toLowerCase().contains('2x')) {
          frequency = 'Twice daily';
        } else if (additionalInfo.toLowerCase().contains('three') ||
            additionalInfo.toLowerCase().contains('3x')) {
          frequency = 'Three times daily';
        }

        // Extract time information (basic implementation)
        TimeOfDay time = TimeOfDay.now();
        if (additionalInfo.toLowerCase().contains('morning') ||
            additionalInfo.toLowerCase().contains('am')) {
          time = const TimeOfDay(hour: 8, minute: 0);
        } else if (additionalInfo.toLowerCase().contains('evening') ||
            additionalInfo.toLowerCase().contains('pm')) {
          time = const TimeOfDay(hour: 20, minute: 0);
        }

        medications.add(
          Medication(
            id:
                DateTime.now().millisecondsSinceEpoch.toString() +
                medications.length.toString(),
            name: name,
            dosage: dosage,
            frequency: frequency,
            time: time,
            times: [time],
            startDate: DateTime.now(),
            notes: additionalInfo.isNotEmpty ? additionalInfo : null,
          ),
        );
      }
    }

    return medications;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
