import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../lib/main.dart';

void main() {
  // Menguji aplikasi Contact Hub.
  testWidgets(
    'Contact Hub menampilkan halaman utama',
    (WidgetTester tester) async {
      await initializeDateFormatting('id_ID', null);

      await tester.pumpWidget(
        const ContactHubApp(),
      );

      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
      );

      expect(
        find.text('Daftar Kontak'),
        findsOneWidget,
      );

      expect(
        find.text('Semua Kontak'),
        findsOneWidget,
      );

      expect(
        find.text('Ahmad Fauzan'),
        findsOneWidget,
      );

      expect(
        find.text('Siti Nur Aisyah'),
        findsOneWidget,
      );
    },
  );
}
