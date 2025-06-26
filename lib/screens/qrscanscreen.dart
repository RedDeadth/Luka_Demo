import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'qr_success_voucher_screen.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({Key? key}) : super(key: key);

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool _isScanning = false;
  bool _isFlashOn = false;
  bool _isFrontCamera = false;
  bool _hasScanned = false; // Prevenir múltiples escaneos

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
            content: Text(
              'Permiso de cámara denegado. Habilítalo en la configuración de la aplicación.',
            ),
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
            content: Text(
              'Permiso de cámara denegado permanentemente. Abre la configuración para habilitarlo.',
            ),
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

  void _processQRCode(String qrData) async {
    if (_hasScanned) return; // Prevenir procesamiento múltiple

    setState(() {
      _hasScanned = true;
    });

    try {
      // Detener la cámara
      await cameraController.stop();

      // Procesar los datos del QR
      int lukaPoints = _extractLukaPoints(qrData);

      if (lukaPoints > 0) {
        // Navegar a la pantalla de éxito
        final result = await Navigator.push<int>(
          context,
          MaterialPageRoute(
            builder:
                (context) => QRSuccessVoucherScreen(
                  lukaPointsEarned: lukaPoints,
                  transactionId: _generateTransactionId(),
                  qrData: qrData,
                ),
          ),
        );

        // Retornar los puntos obtenidos al HomeScreen
        if (mounted) {
          Navigator.of(context).pop(lukaPoints);
        }
      } else {
        // QR inválido
        _showErrorDialog(
          'QR Code inválido',
          'El código QR escaneado no contiene datos válidos de Luka Points.',
        );
      }
    } catch (e) {
      print('Error processing QR: $e');
      _showErrorDialog('Error', 'Ocurrió un error al procesar el código QR.');
    }
  }

  int _extractLukaPoints(String qrData) {
    try {
      // Buscar el patrón "luka_points:" en los datos del QR
      if (qrData.startsWith('luka_points:')) {
        String pointsStr = qrData.substring('luka_points:'.length);
        return int.parse(pointsStr);
      }
      return 0;
    } catch (e) {
      print('Error extracting luka points: $e');
      return 0;
    }
  }

  String _generateTransactionId() {
    final now = DateTime.now();
    return 'TXN${now.millisecondsSinceEpoch}';
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar diálogo
                  Navigator.of(context).pop(); // Volver al HomeScreen
                },
                child: const Text('OK'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar diálogo
                  _restartScanning(); // Reiniciar escaneo
                },
                child: const Text('Escanear otra vez'),
              ),
            ],
          ),
    );
  }

  void _restartScanning() {
    setState(() {
      _hasScanned = false;
    });
    cameraController.start();
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
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
      body: Stack(
        children: [
          // Scanner
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              if (_hasScanned) return; // Prevenir múltiples detecciones

              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final String? scannedValue = barcodes.first.rawValue;
                if (scannedValue != null && scannedValue.isNotEmpty) {
                  print('QR Detected: $scannedValue');
                  _processQRCode(scannedValue);
                }
              }
            },
          ),

          // Overlay con marco de escaneo
          Container(
            decoration: ShapeDecoration(
              shape: QrScannerOverlayShape(
                borderColor: Colors.blue,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 250,
              ),
            ),
          ),

          // Punto central para guía
          Center(
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),

          // Instrucciones
          Positioned(
            bottom: 80,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Coloca el código QR dentro del marco para escanearlo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Clase para crear el overlay del scanner
class QrScannerOverlayShape extends ShapeBorder {
  const QrScannerOverlayShape({
    this.borderColor = Colors.red,
    this.borderWidth = 3.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 0,
    this.borderLength = 40,
    double? cutOutSize,
  }) : cutOutSize = cutOutSize ?? 250;

  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top + borderRadius)
        ..quadraticBezierTo(
          rect.left,
          rect.top,
          rect.left + borderRadius,
          rect.top,
        )
        ..lineTo(rect.right, rect.top);
    }

    return getLeftTopPath(rect)
      ..lineTo(rect.right, rect.bottom)
      ..lineTo(rect.left, rect.bottom)
      ..lineTo(rect.left, rect.top);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final height = rect.height;
    final borderOffset = borderWidth / 2;

    // Centrar el recorte en la pantalla
    final cutOutRect = Rect.fromLTWH(
      rect.left + (width / 2) - (cutOutSize / 2),
      rect.top + (height / 2) - (cutOutSize / 2),
      cutOutSize,
      cutOutSize,
    );

    final backgroundPaint =
        Paint()
          ..color = overlayColor
          ..style = PaintingStyle.fill;

    final backgroundPath =
        Path()
          ..addRect(rect)
          ..addRRect(
            RRect.fromRectAndRadius(cutOutRect, Radius.circular(borderRadius)),
          )
          ..fillType = PathFillType.evenOdd;

    canvas.drawPath(backgroundPath, backgroundPaint);

    final borderPaint =
        Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth;

    final path =
        Path()
          ..moveTo(
            cutOutRect.left - borderOffset,
            cutOutRect.top + borderLength,
          )
          ..lineTo(
            cutOutRect.left - borderOffset,
            cutOutRect.top + borderRadius,
          )
          ..quadraticBezierTo(
            cutOutRect.left - borderOffset,
            cutOutRect.top - borderOffset,
            cutOutRect.left + borderRadius,
            cutOutRect.top - borderOffset,
          )
          ..lineTo(
            cutOutRect.left + borderLength,
            cutOutRect.top - borderOffset,
          );

    canvas.drawPath(path, borderPaint);

    final path2 =
        Path()
          ..moveTo(
            cutOutRect.right + borderOffset,
            cutOutRect.top + borderLength,
          )
          ..lineTo(
            cutOutRect.right + borderOffset,
            cutOutRect.top + borderRadius,
          )
          ..quadraticBezierTo(
            cutOutRect.right + borderOffset,
            cutOutRect.top - borderOffset,
            cutOutRect.right - borderRadius,
            cutOutRect.top - borderOffset,
          )
          ..lineTo(
            cutOutRect.right - borderLength,
            cutOutRect.top - borderOffset,
          );

    canvas.drawPath(path2, borderPaint);

    final path3 =
        Path()
          ..moveTo(
            cutOutRect.right + borderOffset,
            cutOutRect.bottom - borderLength,
          )
          ..lineTo(
            cutOutRect.right + borderOffset,
            cutOutRect.bottom - borderRadius,
          )
          ..quadraticBezierTo(
            cutOutRect.right + borderOffset,
            cutOutRect.bottom + borderOffset,
            cutOutRect.right - borderRadius,
            cutOutRect.bottom + borderOffset,
          )
          ..lineTo(
            cutOutRect.right - borderLength,
            cutOutRect.bottom + borderOffset,
          );

    canvas.drawPath(path3, borderPaint);

    final path4 =
        Path()
          ..moveTo(
            cutOutRect.left - borderOffset,
            cutOutRect.bottom - borderLength,
          )
          ..lineTo(
            cutOutRect.left - borderOffset,
            cutOutRect.bottom - borderRadius,
          )
          ..quadraticBezierTo(
            cutOutRect.left - borderOffset,
            cutOutRect.bottom + borderOffset,
            cutOutRect.left + borderRadius,
            cutOutRect.bottom + borderOffset,
          )
          ..lineTo(
            cutOutRect.left + borderLength,
            cutOutRect.bottom + borderOffset,
          );

    canvas.drawPath(path4, borderPaint);
  }

  @override
  ShapeBorder scale(double t) {
    return QrScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
    );
  }
}
