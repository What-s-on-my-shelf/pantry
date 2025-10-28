import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pantry/screens/add_item_screen.dart'; // Make sure this path is correct

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({Key? key}) : super(key: key);

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );
  bool _isScanProcessing = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Barcode'),
        backgroundColor: Colors.grey[900],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              if (_isScanProcessing) return; // Don't process multiple scans
              setState(() {
                _isScanProcessing = true;
              });

              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final String code = barcodes.first.rawValue ?? "Error scanning";
                
                // IMPORTANT: Stop the camera *before* navigating
                controller.stop(); 

                // Navigate to AddItemScreen and pass the barcode
                Navigator.of(context).pop(); // Close this scanner screen
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => AddItemScreen(barcode: code), // Pass barcode
                  ),
                );
              }
            },
          ),
          // Simple overlay to guide the user
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red.withOpacity(0.7), width: 4),
              borderRadius: BorderRadius.circular(12),
            ),
            width: 250,
            height: 150,
          ),
        ],
      ),
    );
  }
}