import 'package:flutter_bloc/flutter_bloc.dart';
import 'adoption_browse_event.dart';
import 'adoption_browse_state.dart';
import 'package:fur_get_me_not/models/adopters/adoption_list/pet.dart';
import 'package:fur_get_me_not/repositories/adopters/adoption_list/pet_repository.dart';

class AdoptionBrowseBloc extends Bloc<AdoptionBrowseEvent, AdoptionBrowseState> {
  final PetRepository petRepository;

  AdoptionBrowseBloc({required this.petRepository}) : super(AdoptionBrowseLoading()) {
    on<LoadAdoptionBrowseEvent>(_onLoadAdoptionBrowseEvent);
  }

  void _onLoadAdoptionBrowseEvent(LoadAdoptionBrowseEvent event, Emitter<AdoptionBrowseState> emit) async {
    emit(AdoptionBrowseLoading());
    try{
      final pets = await petRepository.getAvailablePets(event.filter);
      emit(AdoptionBrowseLoaded(pets: pets));
    } catch (e) {;
      emit(AdoptionBrowseError(message: "Failed to load pets."));
    }
  }
}