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
  MobileScannerController controller = MobileScannerController();
  String? result;
  bool hasPermission = false;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      hasPermission = status.isGranted;
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    // No es necesario para mobile_scanner
  }

  @override
  Widget build(BuildContext context) {
    if (!hasPermission) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Escanear QR'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Se necesita permiso de cámara\npara escanear códigos QR',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () async {
              await controller.toggleTorch();
            },
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_ios),
            onPressed: () async {
              await controller.switchCamera();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: _onDetect,
          ),
          
          // Instrucciones
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Apunta la cámara hacia un código QR\npara obtener 10 Luka Points',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          // Indicador de procesamiento
          if (isProcessing)
            Container(
              color: Colors.black.withOpacity(0.7),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.blue),
                    SizedBox(height: 16),
                    Text(
                      'Procesando QR...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    if (!isProcessing && barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      _processQRCode(barcodes.first.rawValue!);
    }
  }

  Future<void> _processQRCode(String qrData) async {
    if (isProcessing) return;
    
    setState(() {
      isProcessing = true;
    });

    // Pausar la cámara mientras procesamos
    await controller.stop();

    // Simular procesamiento (aquí irías a tu API)
    await Future.delayed(const Duration(seconds: 1));

    // Mostrar resultado exitoso
    _showSuccessDialog(qrData);
  }

  void _showSuccessDialog(String qrData) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Bolsa de compra
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.shopping_bag_rounded,
                    color: Color(0xFF4CAF50),
                    size: 50,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                const Text(
                  '¡Compra Exitosa!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 12),
                
                const Text(
                  'Tu pedido ha sido procesado exitosamente. ¡Disfruta de tus productos!',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 24),
                
                // Botón principal
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Cerrar diálogo
                      Navigator.pop(context, 10); // Volver al home con los puntos
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Ver mi pedido',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Cerrar diálogo
                    setState(() {
                      isProcessing = false;
                    });
                    controller.start(); // Reanudar cámara
                  },
                  child: const Text(
                    'Seguir comprando',
                    style: TextStyle(
                      color: Color(0xFF4CAF50),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}