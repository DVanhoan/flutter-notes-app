import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_notes_app/data/models.dart';
import 'package:flutter_notes_app/services/database.dart';

class EditNotePage extends StatefulWidget {
  final VoidCallback triggerRefetch;
  final NotesModel? existingNote;

  const EditNotePage({
    super.key,
    required this.triggerRefetch,
    this.existingNote,
  });

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  bool isDirty = false;
  bool isNoteNew = true;
  final FocusNode titleFocus = FocusNode();
  final FocusNode contentFocus = FocusNode();

  late NotesModel currentNote;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingNote == null) {
      currentNote = NotesModel(
        title: '',
        content: '',
        date: DateTime.now(),
        isImportant: false,
      );
      isNoteNew = true;
    } else {
      currentNote = widget.existingNote!;
      isNoteNew = false;
    }

    titleController.text = currentNote.title;
    contentController.text = currentNote.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  focusNode: titleFocus,
                  controller: titleController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textInputAction: TextInputAction.next,
                  autofocus: true,
                  style: const TextStyle(
                    fontFamily: 'ZillaSlab',
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: InputDecoration.collapsed(
                    hintText: 'Enter a title',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 32,
                      fontFamily: 'ZillaSlab',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onChanged: (_) => setState(() => isDirty = true),
                  onSubmitted: (_) {
                    titleFocus.unfocus();
                    FocusScope.of(context).requestFocus(contentFocus);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  focusNode: contentFocus,
                  controller: contentController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration.collapsed(
                    hintText: 'Start typing...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onChanged: (_) => setState(() => isDirty = true),
                ),
              ),
            ],
          ),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: 80,
                color: Theme.of(context).colorScheme.surface.withOpacity(0.3),
                child: SafeArea(
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: handleBack,
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: 'Mark note as important',
                        icon: Icon(currentNote.isImportant
                            ? Icons.flag
                            : Icons.outlined_flag),
                        onPressed: titleController.text.trim().isNotEmpty &&
                            contentController.text.trim().isNotEmpty
                            ? markImportantAsDirty
                            : null,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: handleDelete,
                      ),
                      AnimatedContainer(
                        margin: const EdgeInsets.only(left: 10),
                        duration: const Duration(milliseconds: 200),
                        width: isDirty ? 100 : 0,
                        height: 42,
                        curve: Curves.decelerate,
                        child: FilledButton.icon(
                          icon: const Icon(Icons.done),
                          label: const Text(
                            'SAVE',
                            style: TextStyle(letterSpacing: 1),
                          ),
                          onPressed: handleSave,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> handleSave() async {
    setState(() {
      currentNote.title = titleController.text;
      currentNote.content = contentController.text;
    });

    if (isNoteNew) {
      var latestNote = await NotesDatabaseService.db.addNoteInDB(currentNote);
      setState(() => currentNote = latestNote);
    } else {
      await NotesDatabaseService.db.updateNoteInDB(currentNote);
    }

    setState(() {
      isNoteNew = false;
      isDirty = false;
    });

    widget.triggerRefetch();
    titleFocus.unfocus();
    contentFocus.unfocus();
  }

  void markImportantAsDirty() {
    setState(() {
      currentNote.isImportant = !currentNote.isImportant;
    });
    handleSave();
  }

  Future<void> handleDelete() async {
    if (isNoteNew) {
      Navigator.pop(context);
    } else {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text('Delete Note'),
          content: const Text('This note will be deleted permanently'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                'DELETE',
                style: TextStyle(
                  color: Colors.red.shade300,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'CANCEL',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      );

      if (confirm == true) {
        await NotesDatabaseService.db.deleteNoteInDB(currentNote);
        widget.triggerRefetch();
        if (context.mounted) Navigator.pop(context);
      }
    }
  }

  void handleBack() {
    Navigator.pop(context);
  }
}
