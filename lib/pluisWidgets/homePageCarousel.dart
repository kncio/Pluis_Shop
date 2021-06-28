import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis_hv_app/homePage/homeDataModel.dart';
import 'package:pluis_hv_app/homePage/homePageCubit.dart';
import 'package:pluis_hv_app/homePage/homePageRepository.dart';
import 'package:pluis_hv_app/homePage/homePageStates.dart';
import 'package:pluis_hv_app/observables/colorStringObservable.dart';
import 'package:transparent_image/transparent_image.dart';
import '../injectorContainer.dart' as injectionContainer;

import 'homeAppBar.dart';

class HomePageCarousel extends StatefulWidget {
  final String genreId;

  const HomePageCarousel({Key key, this.genreId}) : super(key: key);

  @override
  _HomePageCarousel createState() {
    return _HomePageCarousel(genre: this.genreId);
  }
}

class _HomePageCarousel extends State<HomePageCarousel> {
  //colorObservable
  ColorBloc textColorObservable = injectionContainer.sl<ColorBloc>();

  CarouselOptions defaultOptions = CarouselOptions();

  List<SlidesInfo> imagesUrls;

  final String genre;

  _HomePageCarousel({this.genre});

  @override
  void initState() {
    super.initState();
    this
        .context
        .read<HomePageCarouselCubit>()
        .loadSlideInfoFromGenderId(this.genre).whenComplete(() => {

    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomePageCarouselCubit, HomePageState>(
      listener: (context, state) async {
        if(state is HomePageCarouselSuccess){
          textColorObservable.updateColor((state as HomePageCarouselSuccess).imagesUrls[0].text_color);
          this.defaultOptions = CarouselOptions(
            onPageChanged: (index, _) {
              textColorObservable.updateColor((state as HomePageCarouselSuccess).imagesUrls[index].text_color);
            },
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            scrollDirection: Axis.vertical,
          );
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case HomePageCarouselSuccess:
            return Stack(children: [
              Container(
                  height: 800,
                  child: CarouselSlider(
                      items: List<Widget>.from(
                          (state as HomePageCarouselSuccess)
                              .imagesUrls
                              .map((url) => createImage(url.image_small))),
                      options: defaultOptions)),
            ]);
          default:
            return Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
            );
        }
      },
    );
  }

  Widget createImage(String url) {
    return Container(
      height: 800,
      child: FadeInImage.memoryNetwork(
        image: url,
        placeholder: kTransparentImage,
        fit: BoxFit.fill,
      ),
    );
  }
}

class HomePageCarouselCubit extends Cubit<HomePageState> {
  final HomePageRepository repository;

  HomePageCarouselCubit({this.repository}) : super(HomePageCarouselInit());

  Future<void> loadSlideInfoFromGenderId(String genderId) async {
    emit(HomePageLoadingSliders());

    var eitherValue = await repository.loadImageUrl(genderId);

    eitherValue.fold(
        (failure) => failure.properties.isEmpty
            ? emit(HomePageErrorState(message: "Server unreachable"))
            : emit(HomePageErrorState(message: failure.properties.first)),
        (sliderInfo) => sliderInfo != null
            ? emit(HomePageCarouselSuccess(imagesUrls: sliderInfo))
            : emit(HomePageErrorState()));
  }
}
