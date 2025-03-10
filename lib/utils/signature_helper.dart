import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class SignatureManager {
  /// **Save Signature as a File**
  static Future<String?> saveSignatureImage(Uint8List imageBytes) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png';

      final file = File(filePath);
      await file.writeAsBytes(imageBytes);

      return filePath;
    } catch (e) {
      debugPrint("Error saving signature image: $e");
      return null;
    }
  }

  /// **Upload Signature File**
  static Future<int?> uploadSignature({
    required String filePath,
    required String apiToken,
    required Future<int?> Function(String imagePath, String apiToken) uploadFunction,
  }) async {
    try {
      return await uploadFunction(filePath, apiToken);
    } catch (e) {
      debugPrint("Error uploading signature: $e");
      return null;
    }
  }

  /// **Process & Upload Signature**
  static Future<int?> processAndUploadSignature({
    required Uint8List imageBytes,
    required String apiToken,
    required Future<int?> Function(String imagePath, String apiToken) uploadFunction,
  }) async {
    final filePath = await saveSignatureImage(imageBytes);
    if (filePath == null) return null;

    return await uploadSignature(
      filePath: filePath,
      apiToken: apiToken,
      uploadFunction: uploadFunction,
    );
  }
}