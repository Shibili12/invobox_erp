import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/login_controller.dart';
import '../../core/app_routes.dart';
import '../../core/app_theme.dart';
import '../../widgets/shared_widgets.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginController(),
      child: const _LoginContent(),
    );
  }
}

class _LoginContent extends StatelessWidget {
  const _LoginContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const AppTitleBar(),
          Expanded(
            child: Center(
              child: Container(
                width: 380,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.cardBorder, width: 0.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(32),
                child: const _LoginForm(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<LoginController>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Logo
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.asset(
                      "icon.png",
                      height: 25,
                      width: 25,
                      fit: BoxFit.cover,
                    )),
                const SizedBox(width: 10),
                const Text(
                  'INVOBOX',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'ERP Management System',
              style: TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
          ],
        ),

        const SizedBox(height: 28),

        LabeledField(
          label: 'Username',
          child: TextField(
            controller: ctrl.usernameController,
            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
            decoration: const InputDecoration(
              hintText: 'Enter username',
              prefixIcon: Icon(Icons.person_outline,
                  size: 18, color: AppColors.textMuted),
            ),
          ),
        ),

        const SizedBox(height: 14),

        // Password
        LabeledField(
          label: 'Password',
          child: TextField(
            controller: ctrl.passwordController,
            obscureText: ctrl.obscurePassword,
            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Enter password',
              prefixIcon: const Icon(Icons.lock_outline,
                  size: 18, color: AppColors.textMuted),
              suffixIcon: IconButton(
                icon: Icon(
                  ctrl.obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 18,
                  color: AppColors.textMuted,
                ),
                onPressed: ctrl.togglePasswordVisibility,
              ),
            ),
          ),
        ),

        const SizedBox(height: 14),

        // Domain badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.successLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  ctrl.domain,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.successText,
                  ),
                ),
              ),
              InkWell(
                onTap: () => _showDomainDialog(context, ctrl),
                borderRadius: BorderRadius.circular(4),
                child: const Icon(Icons.edit_outlined,
                    size: 16, color: AppColors.successText),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Remember me
        Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: ctrl.rememberMe,
                onChanged: (_) => ctrl.toggleRememberMe(),
                activeColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3)),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Remember me',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Error message
        if (ctrl.errorMessage.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.dangerLight,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              ctrl.errorMessage,
              style: const TextStyle(fontSize: 12, color: AppColors.danger),
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Buttons
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: ctrl.isLoading
                      ? null
                      : () async {
                          final ok = await ctrl.login();
                          if (ok && context.mounted) {
                            Navigator.pushReplacementNamed(
                                context, AppRoutes.invoiceList);
                          }
                        },
                  child: ctrl.isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Login',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 40,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.dangerLight,
                  foregroundColor: AppColors.danger,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: const Text('Exit',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Powered by
        const Center(
          child: Text(
            'powered by cloudcubex',
            style: TextStyle(fontSize: 10, color: AppColors.textMuted),
          ),
        ),
      ],
    );
  }

  void _showDomainDialog(BuildContext context, LoginController ctrl) {
    final tc = TextEditingController(text: ctrl.domain);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Change Domain', style: TextStyle(fontSize: 15)),
        content: TextField(
          controller: tc,
          decoration: const InputDecoration(hintText: 'example.com'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              ctrl.setDomain(tc.text);
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
