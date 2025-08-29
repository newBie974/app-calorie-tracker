import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController controller = MobileScannerController();
  String scannedCode = '';
  bool isScanning = true;
  bool isLoading = false;
  Map<String, dynamic>? productData;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Camera permission required for QR scanning')),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    if (isScanning && barcodes.isNotEmpty) {
      final barcode = barcodes.first.rawValue;
      if (barcode != null) {
        setState(() {
          isScanning = false;
          scannedCode = barcode;
        });
        controller.stop();
        _fetchProductInfo(barcode);
      }
    }
  }

  Future<void> _fetchProductInfo(String barcode) async {
    setState(() {
      isLoading = true;
    });

    try {
      final dio = Dio();
      final response = await dio.get(
        'https://world.openfoodfacts.org/api/v0/product/$barcode.json',
      );

      if (response.data['status'] == 1) {
        setState(() {
          productData = response.data['product'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        _showProductNotFound();
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showError('Failed to fetch product information');
    }
  }

  void _showProductNotFound() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product not found in database')),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _resetScanner() {
    setState(() {
      isScanning = true;
      isLoading = false;
      productData = null;
      scannedCode = '';
    });
    controller.start();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scan Product',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        actions: [
          if (productData != null)
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: _resetScanner,
            ),
        ],
      ),
      body: Column(
        children: [
          if (isScanning) ...[
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  MobileScanner(
                    controller: controller,
                    onDetect: _onDetect,
                  ),
                  // Scanner overlay
                  Container(
                    decoration: ShapeDecoration(
                      shape: QrScannerOverlayShape(
                        borderColor: theme.colorScheme.primary,
                        borderRadius: 12,
                        borderLength: 30,
                        borderWidth: 4,
                        cutOutSize: 250,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.qr_code_scanner_rounded,
                      size: 32,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Scan a product barcode',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Point your camera at the barcode',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (isLoading) ...[
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Fetching product information...',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (productData != null) ...[
            Expanded(
              child: _buildProductInfo(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProductInfo() {
    final product = productData!;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          if (product['image_url'] != null)
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withAlpha(26),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: product['image_url'],
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 200,
                      width: 200,
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.image_not_supported_rounded,
                        size: 50,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 24),

          // Product Name
          Text(
            product['product_name'] ?? 'Unknown Product',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),

          // Brand
          if (product['brands'] != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                product['brands'],
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          const SizedBox(height: 20),

          // Nutrition Facts
          if (product['nutriments'] != null) ...[
            Text(
              'Nutrition Facts (per 100g)',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            _buildNutritionCard(),
            const SizedBox(height: 20),
          ],

          // Ingredients
          if (product['ingredients_text'] != null) ...[
            Text(
              'Ingredients',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                product['ingredients_text'],
                style: GoogleFonts.inter(
                  fontSize: 14,
                  height: 1.5,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Added ${product['product_name'] ?? 'Product'} to food diary',
                          style: GoogleFonts.inter(),
                        ),
                        backgroundColor: theme.colorScheme.primary,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: Text(
                    'Add to Diary',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _resetScanner,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.primary,
                    side: BorderSide(color: theme.colorScheme.primary),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.qr_code_scanner_rounded, size: 20),
                  label: Text(
                    'Scan Another',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionCard() {
    final nutrients = productData!['nutriments'];
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withAlpha(51),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildNutrientRow(
              'Calories', '${nutrients['energy-kcal_100g'] ?? 0}', 'kcal'),
          _buildNutrientRow(
              'Protein', '${nutrients['proteins_100g'] ?? 0}', 'g'),
          _buildNutrientRow(
              'Carbs', '${nutrients['carbohydrates_100g'] ?? 0}', 'g'),
          _buildNutrientRow('Fat', '${nutrients['fat_100g'] ?? 0}', 'g'),
          _buildNutrientRow('Fiber', '${nutrients['fiber_100g'] ?? 0}', 'g'),
          _buildNutrientRow('Sugar', '${nutrients['sugars_100g'] ?? 0}', 'g'),
          _buildNutrientRow('Sodium', '${nutrients['sodium_100g'] ?? 0}', 'mg'),
        ],
      ),
    );
  }

  Widget _buildNutrientRow(String name, String value, String unit) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface,
            ),
          ),
          Text(
            '$value $unit',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class QrScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final Color? overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  const QrScannerOverlayShape({
    this.borderColor = Colors.red,
    this.borderWidth = 3.0,
    this.overlayColor,
    this.borderRadius = 0,
    this.borderLength = 40,
    required this.cutOutSize,
  });

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
    Path path = Path();
    final innerPath = Path();
    final outerPath = Path();

    outerPath.addRect(rect);

    final center = rect.center;
    final cutOutRect = Rect.fromCenter(
      center: center,
      width: cutOutSize,
      height: cutOutSize,
    );

    innerPath.addRRect(
      RRect.fromRectAndRadius(cutOutRect, Radius.circular(borderRadius)),
    );

    path.fillType = PathFillType.evenOdd;
    path.addPath(outerPath, Offset.zero);
    path.addPath(innerPath, Offset.zero);

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final center = rect.center;
    final cutOutRect = Rect.fromCenter(
      center: center,
      width: cutOutSize,
      height: cutOutSize,
    );

    final paint = Paint()
      ..color = overlayColor ?? const Color.fromRGBO(0, 0, 0, 80)
      ..style = PaintingStyle.fill;

    final outerPath = Path()..addRect(rect);
    final innerPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(cutOutRect, Radius.circular(borderRadius)),
      );

    final overlayPath =
        Path.combine(PathOperation.difference, outerPath, innerPath);
    canvas.drawPath(overlayPath, paint);

    // Draw corner borders
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    _drawCornerBorders(canvas, cutOutRect, borderPaint);
  }

  void _drawCornerBorders(Canvas canvas, Rect rect, Paint paint) {
    // Top-left corner
    canvas.drawPath(
      Path()
        ..moveTo(rect.left, rect.top + borderLength)
        ..lineTo(rect.left, rect.top + borderRadius)
        ..quadraticBezierTo(
            rect.left, rect.top, rect.left + borderRadius, rect.top)
        ..lineTo(rect.left + borderLength, rect.top),
      paint,
    );

    // Top-right corner
    canvas.drawPath(
      Path()
        ..moveTo(rect.right - borderLength, rect.top)
        ..lineTo(rect.right - borderRadius, rect.top)
        ..quadraticBezierTo(
            rect.right, rect.top, rect.right, rect.top + borderRadius)
        ..lineTo(rect.right, rect.top + borderLength),
      paint,
    );

    // Bottom-left corner
    canvas.drawPath(
      Path()
        ..moveTo(rect.left, rect.bottom - borderLength)
        ..lineTo(rect.left, rect.bottom - borderRadius)
        ..quadraticBezierTo(
            rect.left, rect.bottom, rect.left + borderRadius, rect.bottom)
        ..lineTo(rect.left + borderLength, rect.bottom),
      paint,
    );

    // Bottom-right corner
    canvas.drawPath(
      Path()
        ..moveTo(rect.right - borderLength, rect.bottom)
        ..lineTo(rect.right - borderRadius, rect.bottom)
        ..quadraticBezierTo(
            rect.right, rect.bottom, rect.right, rect.bottom - borderRadius)
        ..lineTo(rect.right, rect.bottom - borderLength),
      paint,
    );
  }

  @override
  ShapeBorder scale(double t) => QrScannerOverlayShape(
        borderColor: borderColor,
        borderWidth: borderWidth,
        overlayColor: overlayColor,
        borderRadius: borderRadius,
        borderLength: borderLength,
        cutOutSize: cutOutSize,
      );
}
