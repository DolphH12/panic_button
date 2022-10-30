import 'package:flutter/material.dart';
import 'package:panic_app/pages/buttons_page.dart';
import 'package:panic_app/pages/configuration_page.dart';
import 'package:panic_app/pages/contactos/add_contactos_page.dart';
import 'package:panic_app/pages/contactos/ver_contactos_page.dart';
import 'package:panic_app/pages/firts_time/personalize_page.dart';
import 'package:panic_app/pages/firts_time/presentate_page.dart';
import 'package:panic_app/pages/home_page.dart';
import 'package:panic_app/pages/information_page.dart';
import 'package:panic_app/pages/profile_page.dart';
import '../pages/firts_time/intro_page.dart';
import '../pages/login_page.dart';
import '../pages/otp_page.dart';
import '../pages/register_page.dart';
import '../pages/splash_page.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'splash': (_) => const SplashPage(),
  'login': (_) => const LoginPage(),
  'register': (_) => const RegisterPage(),
  'otp': (_) => const OtpPage(),
  'home': (_) => const HomePage(),
  'intro': (_) => const IntroPage(),
  'presentation': (_) => const PresentationPage(),
  'personalize': (_) => const PersonalizePage(),
  'selectEmergency': (_) => const ButtonsPage(),
  'information': (_) => const InformationPage(),
  'profile': (_) => const ProfilePage(),
  'contacts': (_) => const SeeContactPage(),
  'add': (_) => const AddContactPage(),
  'config': (_) => const ConfigurationPage(),
  // 'proyectos': (_) => const ProyectosPage(),
  // 'info': (_) => const InformationPage(),
  // 'participate': (_) => const ParticipatePage(),
  // 'preguntas': (_) => const PreguntasPage(),
  // 'estadisticas': (_) => const EstadisticasPage(),
  // 'error': (_) => const ErrorPage(),
  // 'nosotros': (_) => const NosotrosPage(),
};
