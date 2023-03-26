import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInput extends StatefulWidget {
  final IconData icon;
  final String placehoder;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool? disabled;
  final int maxChar;

  const CustomInput(
      {Key? key,
      required this.icon,
      required this.placehoder,
      required this.textController,
      required this.keyboardType,
      this.maxChar = 0,
      this.isPassword = false,
      this.disabled})
      : super(key: key);

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool _passwordVisible = false;

  @override
  void initState() {
    if (widget.isPassword) {
      _passwordVisible = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(right: 20, top: 5, left: 5, bottom: 5),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 5),
                blurRadius: 5)
          ]),
      child: TextFormField(
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        maxLength: widget.maxChar == 0 ? null : widget.maxChar,
        enabled: widget.disabled,
        controller: widget.textController,
        cursorColor: Theme.of(context).primaryColor,
        autocorrect: false,
        keyboardType: widget.keyboardType,
        obscureText: _passwordVisible,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9\s]')),
        ],
        decoration: InputDecoration(
            errorMaxLines: 5,
            prefixIcon: Icon(widget.icon),
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            hintText: widget.placehoder,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(!_passwordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  )
                : null),
      ),
    );
  }
}
