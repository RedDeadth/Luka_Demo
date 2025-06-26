import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart'; // Needed for Clipboard

class GenerateQrCodeScreen extends StatefulWidget {
  const GenerateQrCodeScreen({Key? key}) : super(key: key);

  @override
  State<GenerateQrCodeScreen> createState() => _GenerateQrCodeScreenState();
}

class _GenerateQrCodeScreenState extends State<GenerateQrCodeScreen> {
  final TextEditingController _amountController = TextEditingController();
  int _lukaPointsToEmit = 0;
  bool _qrGenerated = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _generateQr() {
    final String amountText = _amountController.text;
    if (amountText.isNotEmpty) {
      final int? amount = int.tryParse(amountText);
      if (amount != null && amount > 0) {
        setState(() {
          _lukaPointsToEmit = amount;
          _qrGenerated = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, ingresa un número válido y mayor a cero.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa una cantidad.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emitir Lukitas QR'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Ingresa la cantidad de Lukitas a emitir:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Cantidad de Lukitas',
                hintText: 'Ej. 1000',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Image.asset(
                  'assets/images/luka_moneda.png', // Usa tu imagen de moneda Luka
                  width: 24,
                  height: 24,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _generateQr,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Generar QR',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 32),
            if (_qrGenerated)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Escanea este QR para recibir Lukitas',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: QrImageView(
                        data: 'luka_points:$_lukaPointsToEmit', // Data format for QR
                        version: QrVersions.auto,
                        size: 250.0,
                        backgroundColor: Colors.white,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: Colors.black,
                        ),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Cantidad: $_lukaPointsToEmit Lukitas',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            if (!_qrGenerated)
              const Expanded(
                child: Center(
                  child: Text(
                    'Ingresa una cantidad y presiona "Generar QR".',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}