import 'package:intl/intl.dart';

class DateFormatter {
  // Format: 18 Nov 2025
  static String formatShortDate(DateTime date) {
    return DateFormat('d MMM y', 'fr_FR').format(date);
  }

  // Format: 18 novembre 2025
  static String formatLongDate(DateTime date) {
    return DateFormat('d MMMM y', 'fr_FR').format(date);
  }

  // Format: 18/11/2025
  static String formatNumericDate(DateTime date) {
    return DateFormat('dd/MM/y').format(date);
  }

  // Format: 18/11/2025 14:30
  static String formatDateTime(DateTime date) {
    return DateFormat('dd/MM/y HH:mm').format(date);
  }

  // Format: 14:30
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  // Format: 18 Nov 2025 à 14:30
  static String formatFullDateTime(DateTime date) {
    return DateFormat('d MMM y à HH:mm', 'fr_FR').format(date);
  }

  // Format: Lundi 18 novembre 2025
  static String formatFullDateWithDay(DateTime date) {
    return DateFormat('EEEE d MMMM y', 'fr_FR').format(date);
  }

  // Temps relative (il y a 2 heures, il y a 3 jours, etc.)
  static String formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return "à l'instant";
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return 'il y a $minutes minute${minutes > 1 ? 's' : ''}';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return 'il y a $hours heure${hours > 1 ? 's' : ''}';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return 'il y a $days jour${days > 1 ? 's' : ''}';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'il y a $weeks semaine${weeks > 1 ? 's' : ''}';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'il y a $months mois';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'il y a $years an${years > 1 ? 's' : ''}';
    }
  }

  // Parser une chaîne ISO 8601 en DateTime
  static DateTime? parseIsoString(String? isoString) {
    if (isoString == null || isoString.isEmpty) return null;
    try {
      return DateTime.parse(isoString);
    } catch (e) {
      return null;
    }
  }

  // Verifier si la date est aujourd'hui
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Verifier si la date est hier
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  // Obtenir la différence en jours entre une date donnée et aujourd'hui
  static int getDaysDifference(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    return difference.inDays;
  }

  // Format pour affichage intelligent
  static String formatSmartDate(DateTime date) {
    if (isToday(date)) {
      return "Aujourd'hui à ${formatTime(date)}";
    } else if (isYesterday(date)) {
      return 'Hier à ${formatTime(date)}';
    } else if (getDaysDifference(date) < 7) {
      return formatRelativeTime(date);
    } else {
      return formatShortDate(date);
    }
  }
}