import 'package:flutter/material.dart';
import 'c_notes/providers/sqflite_notes_provider.dart';
import 'c_notes/screens/add_note_screen.dart';

/// ===============================                 =====================
/// ========== APP-WIDE ===========                 =====================
/// ===============================                 =====================

const double kPaddingBetweenDrawerIconAndText = 5;
const double kPaddingBetweenDrawerElements = 3;

/// ===============================                 =====================
/// ===========MAIN PAGE===========                 =====================
/// ===============================                 =====================

const Color kMainCustomizingColor = Color(0xffFABC18);
const Color topContainerColor = Color(0xffeaf0ff);
const Color bottomContainerColor = Colors.white;

const kTopBarIconColor = Colors.black;
const double kTabBarIconSize = 27;

const double kMainPageHeaderSize = 25;

const TextStyle kMainPageHeaderStyle = TextStyle(
  fontFamily: 'KumbhSans',
  fontWeight: FontWeight.w900,
  fontSize: kMainPageHeaderSize,
  color: Colors.black,
);

/// ---------- Card Main ----------

const TextStyle kCardTitleStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w700,
  color: Colors.black,
);
const TextStyle kCardTextStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w300,
  color: Colors.grey,
);

const TextStyle kMainPageListViewTitleStyle = TextStyle(
  fontFamily: 'KumbhSans',
  fontWeight: FontWeight.w900,
  fontSize: (kMainPageHeaderSize - 7),
  color: Colors.black,
);

/// ===============================                 =====================
/// ============ NOTES ============                 =====================
/// ===============================                 =====================

///States of a Note
const String kNote = 'Note';
const String kStared = 'Stared';
const String kArchived = 'Archived';
const String kDeleted = 'Deleted';

const TextStyle kDrawerElementStyle = TextStyle(
  fontSize: 15,
);

const TextStyle kDrawerLabelAndEdit = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w600,
  color: Colors.black54,
);

const TextStyle kDrawerLabelStyle = TextStyle(
  fontSize: 15,
);

const double kSpaceBetweenDrawerElements = 8;

const Map<int, Color> notesBackgroundColors = {
  0: Color(0xffffffff),
  1: Color(0xffD8AFFC),
  2: Color(0xffAFCBFA),
  3: Color(0xffCBF0F8),
  4: Color(0xffA8FEEB),
  5: Color(0xffCDFF90),
  6: Color(0xffFFF475),
  7: Color(0xffFBBD04),
  8: Color(0xfff38b82),
  9: Color(0xffCF4D6F),
  10: Color(0xff42265e),
  11: Color(0xff5b2345),
  12: Color(0xff442f18),
  13: Color(0xff3d3f43),
};

colorAntiMapping(Color color) {
  int temp = 0;
  for (Color _color in notesBackgroundColors.values) {
    if (color == _color) {
      return temp;
    }
    temp = temp + 1;
  }
  print('----------- CONTANTS ColorAntiMapping ERROR');
}

/// ---------- Vital Functions ----------

void providerInsertNote(String _title, String _text, int _noteBackgroundColor, int _labelID, String _label, TypeOfNote _typeOfNote) async {
  await SQFLiteNotesProvider.insertNote({
    'title': _title,
    'text': _text,
    'color': _noteBackgroundColor,
    'labelid': _labelID,
    'label': _label,
    'state': getCategoryThroughEnum(_typeOfNote),
  });
}

/// ---------- NotesDrawer ----------

const double kDrawerPadding = 15;
const int maxNoteLabelID = 1000000;

/// ===============================                 =====================
/// ==========TIME TRACKER=========                 =====================
/// ===============================                 =====================

int convertTimeForServer(int hrs, String mins) {
  int time = 0;
  time = hrs * 60;
  // We need to convert [mins] to int.
  time = time + int.parse(mins);
  return time;
}

Map convertServerTimeData(int dataHr) {
  int hr, min;
  String amPm;

  if (dataHr > 12 * 60) {
    amPm = 'PM';
    dataHr = dataHr - 12 * 60;
  } else {
    amPm = 'AM';
    hr = dataHr;
  }

  hr = (dataHr ~/ 60);
  min = dataHr - hr * 60;

  if (hr == 0 && amPm == 'PM') hr = 12;
  //String time = '$hr:${min.toString().padLeft(2, '0')} $amPm';
  Map time = {'hr': hr, 'min': min.toString().padLeft(2, '0'), 'amPm': amPm};
  return time;
}

const Map<int, String> monthsInYear = {
  1: 'Jan',
  2: 'Feb',
  3: 'Mar',
  4: 'Apr',
  5: 'May',
  6: 'Jun',
  7: 'Jul',
  8: 'Aug',
  9: 'Sep',
  10: 'Oct',
  11: 'Nov',
  12: 'Dec',
};

const List<Text> hrs = [
  Text('0'),
  Text('1'),
  Text('2'),
  Text('3'),
  Text('4'),
  Text('5'),
  Text('6'),
  Text('7'),
  Text('8'),
  Text('9'),
  Text('10'),
  Text('11'),
  Text('12'),
  Text('13'),
  Text('14'),
  Text('15'),
  Text('16'),
  Text('17'),
  Text('18'),
  Text('19'),
  Text('20'),
  Text('21'),
  Text('22'),
  Text('23'),
];

const List<Text> mins = [
  Text('00'),
  Text('01'),
  Text('02'),
  Text('03'),
  Text('04'),
  Text('05'),
  Text('06'),
  Text('07'),
  Text('08'),
  Text('09'),
  Text('10'),
  Text('11'),
  Text('12'),
  Text('13'),
  Text('14'),
  Text('15'),
  Text('16'),
  Text('17'),
  Text('18'),
  Text('19'),
  Text('20'),
  Text('21'),
  Text('22'),
  Text('23'),
  Text('24'),
  Text('25'),
  Text('26'),
  Text('27'),
  Text('28'),
  Text('29'),
  Text('30'),
  Text('31'),
  Text('32'),
  Text('33'),
  Text('34'),
  Text('35'),
  Text('36'),
  Text('37'),
  Text('38'),
  Text('39'),
  Text('40'),
  Text('41'),
  Text('42'),
  Text('43'),
  Text('44'),
  Text('45'),
  Text('46'),
  Text('47'),
  Text('48'),
  Text('49'),
  Text('50'),
  Text('51'),
  Text('52'),
  Text('53'),
  Text('54'),
  Text('55'),
  Text('56'),
  Text('57'),
  Text('58'),
  Text('59'),
];
