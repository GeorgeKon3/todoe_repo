import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoe/z_main_menus/login_page.dart';
import 'package:todoe/z_main_menus/splash_page.dart';
import 'a_boards/board_screen.dart';
import 'b_schedule/schedule_screen.dart';
import 'c_notes/models/note.dart';
import 'c_notes/notes_screen.dart';
import 'c_notes/providers/sqflite_ labels_provider.dart';
import 'c_notes/providers/sqflite_notes_provider.dart';
import 'constants.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'z_main_menus/discover_screen.dart';

//void main() => runApp(MyApp());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// The line of code below comes from the package flutter_statusbarcolor: ^0.2.3
    /// This package is only used to customize the color of the status bar.
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Note>(create: (context) => Note()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainScreen(),
      ),
    );
  }
}

/// ======================================
/// ============ For Login ===============
/// ======================================

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Now, user's data can be accessed through Provider package
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return SplashPage();
        if (!snapshot.hasData || snapshot.data == null) return LoginPage();
        return MyHomePage();
      },
    );
  }
}

/// ======================================
/// =========== After Login ==============
/// ======================================

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<StatefulWidget> pages = [
    BoardScreen(),
    ScheduleScreen(),
    NotesScreen(),
    DiscoverScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        body: TabBarView(
          children: pages,
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.only(top: 3, bottom: 0),
            child: TabBar(
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.home,
                    size: kTabBarIconSize,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.insert_chart,
                    size: kTabBarIconSize,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.note_add,
                    size: kTabBarIconSize,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.class_,
                    size: kTabBarIconSize,
                  ),
                ),
              ],
              unselectedLabelColor: Colors.grey[800],
              labelColor: kMainCustomizingColor,
              indicatorColor: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    newUsersOnly();
    super.initState();
  }

  void newUsersOnly() async {
    final _notes = await SQFLiteNotesProvider.getWholeNoteList();
    //Todo: Delete vv
    //final _tasks = await SQFLiteTasksProvider.getWholeTaskList();
    final _labels = await SQFLiteLabelsProvider.getNoteLabelList();

    if (_notes.length == 0) {
      SQFLiteNotesProvider.insertNote({
        'title': 'Welcome to Todoe Notes',
        'text': 'You can keep all your ideas nice & saved here.',
        'color': 0,
        'labelid': maxNoteLabelID,
        'label': '0. Welcome Tutorial',
        'state': kNote
      });
      SQFLiteNotesProvider.insertNote({
        'title': 'Start exploring all its capabilities now!',
        'text':
            'Step 1: Tap on the note above and edit it.\nStep 2: Tap on the hamburger menu on the top left of the app',
        'color': 0,
        'labelid': maxNoteLabelID,
        'label': '0. Welcome Tutorial',
        'state': kNote
      });
    }

    if (_labels.length == 0) {
      SQFLiteLabelsProvider.insertNoteLabel({'title': '1. University'});
      SQFLiteLabelsProvider.insertNoteLabel({'title': '2. Social Life'});
      SQFLiteLabelsProvider.insertNoteLabel({'title': '3. Side Hustle'});
      SQFLiteLabelsProvider.insertNoteLabel({'title': '4. Hobby'});
      SQFLiteLabelsProvider.insertNoteLabel({'title': '5. Random Thoughts'});
    }
  }
}
