import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:nu_link_shortener/presentation/url_form/views/url_form_button.dart';

@immutable
class URLForm extends StatefulWidget {
  final String? Function(String?)? validator;
  final Future<void> Function(bool)? onSubmit;
  const URLForm(
      {super.key, this.initialOpen, this.validator, this.onSubmit});

  final bool? initialOpen;

  @override
  State<URLForm> createState() => _URLFormState();
}

class _URLFormState extends State<URLForm>
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

  /// Maximum text field width
  final double _textFieldMaxWidth = 800;

  /// Text field height
  final double _textFieldHeight = 60;

  /// Textfield hozitonal margin
  final double _textFieldHorizontalMargin = 48;

  bool get _isFormValid {
    return _formKey.currentState?.validate() ?? true;
  }

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
    await widget.onSubmit!(_isFormValid);
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
          width: _expandAnimation.value == 0 ? 0 : _calculateTextFieldWidth(),
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
                        if (_isFormValid) {
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

  double _calculateTextFieldWidth() {
    final viewWidth = MediaQuery.of(context).size.width;
    if (viewWidth > _textFieldMaxWidth) {
      return _textFieldMaxWidth - _textFieldHorizontalMargin;
    }
    return viewWidth - _textFieldHorizontalMargin;
  }

  /// Build Close form button
  Widget _buildCloseButton() {
    return URLFormButton(
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
        child: URLFormButton(
          color: Theme.of(context).primaryColor,
          icon: const Icon(
            Icons.check,
            color: Colors.white,
          ),
          onTap: _isLoading
              ? null
              : () async {
                  await _executeSubmit();
                  if (_isFormValid) {
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
