import 'package:flutter/material.dart';
import 'ui/pages/feed_list_page.dart';
import 'themes/theme_model.dart';
// import 'themes/theme_preferences.dart';
import 'package:provider/provider.dart';
void main() => runApp(Freeder());

class Freeder extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
          builder: (context, ThemeModel themeNotifier, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: themeNotifier.isDark ? ThemeData.dark() : ThemeData.light(),
          debugShowCheckedModeBanner: false,
          home: const FeedPage(),
        );
      }),
    );
  }
}