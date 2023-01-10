import 'package:flutter/material.dart';

Widget priBtn(
    {required String label,
    required Color txtColour,
    required Color bgColour,
    required bool isLoading,
    required void Function()? function}) {
  return Container(
    height: 70,
    padding: const EdgeInsets.symmetric(vertical: 10),
    alignment: Alignment.center,
    child: ElevatedButton(
      onPressed: function,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 70),
        backgroundColor: bgColour,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: (isLoading)
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 1.5,
              ))
          : Text(label,
              style: TextStyle(
                  color: txtColour,
                  fontFamily: 'Nunito',
                  fontSize: 15,
                  fontWeight: FontWeight.w500)),
    ),
  );
}
