import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../theme/app_theme.dart';

class Brand extends StatelessWidget {
  final bool light;
  const Brand({super.key, this.light = false});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: light ? Colors.white : forest,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.radar_rounded,
          color: light ? forest : Colors.white,
          size: 24,
        ),
      ),
      const SizedBox(width: 10),
      Text(
        'órbita',
        style: TextStyle(
          fontSize: 29,
          letterSpacing: -1.1,
          fontWeight: FontWeight.w800,
          color: light ? Colors.white : ink,
        ),
      ),
    ],
  );
}

class Photo extends StatelessWidget {
  final String file;
  final double? width, height;
  final BoxFit fit;
  const Photo(
    this.file, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });
  @override
  Widget build(BuildContext context) => ColoredBox(
    color: mint,
    // FadeInImage del laboratorio con placeholder en memoria y foto local:
    // no depende de peticiones externas ni de CORS durante la presentación.
    child: FadeInImage(
      placeholder: MemoryImage(
        base64Decode(
          'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAACklEQVR4nGMAAQAABQABDQottAAAAABJRU5ErkJggg==',
        ),
      ),
      image: file.startsWith('data:image/')
          ? MemoryImage(UriData.parse(file).contentAsBytes())
          : AssetImage('assets/images/$file') as ImageProvider,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: MediaQuery.disableAnimationsOf(context)
          ? const Duration(milliseconds: 1)
          : const Duration(milliseconds: 220),
      imageErrorBuilder: (_, _, _) => SizedBox(
        width: width,
        height: height,
        child: const Center(
          child: Icon(Icons.devices_outlined, color: forest, size: 36),
        ),
      ),
    ),
  );
}

class Tag extends StatelessWidget {
  final String text;
  const Tag(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: mint,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        color: forest,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

class PageHeading extends StatelessWidget {
  final String title, subtitle;
  final Widget? action;
  const PageHeading(this.title, this.subtitle, {super.key, this.action});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: LayoutBuilder(
      builder: (context, c) {
        final heading = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(subtitle),
            ],
          ],
        );
        return c.maxWidth < 650
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  heading,
                  if (action != null) ...[const SizedBox(height: 16), action!],
                ],
              )
            : Row(
                children: [
                  Expanded(child: heading),
                  if (action != null) action!,
                ],
              );
      },
    ),
  );
}

String? requiredText(String? value) =>
    value == null || value.trim().isEmpty ? 'Completa este campo.' : null;
String? emailValidator(String? value) =>
    value == null ||
        !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value.trim())
    ? 'Ingresa un correo válido.'
    : null;
void message(BuildContext context, String text) => ScaffoldMessenger.of(context)
  ..hideCurrentSnackBar()
  ..showSnackBar(SnackBar(content: Text(text)));

// Feedback táctil de Emil: presión breve e interrumpible, sin animación al
// activar con teclado. Se conserva FilledButton para foco y accesibilidad.
class ActionButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final Widget child;
  const ActionButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.style,
  });
  ActionButton.icon({
    super.key,
    required this.onPressed,
    required Widget icon,
    required Widget label,
    this.style,
  }) : child = Row(
         mainAxisSize: MainAxisSize.min,
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           icon,
           const SizedBox(width: 8),
           Flexible(child: label),
         ],
       );
  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  bool pressed = false;
  @override
  Widget build(BuildContext context) => Listener(
    onPointerDown: widget.onPressed == null
        ? null
        : (_) => setState(() => pressed = true),
    onPointerUp: (_) => setState(() => pressed = false),
    onPointerCancel: (_) => setState(() => pressed = false),
    child: AnimatedScale(
      scale: pressed && !MediaQuery.disableAnimationsOf(context) ? .98 : 1,
      duration: const Duration(milliseconds: 120),
      curve: const Cubic(.23, 1, .32, 1),
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        color: widget.style?.backgroundColor?.resolve({}) ?? forest,
        onPressed: widget.onPressed,
        child: widget.child,
      ),
    ),
  );
}

class ProfilePhoto extends StatelessWidget {
  final double radius;
  const ProfilePhoto({super.key, this.radius = 20});
  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Foto de perfil de ejemplo',
    image: true,
    child: CircleAvatar(
      radius: radius,
      backgroundColor: mint,
      backgroundImage: const AssetImage('assets/images/profile.jpg'),
    ),
  );
}

// Borde y sombra de bloque: lenguaje visual explícito de la referencia.
class BoldPanel extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsets padding;
  const BoldPanel({
    super.key,
    required this.child,
    this.color = surface,
    this.padding = const EdgeInsets.all(20),
  });
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: color,
      border: Border.all(color: ink, width: 2),
      borderRadius: BorderRadius.circular(8),
      boxShadow: const [BoxShadow(color: ink, offset: Offset(4, 5))],
    ),
    padding: padding,
    child: child,
  );
}

class CupertinoFormField extends StatelessWidget {
  final TextEditingController controller;
  final InputDecoration decoration;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final bool obscureText, readOnly;
  final int? maxLength, maxLines;
  const CupertinoFormField({
    super.key,
    required this.controller,
    required this.decoration,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.obscureText = false,
    this.readOnly = false,
    this.maxLength,
    this.maxLines = 1,
  });
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (decoration.labelText != null)
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            decoration.labelText!,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: ink,
            ),
          ),
        ),
      CupertinoTextFormFieldRow(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        obscureText: obscureText,
        readOnly: readOnly,
        maxLength: maxLength,
        maxLines: maxLines,
        placeholder: decoration.hintText,
        prefix: decoration.prefixIcon,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: decoration.fillColor ?? surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: CupertinoColors.systemGrey3),
        ),
      ),
      if (decoration.suffixIcon != null)
        Align(alignment: Alignment.centerRight, child: decoration.suffixIcon!),
    ],
  );
}
