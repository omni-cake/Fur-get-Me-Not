import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fur_get_me_not/adopter/models/adoption_list/pet.dart';
import 'package:fur_get_me_not/adopter/bloc/pet_details/pet_details_bloc.dart';
import 'package:fur_get_me_not/adopter/bloc/pet_details/pet_details_event.dart';
import 'package:fur_get_me_not/adopter/bloc/pet_details/pet_details_state.dart';
import 'package:fur_get_me_not/adopter/repositories/adoption_list/pet_repository.dart';
import 'package:fur_get_me_not/adopter/screens/chat/chat_screen.dart';
import 'package:fur_get_me_not/widgets/buttons/back_button.dart';

class PetDetailsPage extends StatelessWidget {
  final String petId;

  const PetDetailsPage({Key? key, required this.petId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PetDetailsBloc(petRepository: RepositoryProvider.of<PetRepository>(context))
        ..add(LoadPetDetailsEvent(petId: petId)),
      child: Scaffold(
        body: BlocBuilder<PetDetailsBloc, PetDetailsState>(
          builder: (context, state) {
            if (state is PetDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PetDetailsLoaded) {
              final pet = state.pet;
              return _PetDetailsView(pet: pet);
            } else if (state is PetDetailsError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return Container();
          },
        ),
      ),
    );
  }
}


class _PetDetailsView extends StatefulWidget {
  final Pet pet;

  const _PetDetailsView({Key? key, required this.pet,}) : super(key: key);

  @override
  State<_PetDetailsView> createState() => _PetDetailsViewState();
}

class _PetDetailsViewState extends State<_PetDetailsView> {
  bool showPetInfo = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      child: Stack(
        children: [
          itemsImageAndBackground(size),
          BackButtonWidget(),
          Positioned(
            bottom: 0,
            child: Container(
              height: size.height * 0.52,
              width: size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      nameAddressAndFavoriteButton(),
                      const SizedBox(height: 20),
                      buildToggleButtons(),
                      const SizedBox(height: 20),
                      showPetInfo ? petInfo() : vaccineMedicalHistory(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget nameAddressAndFavoriteButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.pet.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            // const Text(
            //   "Address or location",
            //   style: TextStyle(fontSize: 16, color: Colors.grey),
            // ),
          ],
        ),
      ],
    );
  }

  Widget buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              showPetInfo = true;
            });
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              showPetInfo ? Colors.blue : Colors.grey,
            ),
          ),
          child: const Text('Pet Info'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              showPetInfo = false;
            });
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              showPetInfo ? Colors.grey : Colors.blue,
            ),
          ),
          child: const Text('Vaccine/Medical History'),
        ),
      ],
    );
  }

  Widget petInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Name: ${widget.pet.name}"),
        Text("Age: ${widget.pet.age} years old"),
        Text("Breed: ${widget.pet.breed}"),
        Text("Height: ${widget.pet.height} cm"),
        Text("Weight: ${widget.pet.weight} kg"),
        Text("Special Care: ${widget.pet.specialCareInstructions}"),
      ],
    );
  }

  Widget vaccineMedicalHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image.network(widget.pet.vaccineHistoryImageUrl),
        // const SizedBox(height: 10),
        // Image.network(widget.pet.medicalHistoryImageUrl),
      ],
    );
  }

  Container itemsImageAndBackground(Size size) {
    return Container(
      height: size.height * 0.50,
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.5),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -60,
            top: 30,
            child: Transform.rotate(
              angle: -11.5,
              child: Image.asset(
                'images/pet-cat2.png',
                color: Colors.black,
                height: 55,
              ),
            ),
          ),
          Positioned(
            right: -60,
            bottom: 0,
            child: Transform.rotate(
              angle: 12,
              child: Image.asset(
                'images/pet-cat2.png',
                color: Colors.black,
                height: 55,
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Hero(
              tag: widget.pet.petImageUrl,
              child: Image.network(
                widget.pet.petImageUrl,
                height: size.height * 0.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ClipRRect moreInfo(Color pawColor, Color backgroundColor, String title, String value) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Positioned(
            bottom: -20,
            right: -20,
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: backgroundColor,
              ),
            ),
          ),
          Container(
            height: 60,
            width: 100,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
