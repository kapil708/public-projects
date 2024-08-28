import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/bloc/number_trivia_bloc.dart';

class TriviaControls extends StatelessWidget {
  TriviaControls({super.key});

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: controller,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
            onSubmitted: (_) => dispatchConcrete(context),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => dispatchConcrete(context),
                  child: const Text('Search'),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => dispatchRandom(context),
                  child: const Text('Get Random Trivia'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void dispatchConcrete(context) {
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForConcreteNumber(controller.text));
    controller.clear();
  }

  void dispatchRandom(context) {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());

    // locator.get<NumberTriviaBloc>().add(GetTriviaForRandomNumber());
  }
}
