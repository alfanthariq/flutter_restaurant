import 'package:flutter/material.dart';

class InputFieldArea extends StatelessWidget {
  final String hint;
  final bool obscure;
  final IconData icon;
  final TextEditingController controller;
  final ValueChanged<String>? onSubmit;

  InputFieldArea(
      {required this.hint,
      required this.obscure,
      required this.icon,
      required this.controller,
      this.onSubmit});
  @override
  Widget build(BuildContext context) {
    return (Container(
      padding: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.0,
            color: Colors.white24,
          ),
        ),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        onFieldSubmitted: onSubmit == null ? (val) {} : onSubmit,
        cursorColor: Colors.grey[900],
        style: TextStyle(
          color: Colors.grey[900],
        ),
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Colors.grey[900],
            size: 15,
          ),
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[900], fontSize: 15.0),
          contentPadding: const EdgeInsets.only(
              top: 10.0, right: 10.0, bottom: 10.0, left: 5.0),
        ),
      ),
    ));
  }
}
