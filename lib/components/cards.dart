import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/models.dart';

final List<Color> colorList = [
  Colors.blue,
  Colors.green,
  Colors.indigo,
  Colors.red,
  Colors.cyan,
  Colors.teal,
  Colors.amber.shade900,
  Colors.deepOrange,
];

class NoteCardComponent extends StatelessWidget {
  final NotesModel noteData;
  final Function(NotesModel noteData) onTapAction;

  const NoteCardComponent({
    required this.noteData,
    required this.onTapAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final String neatDate = DateFormat.yMd().add_jm().format(noteData.date);
    final Color color = colorList[noteData.title.length % colorList.length];

    return Container(
      margin: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [buildBoxShadow(color, context)],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        color: Theme.of(context).colorScheme.surface,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => onTapAction(noteData),
          splashColor: color.withAlpha(30),
          highlightColor: color.withAlpha(15),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  noteData.title.trim().length <= 20
                      ? noteData.title.trim()
                      : '${noteData.title.trim().substring(0, 20)}...',
                  style: TextStyle(
                    fontFamily: 'ZillaSlab',
                    fontSize: 20,
                    fontWeight: noteData.isImportant
                        ? FontWeight.w800
                        : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  noteData.content.trim().split('\n').first.length <= 30
                      ? noteData.content.trim().split('\n').first
                      : '${noteData.content.trim().split('\n').first.substring(0, 30)}...',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                  ),
                ),
                const Spacer(),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.flag,
                      size: 16,
                      color: noteData.isImportant ? color : Colors.transparent,
                    ),
                    const Spacer(),
                    Text(
                      neatDate,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxShadow buildBoxShadow(Color color, BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxShadow(
      color: isDark
          ? (noteData.isImportant
          ? Colors.black.withAlpha(100)
          : Colors.black.withAlpha(30))
          : (noteData.isImportant
          ? color.withAlpha(80)
          : color.withAlpha(30)),
      blurRadius: 8,
      offset: const Offset(0, 6),
    );
  }
}

class AddNoteCardComponent extends StatelessWidget {
  const AddNoteCardComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      height: 110,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.add, color: borderColor),
              const SizedBox(width: 8),
              Text(
                'Add new note',
                style: TextStyle(
                  fontFamily: 'ZillaSlab',
                  color: borderColor,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
