import 'package:flutter/material.dart';
import 'package:panic_app/pages/camera_page.dart';
import 'package:panic_app/pages/camera_view_page.dart';
import 'package:panic_app/pages/configuration_page.dart';
import 'package:panic_app/pages/contactos/add_contactos_page.dart';
import 'package:panic_app/pages/contactos/ver_contactos_page.dart';
import 'package:panic_app/pages/firts_time/presentate_page.dart';
import 'package:panic_app/pages/home_page.dart';
import 'package:panic_app/pages/information_page.dart';
import 'package:panic_app/pages/internet_failed_page.dart';
import 'package:panic_app/pages/map_1/detail1_page.dart';
import 'package:panic_app/pages/map_1/visualizer1_page.dart';
import 'package:panic_app/pages/map_2/visualizer2_page.dart';
import 'package:panic_app/pages/profile_page.dart';
import 'package:panic_app/pages/select_map_page.dart';
import '../pages/firts_time/intro_page.dart';
import '../pages/information_permission_page.dart';
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
  'information': (_) => const InformationPage(),
  'profile': (_) => const ProfilePage(),
  'contacts': (_) => SeeContactPage(),
  'add': (_) => const AddContactPage(),
  'config': (_) => const ConfigurationPage(),
  'internet': (_) => const InternetFailedPage(),
  'selectMap': (_) => const SelectMapPage(),
  'map1': (_) => const Visualizer1Page(),
  'detail1': (_) => const Detail1Page(),
  'map2': (_) => const Visualizer2Page(),
  'informationPermission': (_) => const InformationPermissionPage(),
  'camera': (_) => const CameraPage(),
  'cameraView': (_) => const CameraViewPage(),
  

  // 'proyectos': (_) => const ProyectosPage(),
  // 'info': (_) => const InformationPage(),
  // 'participate': (_) => const ParticipatePage(),
  // 'preguntas': (_) => const PreguntasPage(),
  // 'estadisticas': (_) => const EstadisticasPage(),
  // 'error': (_) => const ErrorPage(),
  // 'nosotros': (_) => const NosotrosPage(),
};
