import 'package:clean_architecture_demo/injection_container.dart';
import 'package:clean_architecture_demo/presentation/logic/bloc/number_trivia_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NumberTriviaBloc>(
      create: (context) => locator.get<NumberTriviaBloc>(),
      child: const NumberTriviaView(),
    );
  }
}

class NumberTriviaView extends StatelessWidget {
  const NumberTriviaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Number Trivia")),
      body: Column(
        children: [
          const SizedBox(height: 10),
          BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
            builder: (context, state) {
              if (state is Error) {
                return MessageDisplay(message: state.message);
              } else if (state is Loading) {
                return const LoadingWidget();
              } else if (state is Loaded) {
                return TriviaDisplay(numberTrivia: state.trivia);
              } else {
                return const MessageDisplay(message: "Start searching");
              }
            },
          ),
          const SizedBox(height: 20),
          TriviaControls(),
        ],
      ),
    );
  }
}
