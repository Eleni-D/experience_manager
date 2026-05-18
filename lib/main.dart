import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:experience_manager/data/repositories/experience_repositories.dart';
import 'package:experience_manager/bloc/experience_bloc.dart';
import 'package:experience_manager/bloc/experience_event.dart';
import 'package:experience_manager/presentation/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ExperienceRepository(),
      child: BlocProvider(
        create: (context) => ExperienceBloc(
          repository: RepositoryProvider.of<ExperienceRepository>(context),
        )..add(LoadExperiences()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.deepPurple,
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
