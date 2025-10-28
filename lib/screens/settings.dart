import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/theme_preference.dart';

class SettingsPage extends StatefulWidget {
  final Function(Brightness brightness) changeTheme;

  const SettingsPage({
    super.key,
    required this.changeTheme,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String selectedTheme = 'light';

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final savedTheme = await ThemePreference.getTheme();
    setState(() {
      selectedTheme = savedTheme ?? 'light';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.pop(context),
              child: const Icon(OMIcons.arrowBack),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 36, right: 24),
            child: buildHeaderWidget(context),
          ),
          buildCardWidget(buildThemeSelector(context)),
        ],
      ),
    );
  }

  Widget buildThemeSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('App Theme',
            style: TextStyle(fontFamily: 'ZillaSlab', fontSize: 24)),
        const SizedBox(height: 20),
        Row(
          children: <Widget>[
            Radio<String>(
              value: 'light',
              groupValue: selectedTheme,
              onChanged: handleThemeSelection,
            ),
            const Text('Light theme', style: TextStyle(fontSize: 18)),
          ],
        ),
        Row(
          children: <Widget>[
            Radio<String>(
              value: 'dark',
              groupValue: selectedTheme,
              onChanged: handleThemeSelection,
            ),
            const Text('Dark theme', style: TextStyle(fontSize: 18)),
          ],
        ),
      ],
    );
  }



  Widget buildCardWidget(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 8),
            color: Colors.black.withAlpha(20),
            blurRadius: 16,
          ),
        ],
      ),
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }

  Widget buildHeaderWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 16, left: 8),
      child: Text(
        'Settings',
        style: TextStyle(
          fontFamily: 'ZillaSlab',
          fontWeight: FontWeight.w700,
          fontSize: 36,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  void handleThemeSelection(String? value) async {
    if (value == null) return;
    setState(() => selectedTheme = value);

    final brightness =
    value == 'light' ? Brightness.light : Brightness.dark;
    widget.changeTheme(brightness);

    await ThemePreference.setTheme(value);
  }
}
