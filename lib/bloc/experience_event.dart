import 'package:equatable/equatable.dart';
import 'package:experience_manager/data/models/experience_model.dart';

abstract class ExperienceEvent extends Equatable {
  const ExperienceEvent();
  @override
  List<Object?> get props => [];
}

class LoadExperiences extends ExperienceEvent {}

class AddExperience extends ExperienceEvent {
  final String title;
  final String details;
  const AddExperience(this.title, this.details);
}

class EditExperience extends ExperienceEvent {
  final Experience experience;
  const EditExperience(this.experience);
}

class RemoveExperience extends ExperienceEvent {
  final int id;
  const RemoveExperience(this.id);
}
