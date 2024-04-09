import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  
  final String? label;
  final String? hint;
  final String? errorMessage;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? icon;
  final List<TextInputFormatter>? inputFormat;
  
  const CustomTextFormField({
    super.key, 
    this.label, 
    this.hint, 
    this.errorMessage, 
    this.onChanged, 
    this.validator, 
    this.obscureText = false,
    this.icon, 
    this.inputFormat
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final border = OutlineInputBorder(
      // borderSide: BorderSide(color: colors.primary),
      borderRadius: BorderRadius.circular(40)
    );

    return TextFormField( 
      inputFormatters: inputFormat,
      onChanged: onChanged,
      validator: validator,
      obscureText: obscureText,
        // (value) {
        // if (value == null) return 'Campo es requerido';
        // if (value.isEmpty) return 'Campo es requerido';
        // if(value.trim().isEmpty) return 'Campo es requerido';
        // return null;
        // },
      decoration: InputDecoration(
        icon: icon,
        iconColor: Colors.black,
        enabledBorder: border,
        focusedBorder: border.copyWith(borderSide: BorderSide(color: colors.primary)),
        focusedErrorBorder: border.copyWith(borderSide: BorderSide(color: Colors.red.shade800)),
        errorBorder: border.copyWith(borderSide: BorderSide(color: Colors.red.shade800)),
        isDense: true,
        label: label != null ? Text(label!) : null,
        hintText: hint,
        errorText: errorMessage,
        focusColor: colors.primary
      ),
    );
  }
}