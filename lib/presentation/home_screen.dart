import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:experience_manager/bloc/experience_bloc.dart';
import 'package:experience_manager/bloc/experience_event.dart';
import 'package:experience_manager/bloc/experience_state.dart';
import 'package:experience_manager/data/models/experience_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showExperienceDialog(BuildContext context, {Experience? experience}) {
    final titleController = TextEditingController(
      text: experience?.title ?? '',
    );
    final detailsController = TextEditingController(
      text: experience?.details ?? '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(experience == null ? 'New Experience' : 'Edit Experience'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Experience Title'),
            ),
            TextField(
              controller: detailsController,
              decoration: const InputDecoration(labelText: 'Details'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (experience == null) {
                BlocProvider.of<ExperienceBloc>(context).add(
                  AddExperience(titleController.text, detailsController.text),
                );
              } else {
                BlocProvider.of<ExperienceBloc>(context).add(
                  EditExperience(
                    Experience(
                      id: experience.id,
                      title: titleController.text,
                      details: detailsController.text,
                    ),
                  ),
                );
              }
              Navigator.pop(dialogContext);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💼 Experience Manager'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showExperienceDialog(context),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<ExperienceBloc, ExperienceState>(
        builder: (context, state) {
          if (state is ExperienceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExperienceLoaded) {
            if (state.experiences.isEmpty) {
              return const Center(child: Text('No experiences added yet.'));
            }
            return ListView.builder(
              itemCount: state.experiences.length,
              itemBuilder: (context, index) {
                final exp = state.experiences[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(
                      exp.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      exp.details,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () =>
                              _showExperienceDialog(context, experience: exp),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            BlocProvider.of<ExperienceBloc>(
                              context,
                            ).add(RemoveExperience(exp.id ?? 0));
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is ExperienceError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Unknown State'));
        },
      ),
    );
  }
}
