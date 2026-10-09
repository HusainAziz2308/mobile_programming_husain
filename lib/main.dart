abstract class Orang {
  String nama;
  Orang(this.nama);
  void perkenalan();
}

class Mahasiswa extends Orang {
  String nim;
  List<int> nilaiTugas;

  Mahasiswa(String nama, this.nim, this.nilaiTugas) : super(nama);

  @override
  void perkenalan() {
    print("Nama Mahasiswa : $nama");
    print("NIM Mahasiswa  : $nim");
  }
}

double hitungRataRata(List<int> nilai) {
  if (nilai.isEmpty) {
    throw Exception("Nilai tugas tidak boleh kosong.");
  }

  int total = 0;

  for (int i = 0; i < nilai.length; i++) {
    total += nilai[i];
  }

  return total / nilai.length;
}

void tampilkanData(Mahasiswa mahasiswa) {
  mahasiswa.perkenalan();

  try {
    double rataRata = hitungRataRata(mahasiswa.nilaiTugas);

    String predikat = rataRata >= 80
        ? "Sangat Baik"
        : rataRata >= 60
            ? "Baik"
            : "Perlu Perbaikan";

    print("Nilai Tugas    : ${mahasiswa.nilaiTugas}");
    print("Rata-rata      : ${rataRata.toStringAsFixed(1)}");
    print("Predikat       : $predikat");
  } catch (e) {
    print("Terjadi kesalahan: $e");
  }

  print("------------------------------------------");
}

void tampilkanHeader() {
  print("==========================================");
  print(" PROGRAM MANAJEMEN DATA MAHASISWA SEDERHANA");
  print("==========================================");
  print("TUGAS PRAKTIKUM PERTEMUAN 2");
  print("Mata Kuliah : Mobile Programming");
  print("Program Studi: Sistem Informasi");
  print("------------------------------------------");
  print("IDENTITAS MAHASISWA");
  print("Nama        : Husain Aziz Al Rosyid");
  print("NIM         : 4124031");
  print("==========================================");
  print("");
}

void main() {
  tampilkanHeader();

  Mahasiswa mahasiswa1 = Mahasiswa(
    "Rahmi",
    "2224001",
    [85, 80, 90, 85],
  );

  Mahasiswa mahasiswa2 = Mahasiswa(
    "Surya",
    "2224002",
    [70, 65, 68, 71],
  );

  print("DATA MAHASISWA");
  print("------------------------------------------");

  tampilkanData(mahasiswa1);
  tampilkanData(mahasiswa2);
}