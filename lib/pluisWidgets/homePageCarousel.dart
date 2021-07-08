import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis_hv_app/homePage/homeDataModel.dart';
import 'package:pluis_hv_app/homePage/homePageCubit.dart';
import 'package:pluis_hv_app/homePage/homePageRepository.dart';
import 'package:pluis_hv_app/homePage/homePageStates.dart';
import 'package:pluis_hv_app/observables/colorStringObservable.dart';
import 'package:pluis_hv_app/observables/slidesObservable.dart';
import 'package:transparent_image/transparent_image.dart';
import '../injectorContainer.dart' as injectionContainer;

import 'homeAppBar.dart';

class HomePageCarousel extends StatefulWidget {
  final List<String> genreIds;

  const HomePageCarousel({Key key, this.genreIds}) : super(key: key);

  @override
  _HomePageCarousel createState() {
    return _HomePageCarousel(genreIds: this.genreIds);
  }
}

class _HomePageCarousel extends State<HomePageCarousel> {
  //colorObservable
  ColorBloc textColorObservable = injectionContainer.sl<ColorBloc>();

  CarouselOptions defaultOptions = CarouselOptions();

  List<SlidesInfo> imagesUrls;

  final List<String> genreIds;

  _HomePageCarousel({this.genreIds});

  SlidesBloc _slidesBloc = SlidesBloc(slidesInfo: []);

  @override
  void initState() {
    super.initState();
    log("Genres ids" + this.genreIds.toString());
    this
        .context
        .read<HomePageCarouselCubit>()
        .loadSlideInfoFromGenderId(this.genreIds[0])
        .whenComplete(() => {
              this.genreIds.forEach((id) {
                context
                    .read<HomePageCarouselCubit>()
                    .loadSlideInfoFromGenderIdList(id)
                    .then((list) => this._slidesBloc.updateOrders(list));
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomePageCarouselCubit, HomePageState>(
      listener: (context, state) async {
        if (state is HomePageCarouselSuccess) {
          textColorObservable.updateColor(
              (state as HomePageCarouselSuccess).imagesUrls[0].text_color);
          this.defaultOptions = CarouselOptions(
            autoPlayInterval: Duration(seconds: 8),
            onPageChanged: (index, _) {
              this._slidesBloc.counterObservable.first.then((value) =>
                  textColorObservable.updateColor(value[index].text_color));
            },
            height: MediaQuery.of(context).size.height,
            autoPlayAnimationDuration: Duration(seconds: 3, milliseconds: 500),
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            autoPlay: true,
            scrollDirection: Axis.horizontal,
          );
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case HomePageCarouselSuccess:
            return Stack(children: [
              Container(
                  child: StreamBuilder(
                stream: this._slidesBloc.counterObservable,
                builder: (_, AsyncSnapshot<List<SlidesInfo>> snapShot) {
                  return (snapShot.data != null)
                      ? CarouselSlider(
                          items: List<Widget>.from(snapShot.data
                              .map((url) => createImage(url.image_small))),
                          options: defaultOptions)
                      : Center(
                          child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.black)),
                        );
                },
              )),
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

  Future<List<SlidesInfo>> loadSlideInfoFromGenderIdList(String Id) async {
    var slidersInfo = <SlidesInfo>[];

    var eitherValue = await repository.loadImageUrl(Id);

    eitherValue.fold(
        (failure) => failure.properties.isEmpty
            ? emit(HomePageErrorState(message: "Server unreachable"))
            : emit(HomePageErrorState(message: failure.properties.first)),
        (sliderInfo) => sliderInfo != null
            ? slidersInfo.addAll(sliderInfo)
            : emit(HomePageErrorState()));

    return slidersInfo;
  }
}
