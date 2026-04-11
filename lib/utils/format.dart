import 'package:intl/intl.dart';

/// Helpers de formatage pour dates et montants.
class Fmt {
  static final DateFormat _shortDate = DateFormat('dd/MM/yyyy', 'fr_FR');
  static final DateFormat _longDate =
      DateFormat('d MMMM yyyy', 'fr_FR');
  static final NumberFormat _fcfa = NumberFormat('#,##0', 'fr_FR');

  static String date(DateTime d) => _shortDate.format(d);
  static String dateLong(DateTime d) => _longDate.format(d);

  /// Formate un montant en FCFA : "125 000 FCFA".
  static String fcfa(num amount) => '${_fcfa.format(amount)} FCFA';

  /// Formate un nombre décimal : "12,5".
  static String number(num value, {int decimals = 1}) =>
      NumberFormat.decimalPattern('fr_FR')
          .format(double.parse(value.toStringAsFixed(decimals)));
}
