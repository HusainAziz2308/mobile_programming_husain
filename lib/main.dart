import 'package:material_ui/material_ui.dart';
import 'package:faker/faker.dart' show Faker;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:avatar_glow/avatar_glow.dart';

// ============================================================
// 1. MAIN
// ============================================================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Menyiapkan format tanggal Indonesia.
  await initializeDateFormatting('id_ID', null);

  runApp(const ContactHubApp());
}

// ============================================================
// 2. MODEL KONTAK
// ============================================================

class Kontak {
  final int id;
  final String nama;
  final String nomorTelepon;
  final String email;
  final String kategori;
  final DateTime tanggalDitambahkan;

  const Kontak({
    required this.id,
    required this.nama,
    required this.nomorTelepon,
    required this.email,
    required this.kategori,
    required this.tanggalDitambahkan,
  });
}

// ============================================================
// 3. ROOT APPLICATION
// ============================================================

class ContactHubApp extends StatelessWidget {
  const ContactHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4056D6)),
        scaffoldBackgroundColor: const Color(0xFFF4F6FC),
      ),
      home: const HalamanUtama(),
    );
  }
}

// ============================================================
// 4. HALAMAN UTAMA DAN CONVEX APP BAR
// ============================================================

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  int _selectedIndex = 0;

  late final List<Kontak> _daftarKontak;
  late final List<Widget> _halaman;

  @override
  void initState() {
    super.initState();

    _daftarKontak = _buatDataKontak();

    _halaman = [
      HalamanKontak(daftarKontak: _daftarKontak),
      HalamanCari(daftarKontak: _daftarKontak),
      const HalamanProfil(),
    ];
  }

  // ==========================================================
  // 5. MEMBUAT DATA DUMMY DENGAN FAKER
  // ==========================================================

  List<Kontak> _buatDataKontak() {
    final Faker faker = Faker();

    // Nama kontak menggunakan nama Indonesia.
    final List<String> namaIndonesia = [
      'Ahmad Fauzan',
      'Siti Nur Aisyah',
      'Muhammad Rizky Pratama',
      'Nabila Putri Lestari',
      'Aditya Firmansyah',
      'Nurul Hidayah',
      'Bagas Saputra',
      'Dinda Ayuningtyas',
      'Fajar Ramadhan',
      'Intan Permatasari',
      'Rizky Maulana',
      'Anisa Rahmawati',
      'Ilham Setiawan',
      'Putri Maharani',
      'Yoga Prasetyo',
      'Fitri Handayani',
      'Galih Kurniawan',
      'Laila Khairunnisa',
    ];

    // Kode awal nomor telepon Indonesia.
    final List<String> kodeNomor = [
      '11',
      '12',
      '13',
      '21',
      '22',
      '23',
      '52',
      '53',
    ];

    // Pembagian kategori kontak.
    final List<String> kategoriKontak = ['Keluarga', 'Teman', 'Kerja'];

    return List.generate(namaIndonesia.length, (index) {
      final nama = namaIndonesia[index];

      // Mengubah nama menjadi format email.
      final emailNama = nama.toLowerCase().replaceAll(
        RegExp(r'[^a-z0-9]+'),
        '.',
      );

      // Membuat 8 digit nomor secara acak dengan Faker.
      final String angkaAcak = List.generate(
        8,
        (_) => faker.randomGenerator.integer(10).toString(),
      ).join();

      // Memilih kode nomor secara acak.
      final String kode =
          kodeNomor[faker.randomGenerator.integer(kodeNomor.length)];

      final String nomorTelepon =
          '08$kode-${angkaAcak.substring(0, 4)}-'
          '${angkaAcak.substring(4)}';

      // Tanggal ditambahkan dibuat secara acak.
      final DateTime tanggal = DateTime.now().subtract(
        Duration(days: faker.randomGenerator.integer(730)),
      );

      return Kontak(
        id: index + 1,
        nama: nama,
        nomorTelepon: nomorTelepon,
        email: '$emailNama${index + 1}@example.com',
        kategori: kategoriKontak[index % 3],
        tanggalDitambahkan: tanggal,
      );
    });
  }

  // ==========================================================
  // 6. BUILD UTAMA
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final List<String> judulHalaman = [
      'Daftar Kontak',
      'Cari Kontak',
      'Profil Saya',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          judulHalaman[_selectedIndex],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF172554),
          ),
        ),
        backgroundColor: const Color(0xFFF4F6FC),
      ),

      // IndexedStack mempertahankan state halaman.
      body: IndexedStack(index: _selectedIndex, children: _halaman),

      // Navigasi bawah dari convex_bottom_bar.
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.react,
        backgroundColor: const Color(0xFF172554),
        color: Colors.white70,
        activeColor: Colors.white,
        initialActiveIndex: _selectedIndex,
        items: const [
          TabItem(icon: Icons.contacts_rounded, title: 'Kontak'),
          TabItem(icon: Icons.search_rounded, title: 'Cari'),
          TabItem(icon: Icons.person_rounded, title: 'Profil'),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

// ============================================================
// 7. HALAMAN KONTAK
// ============================================================

class HalamanKontak extends StatelessWidget {
  final List<Kontak> daftarKontak;

  const HalamanKontak({super.key, required this.daftarKontak});

  @override
  Widget build(BuildContext context) {
    final DateFormat formatTanggal = DateFormat('dd MMMM yyyy', 'id_ID');

    return Column(
      children: [
        // Header informasi kontak.
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 18),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4056D6), Color(0xFF7989F5)],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.contact_phone_rounded,
                size: 34,
                color: Colors.white,
              ),
              const SizedBox(height: 12),
              const Text(
                'Kontak Saya',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${daftarKontak.length} kontak tersimpan',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),

        // Judul daftar.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Semua Kontak',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172554),
                  ),
                ),
              ),
              Text(
                '${daftarKontak.length} data',
                style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Menampilkan kontak menggunakan ListView.builder.
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemCount: daftarKontak.length,
            itemBuilder: (context, index) {
              return KartuKontak(
                kontak: daftarKontak[index],
                formatTanggal: formatTanggal,
              );
            },
          ),
        ),
      ],
    );
  }
}

// ============================================================
// 8. WIDGET KARTU KONTAK
// ============================================================

class KartuKontak extends StatelessWidget {
  final Kontak kontak;
  final DateFormat formatTanggal;

  const KartuKontak({
    super.key,
    required this.kontak,
    required this.formatTanggal,
  });

  @override
  Widget build(BuildContext context) {
    final String inisial = kontak.nama
        .trim()
        .split(RegExp(r'\s+'))
        .take(2)
        .map((kata) => kata[0])
        .join()
        .toUpperCase();

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFFE4E8F2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: const Color(0xFFE8EEFF),
                  child: Text(
                    inisial,
                    style: const TextStyle(
                      color: Color(0xFF4056D6),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kontak.nama,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF172554),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        kontak.nomorTelepon,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ),

                // Label kategori.
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF1FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    kontak.kategori,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4056D6),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Email.
            Row(
              children: [
                const Icon(
                  Icons.email_outlined,
                  size: 17,
                  color: Colors.blueGrey,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    kontak.email,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 10),

            // Tanggal penambahan kontak.
            Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  size: 16,
                  color: Colors.blueGrey,
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    'Ditambahkan pada: '
                    '${formatTanggal.format(kontak.tanggalDitambahkan)}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 9. HALAMAN CARI - DROPDOWN SEARCH
// ============================================================

class HalamanCari extends StatefulWidget {
  final List<Kontak> daftarKontak;

  const HalamanCari({super.key, required this.daftarKontak});

  @override
  State<HalamanCari> createState() => _HalamanCariState();
}

class _HalamanCariState extends State<HalamanCari> {
  final List<String> _kategori = [
    'Semua Kategori',
    'Keluarga',
    'Teman',
    'Kerja',
  ];

  String _kategoriTerpilih = 'Semua Kategori';

  @override
  Widget build(BuildContext context) {
    // Filter kontak berdasarkan kategori.
    final List<Kontak> hasilFilter = _kategoriTerpilih == 'Semua Kategori'
        ? widget.daftarKontak
        : widget.daftarKontak
              .where((kontak) => kontak.kategori == _kategoriTerpilih)
              .toList();

    final DateFormat formatTanggal = DateFormat('dd MMMM yyyy', 'id_ID');

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cari Berdasarkan Kategori',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172554),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Pilih kategori untuk menampilkan kontak yang sesuai.',
            style: TextStyle(fontSize: 13, color: Colors.blueGrey),
          ),

          const SizedBox(height: 20),

          // DropdownSearch menggunakan data offline.
          DropdownSearch<String>(
            selectedItem: _kategoriTerpilih,

            // Sumber data kategori.
            items: (filter, loadProps) {
              return _kategori
                  .where(
                    (item) => item.toLowerCase().contains(filter.toLowerCase()),
                  )
                  .toList();
            },

            // Mengatur tampilan popup pencarian.
            popupProps: PopupProps.menu(
              showSearchBox: true,
              fit: FlexFit.loose,
              constraints: const BoxConstraints(maxHeight: 300),
            ),

            // Menangani kategori yang dipilih.
            onSelected: (String? value) {
              if (value == null) return;

              setState(() {
                _kategoriTerpilih = value;
              });
            },
          ),

          const SizedBox(height: 20),

          // Ringkasan hasil pencarian.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF1FF),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Icon(Icons.filter_list_rounded, color: Color(0xFF4056D6)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${hasilFilter.length} kontak ditemukan '
                    'dalam kategori $_kategoriTerpilih',
                    style: const TextStyle(
                      color: Color(0xFF172554),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Hasil pencarian.
          Expanded(
            child: hasilFilter.isEmpty
                ? const Center(child: Text('Kontak tidak ditemukan.'))
                : ListView.builder(
                    itemCount: hasilFilter.length,
                    itemBuilder: (context, index) {
                      return KartuKontak(
                        kontak: hasilFilter[index],
                        formatTanggal: formatTanggal,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 10. HALAMAN PROFIL - AVATAR GLOW
// ============================================================

class HalamanProfil extends StatelessWidget {
  const HalamanProfil({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 30),

          // AvatarGlow memberikan efek cahaya pada foto.
          AvatarGlow(
            glowColor: const Color(0xFF4056D6),
            duration: const Duration(seconds: 2),
            repeat: true,
            glowRadiusFactor: 0.8,
            child: Material(
              elevation: 8,
              shape: const CircleBorder(),
              color: Colors.white,
              child: CircleAvatar(
                radius: 65,
                backgroundColor: const Color(0xFFE8EEFF),
                child: ClipOval(
                  child: Image.network(
                    'https://i.pravatar.cc/300?img=12',
                    width: 130,
                    height: 130,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.person,
                        size: 75,
                        color: Color(0xFF4056D6),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            'Husain Aziz Al Rosyid',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172554),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Mahasiswa Sistem Informasi',
            style: TextStyle(fontSize: 14, color: Colors.blueGrey),
          ),

          const SizedBox(height: 5),

          const Text(
            'Semester 5 • UNIPDU Jombang',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF4056D6),
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 25),

          // Informasi profil.
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Color(0xFFE4E8F2)),
            ),
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.school_outlined,
                      color: Color(0xFF4056D6),
                    ),
                    title: Text('Program Studi'),
                    subtitle: Text('Sistem Informasi'),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.account_balance_outlined,
                      color: Color(0xFF4056D6),
                    ),
                    title: Text('Universitas'),
                    subtitle: Text('Universitas Pesantren Tinggi Darul Ulum'),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.location_on_outlined,
                      color: Color(0xFF4056D6),
                    ),
                    title: Text('Lokasi'),
                    subtitle: Text('Jombang, Jawa Timur'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Contact Hub App • Flutter 2026',
            style: TextStyle(fontSize: 12, color: Colors.blueGrey),
          ),
        ],
      ),
    );
  }
}
