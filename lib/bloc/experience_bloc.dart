import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:experience_manager/bloc/experience_event.dart';
import 'package:experience_manager/bloc/experience_state.dart';
import 'package:experience_manager/data/repositories/experience_repositories.dart';
import 'package:experience_manager/data/models/experience_model.dart';

class ExperienceBloc extends Bloc<ExperienceEvent, ExperienceState> {
  final ExperienceRepository repository;

  ExperienceBloc({required this.repository}) : super(ExperienceLoading()) {
    on<LoadExperiences>(_onLoadExperiences);
    on<AddExperience>(_onAddExperience);
    on<EditExperience>(_onEditExperience);
    on<RemoveExperience>(_onRemoveExperience);
  }

  void _onLoadExperiences(
    LoadExperiences event,
    Emitter<ExperienceState> emit,
  ) async {
    emit(ExperienceLoading());
    try {
      final experiences = await repository.fetchExperiences();
      emit(ExperienceLoaded(experiences));
    } catch (e) {
      emit(ExperienceError(e.toString()));
    }
  }

  void _onAddExperience(
    AddExperience event,
    Emitter<ExperienceState> emit,
  ) async {
    if (state is ExperienceLoaded) {
      final currentList = List<Experience>.from(
        (state as ExperienceLoaded).experiences,
      );
      try {
        final newExp = await repository.createExperience(
          event.title,
          event.details,
        );
        currentList.insert(0, newExp);
        emit(ExperienceLoaded(currentList));
      } catch (e) {
        emit(ExperienceError("Could not add experience"));
      }
    }
  }

  void _onEditExperience(
    EditExperience event,
    Emitter<ExperienceState> emit,
  ) async {
    if (state is ExperienceLoaded) {
      final currentList = List<Experience>.from(
        (state as ExperienceLoaded).experiences,
      );
      try {
        await repository.updateExperience(
          event.experience.id!,
          event.experience.title,
          event.experience.details,
        );
        final index = currentList.indexWhere(
          (e) => e.id == event.experience.id,
        );
        if (index != -1) {
          currentList[index] = event.experience;
          emit(ExperienceLoaded(currentList));
        }
      } catch (e) {
        emit(ExperienceError("Could not update experience"));
      }
    }
  }

  void _onRemoveExperience(
    RemoveExperience event,
    Emitter<ExperienceState> emit,
  ) async {
    if (state is ExperienceLoaded) {
      final currentList = List<Experience>.from(
        (state as ExperienceLoaded).experiences,
      );
      try {
        await repository.deleteExperience(event.id);
        currentList.removeWhere((e) => e.id == event.id);
        emit(ExperienceLoaded(currentList));
      } catch (e) {
        emit(ExperienceError("Could not delete experience"));
      }
    }
  }
}
