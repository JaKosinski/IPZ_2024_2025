
class Tools {
  static timeDiffrence(DateTime other) {
    DateTime today = DateTime.now();
    DateTime todayMidnight = DateTime(today.year, today.month, today.day);
    DateTime otherMidnight = DateTime(other.year, other.month, other.year);

    final Duration diffrence = otherMidnight.difference(todayMidnight);

    return diffrence.inDays;
  }
}