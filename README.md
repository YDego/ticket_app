# הוראות הרצה מהירה (Flutter + Supabase)

## התקנות מקדימות
1. ודא שהתקנת:
   - Flutter SDK
   - VS Code עם התוספים Flutter + Dart
   - Android Studio/Xcode (לאמולטורים)

## איך להריץ
1. שים את הקובץ `launch.json` בתיקייה:
   ```
   .vscode/launch.json
   ```

2. פתח את הפרויקט ב‑VS Code.

3. התקן חבילות דרושות:
   ```bash
   flutter pub add supabase_flutter go_router intl url_launcher share_plus
   ```

4. לחץ **F5** או Run → Start Debugging.

   זה יריץ את האפליקציה עם ההגדרות של Supabase שלך:

   - URL: `https://xiosnyehoadyljwcicja.supabase.co`
   - ANON KEY: כבר מוגדר ב‑launch.json

## בדיקה ראשונית
- במסך הראשון תראה לוגין/הרשמה.
- תוכל להירשם עם אימייל + סיסמה → תועבר למסך הבית.

## טיפ
אם רוצים להריץ ידנית בלי VS Code:
```bash
flutter run --dart-define=SUPABASE_URL=https://xiosnyehoadyljwcicja.supabase.co --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inhpb3NueWVob2FkeWxqd2NpY2phIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU4MDgxMzksImV4cCI6MjA3MTM4NDEzOX0.Ix1oANaPusbm6aWic9oo4j2Rta2UlHS4LXOrSkqjk3w
```
