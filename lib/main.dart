import 'package:flutter/material.dart';

void main() {
  runApp(const RegistrationApp());
}

class RegistrationApp extends StatelessWidget {
  const RegistrationApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF4056D6);

    return MaterialApp(
      title: 'Form Registrasi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        scaffoldBackgroundColor: const Color(0xFFF4F6FC),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF9FAFF),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE1E6F2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE1E6F2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: seedColor, width: 1.6),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFD92D20)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFD92D20), width: 1.6),
          ),
        ),
      ),
      home: const RegistrationPage(),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  String? _selectedGender;
  String? _selectedProgram;
  bool _agreeToTerms = false;
  bool _obscurePassword = true;

  static const Color _navy = Color(0xFF172554);
  static const Color _muted = Color(0xFF64748B);
  static const Color _blue = Color(0xFF4056D6);

  static const List<String> _programs = [
    'Sistem Informasi',
    'Teknik Informatika',
    'Manajemen Informatika',
    'Bisnis Digital',
    'Sistem Komputer',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isSuccess ? Icons.check_circle_outline : Icons.info_outline,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: isSuccess ? const Color(0xFF14804A) : _navy,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
  }

  void _submitForm() {
    FocusScope.of(context).unfocus();

    // Jalankan validasi field terlebih dahulu agar pesan error tetap terlihat.
    final bool isFormValid = _formKey.currentState?.validate() ?? false;

    if (!_agreeToTerms) {
      _showSnackBar(
        'Silakan centang Syarat & Ketentuan sebelum mendaftar.',
      );
      return;
    }

    if (!isFormValid) return;

    _showConfirmationDialog();
  }

  Future<void> _showConfirmationDialog() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(Icons.fact_check_outlined, color: _blue, size: 34),
          title: const Text(
            'Konfirmasi Pendaftaran',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w800, color: _navy),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Periksa kembali data berikut sebelum melanjutkan.',
                  style: TextStyle(color: _muted, height: 1.5),
                ),
                const SizedBox(height: 18),
                _SummaryRow(label: 'Nama lengkap', value: _nameController.text.trim()),
                _SummaryRow(label: 'Email', value: _emailController.text.trim()),
                _SummaryRow(label: 'Jenis kelamin', value: _selectedGender ?? '-'),
                _SummaryRow(label: 'Program studi', value: _selectedProgram ?? '-'),
                const _SummaryRow(
                  label: 'Password',
                  value: 'Disembunyikan demi keamanan',
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Periksa Lagi'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _showSnackBar(
                  'Pendaftaran berhasil dikonfirmasi.',
                  isSuccess: true,
                );
              },
              child: const Text('Konfirmasi'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isWide = constraints.maxWidth > 600;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 36 : 18,
                vertical: isWide ? 34 : 22,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 650),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8ECFF),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.person_add_alt_1_rounded,
                              color: _blue,
                              size: 27,
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'FORM REGISTRASI',
                                  style: TextStyle(
                                    color: _blue,
                                    fontSize: 11,
                                    letterSpacing: 1.7,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Buat Akun Baru',
                                  style: TextStyle(
                                    color: _navy,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Lengkapi data di bawah ini untuk membuat akun.',
                        style: TextStyle(color: _muted, height: 1.5),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: EdgeInsets.all(isWide ? 30 : 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(color: const Color(0xFFE6EAF3)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0B172554),
                              blurRadius: 28,
                              offset: Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const _SectionHeading(
                                number: '01',
                                title: 'Informasi Pribadi',
                                subtitle: 'Masukkan identitas dasar kamu.',
                              ),
                              const SizedBox(height: 20),
                              const _FieldLabel(text: 'Nama Lengkap'),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _nameController,
                                focusNode: _nameFocus,
                                textInputAction: TextInputAction.next,
                                textCapitalization: TextCapitalization.words,
                                autofillHints: const [AutofillHints.name],
                                decoration: const InputDecoration(
                                  hintText: 'Contoh: Husain Aziz Al Rosyid',
                                  prefixIcon: Icon(Icons.person_outline_rounded),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Nama lengkap tidak boleh kosong.';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context).requestFocus(_emailFocus);
                                },
                              ),
                              const SizedBox(height: 18),
                              const _FieldLabel(text: 'Email'),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _emailController,
                                focusNode: _emailFocus,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [AutofillHints.email],
                                decoration: const InputDecoration(
                                  hintText: 'nama@email.com',
                                  prefixIcon: Icon(Icons.alternate_email_rounded),
                                ),
                                validator: (value) {
                                  final email = value?.trim() ?? '';
                                  if (email.isEmpty) {
                                    return 'Email tidak boleh kosong.';
                                  }
                                  if (!email.contains('@')) {
                                    return 'Email harus mengandung karakter "@".';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context).requestFocus(_passwordFocus);
                                },
                              ),
                              const SizedBox(height: 18),
                              const _FieldLabel(text: 'Password'),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _passwordController,
                                focusNode: _passwordFocus,
                                obscureText: _obscurePassword,
                                textInputAction: TextInputAction.done,
                                autofillHints: const [AutofillHints.newPassword],
                                decoration: InputDecoration(
                                  hintText: 'Minimal 6 karakter',
                                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                                  suffixIcon: IconButton(
                                    tooltip: _obscurePassword
                                        ? 'Tampilkan password'
                                        : 'Sembunyikan password',
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  final password = value ?? '';
                                  if (password.isEmpty) {
                                    return 'Password tidak boleh kosong.';
                                  }
                                  if (password.length < 6) {
                                    return 'Password minimal 6 karakter.';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (_) => _submitForm(),
                              ),
                              const SizedBox(height: 26),
                              const Divider(color: Color(0xFFE9ECF4)),
                              const SizedBox(height: 22),
                              const _SectionHeading(
                                number: '02',
                                title: 'Informasi Akademik',
                                subtitle: 'Pilih data yang sesuai.',
                              ),
                              const SizedBox(height: 18),
                              const _FieldLabel(text: 'Jenis Kelamin'),
                              const SizedBox(height: 5),
                              FormField<String>(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Silakan pilih jenis kelamin.';
                                  }
                                  return null;
                                },
                                builder: (field) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Wrap(
                                        spacing: 16,
                                        runSpacing: 4,
                                        children: [
                                          _GenderOption(
                                            label: 'Laki-laki',
                                            value: 'Laki-laki',
                                            groupValue: field.value,
                                            onChanged: (value) {
                                              field.didChange(value);
                                              setState(() => _selectedGender = value);
                                            },
                                          ),
                                          _GenderOption(
                                            label: 'Perempuan',
                                            value: 'Perempuan',
                                            groupValue: field.value,
                                            onChanged: (value) {
                                              field.didChange(value);
                                              setState(() => _selectedGender = value);
                                            },
                                          ),
                                        ],
                                      ),
                                      if (field.hasError)
                                        Padding(
                                          padding: const EdgeInsets.only(left: 12, top: 2),
                                          child: Text(
                                            field.errorText!,
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.error,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: 18),
                              const _FieldLabel(text: 'Program Studi'),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                initialValue: _selectedProgram,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.school_outlined),
                                ),
                                hint: const Text('Pilih program studi'),
                                items: _programs
                                    .map(
                                      (program) => DropdownMenuItem<String>(
                                        value: program,
                                        child: Text(program),
                                      ),
                                    )
                                    .toList(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Silakan pilih program studi.';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() => _selectedProgram = value);
                                },
                              ),
                              const SizedBox(height: 24),
                              const Divider(color: Color(0xFFE9ECF4)),
                              const SizedBox(height: 12),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    value: _agreeToTerms,
                                    activeColor: _blue,
                                    onChanged: (value) {
                                      setState(() => _agreeToTerms = value ?? false);
                                    },
                                  ),
                                  const Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 12),
                                      child: Text.rich(
                                        TextSpan(
                                          style: TextStyle(
                                            color: _muted,
                                            fontSize: 13,
                                            height: 1.5,
                                          ),
                                          children: [
                                            TextSpan(text: 'Saya telah membaca dan menyetujui '),
                                            TextSpan(
                                              text: 'Syarat & Ketentuan',
                                              style: TextStyle(
                                                color: _blue,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            TextSpan(text: ' yang berlaku.'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              SizedBox(
                                height: 54,
                                child: FilledButton.icon(
                                  onPressed: _submitForm,
                                  icon: const Icon(Icons.person_add_alt_1_rounded),
                                  label: const Text(
                                    'Daftar Sekarang',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: _blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Center(
                        child: Text(
                          'Praktikum Mobile Programming • Pertemuan 4',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _muted,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.number,
    required this.title,
    required this.subtitle,
  });

  final String number;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFEEF1FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            number,
            style: const TextStyle(
              color: Color(0xFF4056D6),
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF172554),
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF172554),
        fontSize: 13,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _GenderOption extends StatelessWidget {
  const _GenderOption({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final String label;
  final String value;
  final String? groupValue;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: const Color(0xFF4056D6),
              visualDensity: VisualDensity.compact,
            ),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF334155),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          SelectableText(
            value,
            style: const TextStyle(
              color: Color(0xFF172554),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
