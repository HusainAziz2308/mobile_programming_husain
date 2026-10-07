import 'package:flutter/material.dart';

void main() {
  runApp(const MobileProgrammingHusain());
}

// ======================================================
// APP UTAMA
// ======================================================

class MobileProgrammingHusain extends StatelessWidget {
  const MobileProgrammingHusain({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mobile Programming Husain',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

// ======================================================
// MAIN PAGE + BOTTOM NAVIGATION
// ======================================================

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    TugasPage(),
    JadwalPage(),
    ProfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Programming'),
        centerTitle: true,
      ),
      body: pages[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'Tugas',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Jadwal',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// ======================================================
// HALAMAN BERANDA
// ======================================================

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SAPAAN
          const Text(
            'Halo, Husain 👋',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Semangat belajar hari ini!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),

          const SizedBox(height: 20),

          // CARD PROFIL
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    child: Icon(
                      Icons.person,
                      size: 35,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Husain Aziz Al Rosyid',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text('Sistem Informasi'),
                      Text('Semester 5'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // STATISTIK
          const Text(
            'Ringkasan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.assignment,
                  title: 'Tugas',
                  value: '8',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.check_circle,
                  title: 'Selesai',
                  value: '5',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.access_time,
                  title: 'Pending',
                  value: '3',
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // MENU CEPAT
          const Text(
            'Menu Cepat',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _QuickMenu(
                  icon: Icons.add_task,
                  title: 'Tambah Tugas',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickMenu(
                  icon: Icons.calendar_month,
                  title: 'Lihat Jadwal',
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // TUGAS TERBARU
          const Text(
            'Tugas Terbaru',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          _TaskItem(
            title: 'Pemodelan Dimensional',
            deadline: 'Deadline: 10 Oktober 2026',
          ),

          _TaskItem(
            title: 'Mobile Programming',
            deadline: 'Deadline: 12 Oktober 2026',
          ),

          _TaskItem(
            title: 'Enterprise Resource Planning',
            deadline: 'Deadline: 15 Oktober 2026',
          ),
        ],
      ),
    );
  }
}

// ======================================================
// STAT CARD
// ======================================================

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// QUICK MENU
// ======================================================

class _QuickMenu extends StatelessWidget {
  final IconData icon;
  final String title;

  const _QuickMenu({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// TASK ITEM DI BERANDA
// ======================================================

class _TaskItem extends StatelessWidget {
  final String title;
  final String deadline;

  const _TaskItem({
    required this.title,
    required this.deadline,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(
          Icons.assignment_outlined,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(deadline),
        trailing: const Icon(
          Icons.chevron_right,
        ),
      ),
    );
  }
}

// ======================================================
// MODEL TASK
// ======================================================

class Task {
  String title;
  DateTime deadline;
  bool isDone;

  Task({
    required this.title,
    required this.deadline,
    this.isDone = false,
  });
}

// ======================================================
// HALAMAN TUGAS
// ======================================================

class TugasPage extends StatefulWidget {
  const TugasPage({super.key});

  @override
  State<TugasPage> createState() => _TugasPageState();
}

class _TugasPageState extends State<TugasPage> {
  final List<Task> tasks = [
    Task(
      title: 'Pemodelan Dimensional',
      deadline: DateTime(2026, 10, 10),
    ),
    Task(
      title: 'Mobile Programming',
      deadline: DateTime(2026, 10, 12),
    ),
    Task(
      title: 'Enterprise Resource Planning',
      deadline: DateTime(2026, 10, 15),
    ),
  ];

  final TextEditingController titleController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();

  DateTime? selectedDeadline;

  @override
  void dispose() {
    titleController.dispose();
    deadlineController.dispose();
    super.dispose();
  }

  // ====================================================
  // FORMAT TANGGAL
  // ====================================================

  String formatDate(DateTime date) {
    const monthNames = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return '${date.day} ${monthNames[date.month - 1]} ${date.year}';
  }

  // ====================================================
  // TAMBAH TUGAS
  // ====================================================

  void addTask() {
    titleController.clear();
    deadlineController.clear();
    selectedDeadline = null;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Tugas'),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // NAMA TUGAS
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Nama tugas',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // DEADLINE
              TextField(
                controller: deadlineController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Deadline',
                  hintText: 'Pilih tanggal',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(
                    Icons.calendar_month,
                  ),
                ),
                onTap: () async {
                  final now = DateTime.now();

                  final today = DateTime(
                    now.year,
                    now.month,
                    now.day,
                  );

                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDeadline ?? today,
                    firstDate: today,
                    lastDate: DateTime(2035),
                  );

                  if (pickedDate != null) {
                    selectedDeadline = pickedDate;

                    deadlineController.text = formatDate(
                      pickedDate,
                    );
                  }
                },
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),

            ElevatedButton(
              onPressed: () {
                if (titleController.text.isEmpty ||
                    selectedDeadline == null) {
                  return;
                }

                setState(() {
                  tasks.add(
                    Task(
                      title: titleController.text,
                      deadline: selectedDeadline!,
                    ),
                  );
                });

                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  // ====================================================
  // UBAH STATUS TUGAS
  // ====================================================

  void toggleTask(int index, bool? value) {
    setState(() {
      tasks[index].isDone = value ?? false;
    });
  }

  // ====================================================
  // HAPUS TUGAS
  // ====================================================

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  // ====================================================
  // HALAMAN TUGAS
  // ====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tasks.isEmpty
          ? const Center(
              child: Text(
                'Belum ada tugas',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Checkbox(
                      value: task.isDone,
                      onChanged: (value) {
                        toggleTask(index, value);
                      },
                    ),

                    title: Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: task.isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),

                    subtitle: Text(
                      'Deadline: ${formatDate(task.deadline)}',
                    ),

                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                      ),
                      onPressed: () {
                        deleteTask(index);
                      },
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: addTask,
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}

// ======================================================
// HALAMAN JADWAL
// ======================================================

class JadwalPage extends StatelessWidget {
  const JadwalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Halaman Jadwal',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ======================================================
// HALAMAN PROFIL
// ======================================================

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Halaman Profil',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}