import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const UserCrudApp());
}

// ============================================================
// 1. MODEL CLASS
// ============================================================

class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;

  const UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final rawName = (json['name'] ?? '').toString().trim();

    final nameParts = rawName.isEmpty
        ? <String>[]
        : rawName.split(RegExp(r'\s+'));

    return UserModel(
      id: (json['id'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      firstName: (json['first_name'] ??
              (nameParts.isNotEmpty ? nameParts.first : ''))
          .toString(),
      lastName: (json['last_name'] ??
              (nameParts.length > 1
                  ? nameParts.skip(1).join(' ')
                  : ''))
          .toString(),
      avatar: (json['avatar'] ?? '').toString(),
    );
  }
}

// ============================================================
// 2. API EXCEPTION
// ============================================================

class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  @override
  String toString() => message;
}

// ============================================================
// 3. SERVICE CLASS
// ============================================================

class UserService {
  static const String baseUrl = 'https://reqres.in/api';

  static const String apiKey = String.fromEnvironment(
    'REQRES_API_KEY',
    defaultValue: 'reqres-free-v1',
  );

  static const Duration timeoutDuration = Duration(seconds: 15);

  Map<String, String> get headers => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
      };

  void checkStatus(
    http.Response response,
    Set<int> expectedStatusCodes,
  ) {
    if (expectedStatusCodes.contains(response.statusCode)) {
      return;
    }

    String message =
        'Request gagal dengan HTTP ${response.statusCode}.';

    if (response.statusCode == 401 ||
        response.statusCode == 403) {
      message +=
          ' API key belum valid atau tidak memiliki akses. '
          'Periksa konfigurasi REQRES_API_KEY.';
    } else {
      try {
        final decoded = jsonDecode(response.body);

        if (decoded is Map && decoded['error'] != null) {
          message += ' ${decoded['error']}';
        }
      } catch (_) {
      }
    }

    throw ApiException(message);
  }

  Map<String, dynamic> decodeJsonObject(String body) {
    final decoded = jsonDecode(body);

    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    throw const FormatException(
      'Format respons API tidak sesuai.',
    );
  }


  Future<List<UserModel>> getUsers() async {
    try {
      final uri = Uri.parse('$baseUrl/users?page=1');

      final response = await http
          .get(uri, headers: headers)
          .timeout(timeoutDuration);

      checkStatus(response, {200});

      final decoded = decodeJsonObject(response.body);
      final data = decoded['data'];

      if (data is! List) {
        throw const FormatException(
          'Data pengguna tidak ditemukan dalam respons API.',
        );
      }

      return data.map((item) {
        return UserModel.fromJson(
          Map<String, dynamic>.from(item as Map),
        );
      }).toList();
    } on TimeoutException {
      throw const ApiException(
        'Koneksi timeout. Periksa jaringan internetmu.',
      );
    } on http.ClientException {
      throw const ApiException(
        'Tidak dapat terhubung ke server. '
        'Periksa koneksi internet.',
      );
    } on FormatException catch (e) {
      throw ApiException('Format respons tidak valid: ${e.message}');
    }
  }


  Future<UserModel> createUser({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/users'),
            headers: headers,
            body: jsonEncode({
              'name': '$firstName $lastName'.trim(),
              'job': 'Mobile Programming Student',
              'first_name': firstName,
              'last_name': lastName,
              'email': email,
            }),
          )
          .timeout(timeoutDuration);

      checkStatus(response, {201});

      final data = decodeJsonObject(response.body);

      return UserModel.fromJson({
        ...data,
        'id': data['id']?.toString() ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        'first_name': data['first_name'] ?? firstName,
        'last_name': data['last_name'] ?? lastName,
        'email': data['email'] ?? email,
        'avatar': data['avatar'] ?? '',
      });
    } on TimeoutException {
      throw const ApiException(
        'Request pembuatan pengguna mengalami timeout.',
      );
    } on http.ClientException {
      throw const ApiException(
        'Gagal menghubungi server. Periksa koneksi internet.',
      );
    } on FormatException catch (e) {
      throw ApiException('Respons POST tidak valid: ${e.message}');
    }
  }


  Future<UserModel> updateUser({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/users/$id'),
            headers: headers,
            body: jsonEncode({
              'name': '$firstName $lastName'.trim(),
              'job': 'Mobile Programming Student',
              'first_name': firstName,
              'last_name': lastName,
              'email': email,
            }),
          )
          .timeout(timeoutDuration);

      checkStatus(response, {200});

      final data = decodeJsonObject(response.body);

      return UserModel.fromJson({
        ...data,
        'id': id,
        'first_name': data['first_name'] ?? firstName,
        'last_name': data['last_name'] ?? lastName,
        'email': data['email'] ?? email,
        'avatar': data['avatar'] ?? '',
      });
    } on TimeoutException {
      throw const ApiException(
        'Request pembaruan pengguna mengalami timeout.',
      );
    } on http.ClientException {
      throw const ApiException(
        'Gagal menghubungi server. Periksa koneksi internet.',
      );
    } on FormatException catch (e) {
      throw ApiException('Respons PUT tidak valid: ${e.message}');
    }
  }


  Future<void> deleteUser(String id) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$baseUrl/users/$id'),
            headers: headers,
          )
          .timeout(timeoutDuration);

      // HTTP 204 merupakan respons sukses DELETE yang umum.
      checkStatus(response, {200, 202, 204});
    } on TimeoutException {
      throw const ApiException(
        'Request penghapusan pengguna mengalami timeout.',
      );
    } on http.ClientException {
      throw const ApiException(
        'Gagal menghubungi server. Periksa koneksi internet.',
      );
    }
  }
}

// ============================================================
// 4. HELPER ERROR MESSAGE
// ============================================================

String getErrorMessage(Object error) {
  if (error is ApiException) {
    return error.message;
  }

  if (error is TimeoutException) {
    return 'Koneksi timeout. Silakan coba lagi.';
  }

  if (error is http.ClientException) {
    return 'Tidak dapat terhubung ke server.';
  }

  if (error is FormatException) {
    return 'Format data yang diterima tidak valid.';
  }

  return 'Terjadi kesalahan: $error';
}

// ============================================================
// 5. ROOT APPLICATION
// ============================================================

class UserCrudApp extends StatelessWidget {
  const UserCrudApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD User API',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4056D6),
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF4F6FC),
          foregroundColor: Color(0xFF172554),
          centerTitle: false,
        ),
      ),
      home: const UserListPage(),
    );
  }
}

// ============================================================
// 6. MAIN PAGE + FUTURE BUILDER
// ============================================================

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final UserService _userService = UserService();

  late Future<List<UserModel>> _usersFuture;

  List<UserModel> _users = [];

  @override
  void initState() {
    super.initState();
    _usersFuture = _loadUsers();
  }

  Future<List<UserModel>> _loadUsers() async {
    final users = await _userService.getUsers();
    _users = List<UserModel>.from(users);
    return users;
  }

  void _refreshUsers() {
    setState(() {
      _usersFuture = _loadUsers();
    });
  }

  void _showMessage(
    String message, {
    bool isError = false,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError
              ? Colors.red.shade700
              : Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }


  Future<void> _openUserForm({UserModel? user}) async {
    final result = await showDialog<UserModel>(
      context: context,
      builder: (context) {
        return UserFormDialog(
          user: user,
          onSave: ({
            required firstName,
            required lastName,
            required email,
          }) {
            if (user == null) {
              return _userService.createUser(
                firstName: firstName,
                lastName: lastName,
                email: email,
              );
            }

            return _userService.updateUser(
              id: user.id,
              firstName: firstName,
              lastName: lastName,
              email: email,
            );
          },
        );
      },
    );

    if (!mounted || result == null) return;

    setState(() {
      if (user == null) {
        _users.insert(0, result);
      } else {
        final index = _users.indexWhere(
          (item) => item.id == user.id,
        );

        if (index != -1) {
          _users[index] = result;
        } else {
          _users.insert(0, result);
        }
      }

      _usersFuture = Future<List<UserModel>>.value(
        List<UserModel>.from(_users),
      );
    });

    _showMessage(
      user == null
          ? 'Pengguna berhasil dibuat.'
          : 'Data pengguna berhasil diperbarui.',
    );
  }


  Future<void> _deleteUser(UserModel user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Pengguna?'),
          content: Text(
            'Apakah kamu yakin ingin menghapus '
            '${user.fullName}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await _userService.deleteUser(user.id);

      if (!mounted) return;

      setState(() {
        _users.removeWhere((item) => item.id == user.id);

        _usersFuture = Future<List<UserModel>>.value(
          List<UserModel>.from(_users),
        );
      });

      _showMessage('Pengguna berhasil dihapus.');
    } catch (error) {
      _showMessage(
        'Gagal menghapus pengguna: ${getErrorMessage(error)}',
        isError: true,
      );
    }
  }


  Widget _buildUserCard(UserModel user) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(
          color: Color(0xFFE7EAF3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFFE9EDFF),
              child: user.avatar.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        user.avatar,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            size: 30,
                            color: Color(0xFF4056D6),
                          );
                        },
                      ),
                    )
                  : const Icon(
                      Icons.person,
                      size: 30,
                      color: Color(0xFF4056D6),
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName.isEmpty
                        ? 'Nama tidak tersedia'
                        : user.fullName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF172554),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    user.email.isEmpty
                        ? 'Email tidak tersedia'
                        : user.email,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'ID: ${user.id}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              tooltip: 'Aksi pengguna',
              onSelected: (value) {
                if (value == 'edit') {
                  _openUserForm(user: user);
                } else if (value == 'delete') {
                  _deleteUser(user);
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 19),
                      SizedBox(width: 10),
                      Text('Edit'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline,
                        size: 19,
                        color: Colors.red,
                      ),
                      SizedBox(width: 10),
                      Text('Hapus'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Mengambil data pengguna...'),
        ],
      ),
    );
  }

  Widget _buildError(Object error) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 64,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 16),
            const Text(
              'Gagal Memuat Data',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF172554),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              getErrorMessage(error),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF64748B),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _refreshUsers,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Management',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'CRUD dengan REST API',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Muat ulang data',
            onPressed: _refreshUsers,
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF4056D6),
                    Color(0xFF697CF0),
                  ],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.cloud_sync_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Data Pengguna',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Data diambil melalui HTTP GET dari ReqRes API.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<UserModel>>(
                future: _usersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return _buildLoading();
                  }

                  if (snapshot.hasError) {
                    return _buildError(snapshot.error!);
                  }

                  final users = snapshot.data ?? [];

                  if (users.isEmpty) {
                    return const Center(
                      child: Text('Belum ada data pengguna.'),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(
                      top: 4,
                      bottom: 90,
                    ),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return _buildUserCard(users[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openUserForm(),
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Tambah Pengguna'),
      ),
    );
  }
}

// ============================================================
// 7. FORM DIALOG UNTUK CREATE & UPDATE
// ============================================================

class UserFormDialog extends StatefulWidget {
  final UserModel? user;

  final Future<UserModel> Function({
    required String firstName,
    required String lastName,
    required String email,
  }) onSave;

  const UserFormDialog({
    super.key,
    required this.onSave,
    this.user,
  });

  @override
  State<UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<UserFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;

  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _firstNameController = TextEditingController(
      text: widget.user?.firstName ?? '',
    );

    _lastNameController = TextEditingController(
      text: widget.user?.lastName ?? '',
    );

    _emailController = TextEditingController(
      text: widget.user?.email ?? '',
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final savedUser = await widget.onSave(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
      );

      if (!mounted) return;

      Navigator.of(context).pop(savedUser);
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isSaving = false;
        _errorMessage = getErrorMessage(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.user != null;

    return AlertDialog(
      title: Text(
        isEditing ? 'Edit Pengguna' : 'Tambah Pengguna',
      ),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _firstNameController,
                  enabled: !_isSaving,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Nama Depan',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama depan wajib diisi.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _lastNameController,
                  enabled: !_isSaving,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Nama Belakang',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama belakang wajib diisi.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _emailController,
                  enabled: !_isSaving,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final email = value?.trim() ?? '';

                    if (email.isEmpty) {
                      return 'Email wajib diisi.';
                    }

                    if (!RegExp(
                      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                    ).hasMatch(email)) {
                      return 'Format email tidak valid.';
                    }

                    return null;
                  },
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Colors.red.shade800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving
              ? null
              : () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton.icon(
          onPressed: _isSaving ? null : _submit,
          icon: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Icon(
                  isEditing ? Icons.save_outlined : Icons.add,
                ),
          label: Text(
            _isSaving
                ? 'Menyimpan...'
                : isEditing
                    ? 'Simpan Perubahan'
                    : 'Daftar Pengguna',
          ),
        ),
      ],
    );
  }
}