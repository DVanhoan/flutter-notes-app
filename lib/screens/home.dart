import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import '../components/cards.dart';
import '../components/faderoute.dart';
import '../data/models.dart';
import '../services/database.dart';
import 'edit.dart';
import 'settings.dart';
import 'view.dart';

class MyHomePage extends StatefulWidget {
  final Function(Brightness brightness) changeTheme;
  final String title;

  const MyHomePage({
    super.key,
    required this.title,
    required this.changeTheme,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isFlagOn = false;
  bool headerShouldHide = false;
  List<NotesModel> notesList = [];
  final TextEditingController searchController = TextEditingController();
  bool isSearchEmpty = true;

  @override
  void initState() {
    super.initState();
    NotesDatabaseService.db.init();
    setNotesFromDB();
  }

  Future<void> setNotesFromDB() async {
    debugPrint("Entered setNotes");
    final fetchedNotes = await NotesDatabaseService.db.getNotesFromDB();
    setState(() {
      notesList = fetchedNotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: gotoEditNote,
        label: Text('ADD NOTE'),
        icon: const Icon(Icons.add),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(top: 2),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => SettingsPage(
                            changeTheme: widget.changeTheme,
                          ),
                        ),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(16),
                      alignment: Alignment.centerRight,
                      child: Icon(
                        OMIcons.settings,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey.shade600
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                ],
              ),
              buildHeaderWidget(context),
              buildButtonRow(),
              buildImportantIndicatorText(),
              const SizedBox(height: 32),
              ...buildNoteComponentsList(),
              GestureDetector(
                onTap: gotoEditNote,
                child: const AddNoteCardComponent(),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Nút Flag + Search
  Widget buildButtonRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isFlagOn = !isFlagOn;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              height: 50,
              width: 50,
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: isFlagOn ? Colors.blue : Colors.transparent,
                border: Border.all(
                  width: isFlagOn ? 2 : 1,
                  color:
                  isFlagOn ? Colors.blue.shade700 : Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                isFlagOn ? Icons.flag : OMIcons.flag,
                color: isFlagOn ? Colors.white : Colors.grey.shade300,
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.only(left: 16),
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      maxLines: 1,
                      onChanged: handleSearch,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 16,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isSearchEmpty ? Icons.search : Icons.cancel,
                      color: Colors.grey.shade400,
                    ),
                    onPressed: cancelSearch,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Header “Your Notes”
  Widget buildHeaderWidget(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeIn,
          margin: const EdgeInsets.only(top: 8, bottom: 32, left: 10),
          width: headerShouldHide ? 0 : 200,
          child: Text(
            'Your Notes',
            style: TextStyle(
              fontFamily: 'ZillaSlab',
              fontWeight: FontWeight.w700,
              fontSize: 36,
              color: Theme.of(context).primaryColor,
            ),
            overflow: TextOverflow.clip,
            softWrap: false,
          ),
        ),
      ],
    );
  }

  /// 🔹 Hiển thị dòng thông báo “Only showing important notes”
  Widget buildImportantIndicatorText() {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 200),
      firstChild: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          'ONLY SHOWING NOTES MARKED IMPORTANT',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.blue,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      secondChild: const SizedBox(height: 2),
      crossFadeState:
      isFlagOn ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }

  /// 🔹 Danh sách ghi chú
  List<Widget> buildNoteComponentsList() {
    final List<Widget> noteComponentsList = [];
    notesList.sort((a, b) => b.date.compareTo(a.date));

    final filteredNotes = notesList.where((note) {
      if (searchController.text.isNotEmpty) {
        final query = searchController.text.toLowerCase();
        return note.title.toLowerCase().contains(query) ||
            note.content.toLowerCase().contains(query);
      }
      if (isFlagOn) return note.isImportant;
      return true;
    });

    for (final note in filteredNotes) {
      noteComponentsList.add(
        NoteCardComponent(
          noteData: note,
          onTapAction: openNoteToRead,
        ),
      );
    }

    return noteComponentsList;
  }

  /// 🔹 Tìm kiếm
  void handleSearch(String value) {
    setState(() => isSearchEmpty = value.isEmpty);
  }

  /// 🔹 Chuyển đến trang tạo note
  void gotoEditNote() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) =>
            EditNotePage(triggerRefetch: refetchNotesFromDB),
      ),
    );
  }

  /// 🔹 Tải lại notes sau khi chỉnh sửa
  Future<void> refetchNotesFromDB() async {
    await setNotesFromDB();
    debugPrint("Refetched notes");
  }

  /// 🔹 Mở note để đọc
  Future<void> openNoteToRead(NotesModel noteData) async {
    setState(() => headerShouldHide = true);
    await Future.delayed(const Duration(milliseconds: 230));
    await Navigator.push(
      context,
      FadeRoute(
        page: ViewNotePage(
          triggerRefetch: refetchNotesFromDB,
          currentNote: noteData,
        ),
      ),
    );
    setState(() => headerShouldHide = false);
  }

  /// 🔹 Hủy tìm kiếm
  void cancelSearch() {
    FocusScope.of(context).unfocus();
    setState(() {
      searchController.clear();
      isSearchEmpty = true;
    });
  }
}
