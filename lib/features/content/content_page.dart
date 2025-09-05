import 'package:flutter/material.dart';

class ContentPage extends StatelessWidget {
  final String slug;
  const ContentPage({super.key, required this.slug});

  String get title {
    switch (slug) {
      case 'contact': return 'צור קשר';
      case 'cancel': return 'ביטול עסקה';
      case 'tips': return 'טיפים';
      case 'terms': return 'תקנון';
      case 'privacy': return 'פרטיות';
      case 'feedback': return 'משוב';
      case 'accessibility': return 'הצהרת נגישות';
      default: return 'מידע';
    }
  }

  String get body => switch (slug) {
    'contact' => 'פנו אלינו במייל support@example.com או בטופס מקוון.',
    'cancel' => 'מדיניות ביטול עסקה בהתאם לחוקי מדינת ישראל.',
    'tips' => 'טיפ: הוסיפו תמונות איכותיות וכותרת ברורה.',
    'terms' => 'תקנון שימוש – טיוטה.',
    'privacy' => 'מדיניות פרטיות – טיוטה.',
    'feedback' => 'נשמח למשוב! שלחו רעיונות לשיפור.',
    'accessibility' => 'האתר פועל בשאיפה לעמידה בהנחיות AA.',
    _ => 'תוכן יתווסף בהמשך.',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(padding: const EdgeInsets.all(16), child: Text(body, textAlign: TextAlign.start)),
    );
  }
}
