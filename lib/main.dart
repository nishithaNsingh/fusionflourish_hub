import 'package:flutter/material.dart';
import 'package:fusionflourish_hub/navbar.dart';
import 'package:fusionflourish_hub/screens/homescreen/homesceen.dart';
import 'package:fusionflourish_hub/screens/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


Future<void> main() async {
  await Supabase.initialize(
    url: 'https://gvosllkqzgnclphwgsmi.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd2b3NsbGtxemduY2xwaHdnc21pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDk3NDkyODksImV4cCI6MjAyNTMyNTI4OX0.wI7sCzmf2cgIW8QY5_Q6qkcVnulrYyFW6jIP-5iKaTo',
  );
  runApp(MyApp());
}
final supabase = Supabase.instance.client;



class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FusionFlourish',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashScreen(),
        '/home_screen':(_) => const NavBarScreen(),
        // // '/login': (_) => const SignInScreen(),
        // '/account': (_) => const RegistrationScreen(),
        // '/signup':(_) => const SignUpScreen(),
        // '/createscreen':(_) => const CreateScreen(),
        // '/post':(_) => const PostScreen(),
        // '/learn':(_) =>  LearnScreen(),
        // '/search':(_) => const SearchScreen(),
        // '/communitymain':(_) =>  const CommunityMain(),
        // '/storiesymain':(_) =>  const StoriesMain(),
        '/navbarscreen':(_) =>  const NavBarScreen(),
      },
    );
  }
}

