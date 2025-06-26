import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({Key? key}) : super(key: key);

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool _isScanning = false;
  bool _isFlashOn = false; // Track flash state manually
  bool _isFrontCamera = false; // Track camera facing manually

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      if (mounted) {
        setState(() {
          _isScanning = true;
        });
      }
    } else if (status.isDenied) {
      print("Camera permission denied");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permiso de cámara denegado. Habilítalo en la configuración de la aplicación.'),
            duration: Duration(seconds: 5),
          ),
        );
        Navigator.of(context).pop();
      }
    } else if (status.isPermanentlyDenied) {
      print("Camera permission permanently denied. Opening app settings.");
      openAppSettings();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permiso de cámara denegado permanentemente. Abre la configuración para habilitarlo.'),
            duration: Duration(seconds: 5),
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _toggleFlash() async {
    try {
      await cameraController.toggleTorch();
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
    } catch (e) {
      print('Error toggling flash: $e');
    }
  }

  Future<void> _switchCamera() async {
    try {
      await cameraController.switchCamera();
      setState(() {
        _isFrontCamera = !_isFrontCamera;
      });
    } catch (e) {
      print('Error switching camera: $e');
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isScanning) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Verificando permisos de cámara...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR'),
        backgroundColor: Colors.blue,
        actions: [
          // Flashlight button
          IconButton(
            color: Colors.white,
            icon: Icon(
              _isFlashOn ? Icons.flash_on : Icons.flash_off,
              color: _isFlashOn ? Colors.yellow : Colors.grey,
            ),
            onPressed: _toggleFlash,
          ),
          // Camera facing button
          IconButton(
            color: Colors.white,
            icon: Icon(
              _isFrontCamera ? Icons.camera_front : Icons.camera_rear,
              color: Colors.white,
            ),
            onPressed: _switchCamera,
          ),
        ],
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final String? scannedValue = barcodes.first.rawValue;
            if (scannedValue != null) {
              // Stop scanning immediately after a successful scan
              cameraController.stop();
              // Return the scanned string value to the previous screen
              Navigator.of(context).pop(scannedValue);
            }
          }
        },
      ),
    );
  }
}