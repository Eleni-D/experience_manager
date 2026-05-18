import 'package:equatable/equatable.dart';
import 'package:experience_manager/data/models/experience_model.dart';

abstract class ExperienceState extends Equatable {
  const ExperienceState();
  @override
  List<Object?> get props => [];
}

class ExperienceLoading extends ExperienceState {}

class ExperienceLoaded extends ExperienceState {
  final List<Experience> experiences;
  const ExperienceLoaded(this.experiences);
  @override
  List<Object?> get props => [experiences];
}

class ExperienceError extends ExperienceState {
  final String message;
  const ExperienceError(this.message);
  @override
  List<Object?> get props => [message];
}
