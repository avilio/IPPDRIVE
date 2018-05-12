import 'package:flutter/material.dart';


Widget buildTextField(String label, TextEditingController controller, bool isPassword){

  return TextField(
    controller: controller,
    decoration:  InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
    ),
    obscureText: isPassword,
  );
}