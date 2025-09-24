import 'package:flutter/material.dart';
import 'package:m2m/l10n/app_localizations.dart';
import 'package:m2m/core/services/session_manager.dart';
import 'package:m2m/features/auth/data/auth_repository.dart';
import 'package:m2m/features/auth/presentation/signup/sign_up_page.dart';
import 'package:m2m/features/navigation/presentation/navigation_shell.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSubmitting = false;

  late final AuthRepository _authRepository;
  late final SessionManager _sessionManager;

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepository();
    _sessionManager = SessionManager();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    setState(() => _isSubmitting = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      final response = await _authRepository.login(
        email: email,
        password: password,
      );

      await _sessionManager.saveAccessToken(response.accessToken);

      if (!mounted) return;

      final alreadyUsingFaceId = await _sessionManager.isFaceIdEnabled();
      if (!alreadyUsingFaceId) {
        await _maybeEnableFaceId(email, password);
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const NavigationShell()),
      );
    } on AuthException catch (error) {
      _showError(error.message);
    } catch (error) {
      _showError(AppLocalizations.of(context)!.genericError);
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _maybeEnableFaceId(String email, String password) async {
    final localizations = AppLocalizations.of(context)!;

    final shouldEnable = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(localizations.enableFaceIdTitle),
          content: Text(localizations.enableFaceIdDescription),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(localizations.noButtonLabel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(localizations.yesButtonLabel),
            ),
          ],
        );
      },
    );

    if (shouldEnable == true) {
      await _sessionManager.updateFaceIdPreference(
        enabled: true,
        email: email,
        password: password,
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.login)),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: localizations.email,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return localizations.requiredField;
                          }
                          final emailPattern = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                          if (!emailPattern.hasMatch(value.trim())) {
                            return localizations.invalidEmail;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: localizations.password,
                        ),
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _handleLogin(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return localizations.requiredField;
                          }
                          if (value.length < 8) {
                            return localizations.passwordTooShort;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(localizations.forgotPassword),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _isSubmitting
                          ? const Center(child: CircularProgressIndicator())
                          : FilledButton(
                              onPressed: _handleLogin,
                              child: Text(localizations.login),
                            ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignUpPage(),
                            ),
                          );
                        },
                        child: Text(localizations.dontHaveAccount),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
