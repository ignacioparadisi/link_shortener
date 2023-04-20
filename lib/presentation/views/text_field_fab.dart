import 'package:flutter/material.dart';
import 'dart:math' as math;

@immutable
class TextFieldFab extends StatefulWidget {
  final String? Function(String?)? validator;
  final Future<void> Function(bool)? onSubmit;
  const TextFieldFab(
      {super.key, this.initialOpen, this.validator, this.onSubmit});

  final bool? initialOpen;

  @override
  State<TextFieldFab> createState() => _TextFieldFabState();
}

class _TextFieldFabState extends State<TextFieldFab>
    with SingleTickerProviderStateMixin {
  /// Node for controlling focus and unfocus of textfield
  final _focusNode = FocusNode();

  /// Key for the form
  final _formKey = GlobalKey<FormState>();

  /// Controller for setting up animation
  late final AnimationController _controller;

  /// Animation for expanding the form
  late final Animation<double> _expandAnimation;

  /// Whether the for is open or not
  bool _isOpen = false;

  /// Whether the form is loading or not
  bool _isLoading = false;

  final double _textFieldMaxWidth = 800;
  final double _textFieldHeight = 60;
  final double _textFieldPadding = 48;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  /// Setup animation type and duration
  void _setupAnimations() {
    _isOpen = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _isOpen ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Handle view updates for opening and closing the form.
  void _toggleFormVisibility() {
    _formKey.currentState?.reset();
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _focusNode.requestFocus();
        _controller.forward();
      } else {
        _focusNode.unfocus();
        _controller.reverse();
      }
    });
  }

  Future<void> _executeSubmit() async {
    if (widget.onSubmit == null) {
      return;
    }
    setState(() {
      _focusNode.unfocus();
      _isLoading = true;
    });
    await widget.onSubmit!(_formKey.currentState?.validate() ?? true);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Form(
        key: _formKey,
        child: Stack(
          alignment: Alignment.bottomRight,
          clipBehavior: Clip.none,
          children: [
            _buildTextField(),
            _buildCloseButton(),
            _buildSaveButton(),
            _buildOpenButton(),
          ],
        ),
      ),
    );
  }

  /// Build form text field
  Widget _buildTextField() {
    return AnimatedBuilder(
      animation: _expandAnimation,
      builder: (context, child) {
        return Positioned(
          height: _expandAnimation.value == 0 ? 0 : _textFieldHeight,
          width: _expandAnimation.value == 0
              ? 0
              : (MediaQuery.of(context).size.width > _textFieldMaxWidth
                  ? _textFieldMaxWidth - _textFieldPadding
                  : MediaQuery.of(context).size.width - _textFieldPadding),
          bottom: _expandAnimation.value * 60,
          right: 8,
          child: child!,
        );
      },
      child: FadeTransition(
        opacity: _expandAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 16.0),
              child: TextFormField(
                focusNode: _focusNode,
                validator: widget.validator,
                decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: 'URL',
                    suffixIconConstraints:
                        const BoxConstraints(maxWidth: 20, maxHeight: 20),
                    suffixIcon:
                        _isLoading ? const CircularProgressIndicator() : null),
                onFieldSubmitted: _isLoading
                    ? null
                    : (value) async {
                        await _executeSubmit();
                        if (_formKey.currentState?.validate() ?? true) {
                          _toggleFormVisibility();
                        }
                      },
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build button with style for the form
  Widget _buildFormButton({
    Color? color,
    required Widget icon,
    required void Function()? onTap,
  }) {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Center(
        child: Material(
          color: color,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: icon,
            ),
          ),
        ),
      ),
    );
  }

  /// Build Close form button
  Widget _buildCloseButton() {
    return _buildFormButton(
      onTap: _isLoading ? null : _toggleFormVisibility,
      icon: Icon(
        Icons.close,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  /// Build Save Form Button
  Widget _buildSaveButton() {
    return AnimatedBuilder(
      animation: _expandAnimation,
      builder: (context, child) {
        return Positioned(
          right: _expandAnimation.value * 60,
          child: Transform.rotate(
            angle: (1.0 - _expandAnimation.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: _expandAnimation,
        child: _buildFormButton(
          color: Theme.of(context).primaryColor,
          icon: const Icon(
            Icons.check,
            color: Colors.white,
          ),
          onTap: _isLoading
              ? null
              : () async {
                  await _executeSubmit();
                  if (_formKey.currentState?.validate() ?? true) {
                    _toggleFormVisibility();
                  }
                },
        ),
      ),
    );
  }

  /// Build Floating Add Button with animations
  Widget _buildOpenButton() {
    return IgnorePointer(
      ignoring: _isOpen,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _isOpen ? 0.7 : 1.0,
          _isOpen ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _isOpen ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            onPressed: _toggleFormVisibility,
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
