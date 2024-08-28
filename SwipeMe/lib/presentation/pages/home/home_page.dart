import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:card_test/core/extensions/spacing.dart';
import 'package:card_test/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/route/route_names.dart';
import '../../bloc/home/home_cubit.dart';
import '../../widgets/shimmer/shimmer.dart';
import 'widgets/detail_card.dart';
import 'widgets/image_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator.get<HomeCubit>()..init(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    HomeCubit homeCubit = context.read<HomeCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.home),
        actions: [
          IconButton(
            onPressed: () => context.goNamed(RouteName.settings),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          // Check of any condition base on state
        },
        builder: (context, state) {
          return state is Loading
              ? const Shimmer(type: ShimmerType.detailPage)
              : homeCubit.productList.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        "No product found",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          // Card
                          Container(
                            height: MediaQuery.of(context).size.height * .4,
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 25, right: 25, top: 0, bottom: 20),
                              child: AppinioSwiper(
                                invertAngleOnBottomDrag: true,
                                backgroundCardCount: 2,
                                loop: true,
                                swipeOptions: const SwipeOptions.all(),
                                onSwipeEnd: (int previousIndex, int targetIndex, SwiperActivity activity) {
                                  homeCubit.onCardChange(targetIndex);
                                },
                                cardCount: homeCubit.productList.length,
                                cardBuilder: (BuildContext context, int index) {
                                  return ImageCard(
                                    product: homeCubit.productList[index],
                                  );
                                },
                              ),
                            ),
                          ),

                          // Detail view
                          const VSpace(60),
                          if (homeCubit.selectedProduct != null)
                            DetailCard(
                              product: homeCubit.selectedProduct!,
                            ),
                        ],
                      ),
                    );
        },
      ),
    );
  }
}
