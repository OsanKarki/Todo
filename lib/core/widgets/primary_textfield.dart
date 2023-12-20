import 'package:flutter/material.dart';

class PrimaryTextField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final double height;
  final bool isPassword;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final double borderRadius;
  final TextEditingController? controller;
  final String? Function(String?)?validator;

  const PrimaryTextField({
    super.key,
    this.label,
    this.hintText,
    this.height = 15,
    this.isPassword = false,
    this.suffixIcon,
    this.prefixIcon,
    this.keyboardType,
    this.borderRadius = 11,
    this.controller,
    this.validator,
  });

  @override
  State<PrimaryTextField> createState() => _PrimaryTextFieldState();
}

class _PrimaryTextFieldState extends State<PrimaryTextField> {
  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (widget.label != null)
          Column(
            children: [
              Row(
                children: [
                  Icon(widget.prefixIcon,size: 20,color: Colors.grey,),
                  const SizedBox(width: 15,),
                  Text(
                    widget.label!,
                    style:
                        const TextStyle(fontSize: 16,),
                  ),
                ],
              ),

            ],
          ),
        TextFormField(
          // onTapOutside: , bahira click garda keyboard banda huncha yesle ..
          validator: widget.validator,

          controller: widget.controller,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          obscureText: widget.isPassword ? isHidden : false,
          decoration: InputDecoration(
            // prefixIcon: widget.prefixIcon != null
            //     ? Icon(
            //         widget.prefixIcon,
            //         color: kGreen400,
            //       )
            //     : null,
            suffixIcon: widget.isPassword
                ? InkWell(
                    onTap: () {
                      setState(() {
                        isHidden = !isHidden;
                      });
                    },
                    child: Icon(
                      isHidden ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black38,size: 20,
                    ))
                : null,
            contentPadding:
                EdgeInsets.symmetric(vertical: widget.height, horizontal: 10),
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Color(0xffB6B6B6)),
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green, width: 1.6)),
            enabledBorder: UnderlineInputBorder(
                borderSide:  BorderSide(color: Colors.grey.shade300,width: 1.8 )),
          ),
        ),
      ]),
    );
  }
}
