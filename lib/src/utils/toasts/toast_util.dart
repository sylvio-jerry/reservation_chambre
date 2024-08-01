import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  // Les différentes couleurs pour chaque statut
  static const Map<String, Color> statusColors = {
    'error': Colors.red,
    'success': Colors.green,
    'warning': Colors.orange,
    'info': Colors.blue,
  };

  // Méthode statique pour afficher le toast
  static void showToast({
    required String status,
    required String message,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Toast toastLength = Toast.LENGTH_SHORT,
    int timeInSecForIosWeb = 5,
    Color textColor = Colors.white,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: gravity,
      timeInSecForIosWeb: timeInSecForIosWeb,
      backgroundColor: statusColors[status] ?? Colors.grey,
      textColor: textColor,
    );
  }
}
