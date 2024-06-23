import 'package:flutter/material.dart';

class LanguageScreen extends StatefulWidget {
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String? _selectedLanguage;

  void _setSelectedLanguage(String language) {
    setState(() {
      _selectedLanguage = language;
    });
  }

  void _doneSelecting() {
    if (_selectedLanguage != null) {
      // Logic to set the selected language
      // Example: You can use a provider or set a preference
    }
    Navigator.pop(context); // Close the language screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Language'),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: _doneSelecting,
          )
        ],
      ),
      body: ListView(
        children: [
          LanguageOption(
            language: 'English',
            isSelected: _selectedLanguage == 'English',
            avatar: CircleAvatar(child: Text('EN')),
            onTap: () {
              _setSelectedLanguage('English');
            },
          ),
          LanguageOption(
            language: 'Spanish (Español)',
            isSelected: _selectedLanguage == 'Spanish (Español)',
            avatar: CircleAvatar(child: Text('ES')),
            onTap: () {
              _setSelectedLanguage('Spanish (Español)');
            },
          ),
          LanguageOption(
            language: 'French (Français)',
            isSelected: _selectedLanguage == 'French (Français)',
            avatar: CircleAvatar(child: Text('FR')),
            onTap: () {
              _setSelectedLanguage('French (Français)');
            },
          ),
          LanguageOption(
            language: 'Korean (한국어)',
            isSelected: _selectedLanguage == 'Korean (한국어)',
            avatar: CircleAvatar(child: Text('KO')),
            onTap: () {
              _setSelectedLanguage('Korean (한국어)');
            },
          ),
          LanguageOption(
            language: 'Hindi (हिंदी)',
            isSelected: _selectedLanguage == 'Hindi (हिंदी)',
            avatar: CircleAvatar(child: Text('HI')),
            onTap: () {
              _setSelectedLanguage('Hindi (हिंदी)');
            },
          ),
          LanguageOption(
            language: 'Indonesian (Bahasa Indonesia)',
            isSelected: _selectedLanguage == 'Indonesian (Bahasa Indonesia)',
            avatar: CircleAvatar(child: Text('ID')),
            onTap: () {
              _setSelectedLanguage('Indonesian (Bahasa Indonesia)');
            },
          ),
          LanguageOption(
            language: 'German (Deutsch)',
            isSelected: _selectedLanguage == 'German (Deutsch)',
            avatar: CircleAvatar(child: Text('DE')),
            onTap: () {
              _setSelectedLanguage('German (Deutsch)');
            },
          ),
          LanguageOption(
            language: 'Italian (Italiano)',
            isSelected: _selectedLanguage == 'Italian (Italiano)',
            avatar: CircleAvatar(child: Text('IT')),
            onTap: () {
              _setSelectedLanguage('Italian (Italiano)');
            },
          ),
          LanguageOption(
            language: 'Russian (Русский)',
            isSelected: _selectedLanguage == 'Russian (Русский)',
            avatar: CircleAvatar(child: Text('RU')),
            onTap: () {
              _setSelectedLanguage('Russian (Русский)');
            },
          ),
          LanguageOption(
            language: 'Chinese (中文)',
            isSelected: _selectedLanguage == 'Chinese (中文)',
            avatar: CircleAvatar(child: Text('ZH')),
            onTap: () {
              _setSelectedLanguage('Chinese (中文)');
            },
          ),
          LanguageOption(
            language: 'Portuguese (Português)',
            isSelected: _selectedLanguage == 'Portuguese (Português)',
            avatar: CircleAvatar(child: Text('PT')),
            onTap: () {
              _setSelectedLanguage('Portuguese (Português)');
            },
          ),
        ],
      ),
    );
  }
}

class LanguageOption extends StatelessWidget {
  final String language;
  final bool isSelected;
  final CircleAvatar avatar;
  final VoidCallback onTap;

  const LanguageOption({
    required this.language,
    required this.isSelected,
    required this.avatar,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: avatar,
      title: Text(language),
      trailing: isSelected ? Icon(Icons.check_circle, color: Colors.blue) : Icon(Icons.circle_outlined),
      onTap: onTap,
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LanguageScreen(),
  ));
}
