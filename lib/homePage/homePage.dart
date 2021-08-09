import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pluis_hv_app/PluisApp.dart';
import 'package:pluis_hv_app/commons/appTheme.dart';

// import 'package:http/http.dart';
import 'package:pluis_hv_app/commons/pagesRoutesStrings.dart';
import 'package:pluis_hv_app/commons/values.dart';
import 'package:pluis_hv_app/homePage/homeDataModel.dart';
import 'package:pluis_hv_app/observables/colorStringObservable.dart';
import 'package:pluis_hv_app/pluisWidgets/DarkButton.dart';
import 'package:pluis_hv_app/pluisWidgets/homeBottomBar.dart';
import 'package:pluis_hv_app/pluisWidgets/homePageCarousel.dart';
import 'package:pluis_hv_app/pluisWidgets/pluisLogo.dart';
import 'package:pluis_hv_app/pluisWidgets/snackBar.dart';
import 'package:pluis_hv_app/settings/settings.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';
import '../injectorContainer.dart' as injectionContainer;

import 'homePageCubit.dart';
import 'homePageStates.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> with SingleTickerProviderStateMixin {
  TabController _tabController;
  String selectedGenre = "0";
  List<Tab> tabs = [];
  List<GenresInfo> genres;
  List<List<SlidesInfo>> slidersInfoByGender;

  //colorObservable
  ColorBloc textColorObservable = injectionContainer.sl<ColorBloc>();

  //paeVie Controller
  PageController _pageController = PageController(initialPage: 0);

  bool _downloading = false;

  @override
  void initState() {
    super.initState();
    context.read<HomePageCubit>().loadGenres();
  }

  @override
  Widget build(BuildContext context) {
    return buildScaffold(context);
  }

  Scaffold buildScaffold(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(),
      body: buildBody(context),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Row(children: [
        SizedBox(
            height: MediaQuery.of(context).size.height / 10,
            width: MediaQuery.of(context).size.width / 4,
            child: LogoImage()),
        StreamBuilder(
            stream: this.textColorObservable.colorObservable,
            builder: (_, snapshot) {
              return Padding(
                  padding: EdgeInsets.fromLTRB(32, 0, 0, 0),
                  child: Text(
                    "$pluisString",
                    style: TextStyle(
                      color: (snapshot.data != null)
                          ? Color(snapshot.data)
                          : Colors.red,
                    ),
                  ));
            })
      ]),
    );
  }

  BottomBar buildBottomNavigationBar() {
    return BottomBar(
      onPressBookmark: () =>
          Navigator.of(context).pushNamed(ADDRESS_BOOK_ROUTE),
      onPressShopBag: () => Navigator.of(context).pushNamed(SHOP_CART),
      onPressAccount: () => Navigator.of(context).pushNamed(LOGIN_PAGE_ROUTE),
      onPressMenu: () => Navigator.of(context).pushNamed(MENU_PAGE),
    );
  }

  Widget buildBody(BuildContext context) {
    return BlocConsumer<HomePageCubit, HomePageState>(
        listener: (context, state) async {
      if (state is HomePageGenresLoaded) {
        setState(() {
          this.genres = state.genresInfo;
        });
        await this.context.read<HomePageCubit>().setSuccess();
      }
    }, builder: (context, state) {
      switch (state.runtimeType) {
        case HomePageSuccessState:
          return buildPgeView();
        default:
          return Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
          );
      }
    });
  }

  Widget buildPgeView() {
    return PageView(
      controller: this._pageController,
      scrollDirection: Axis.vertical,
      children: [
        createCarouselProvider(this.genres[0].gender_id),
        buildPanelInfo()
      ],
    );
  }

  Container buildPanelInfo() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(flex: 3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(64, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 16, 0, 4),
                      child: Text("SÍGUENOS",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 16, 0, 4),
                        child: GestureDetector(
                          onTap: () async {
                            await canLaunch(instagramUrl)
                                ? launch(instagramUrl)
                                : showSnackbar(context,
                                    text:
                                        "La aplicación INSTAGRAM no está instalada en el sistema");
                          },
                          child: Wrap(
                            spacing: 4.0,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.instagram,
                                color: Colors.black,
                                size: 16,
                              ),
                              Text("INSTAGRAM",
                                  style: TextStyle(color: Colors.black))
                            ],
                          ),
                        )),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 16, 0, 4),
                        child: GestureDetector(
                          onTap: () async {
                            await canLaunch(facebookUrl)
                                ? launch(facebookUrl)
                                : showSnackbar(context,
                                    text:
                                        "La aplicación FACEBOOK no está instalada en el sistema");
                          },
                          child: Wrap(
                              spacing: 4.0,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.facebook,
                                  color: Colors.black,
                                  size: 16,
                                ),
                                Text("FACEBOOK",
                                    style: TextStyle(color: Colors.black)),
                              ]),
                        )),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 16, 0, 4),
                        child: GestureDetector(
                          onTap: () async {
                            await canLaunch(whatsappUrl)
                                ? launch(whatsappUrl)
                                : showSnackbar(context,
                                    text:
                                        "La aplicación WHATSAPP no está instalada en el sistema");
                          },
                          child: Wrap(
                              spacing: 4.0,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.whatsapp,
                                  color: Colors.black,
                                  size: 16,
                                ),
                                Text("WHATSAPP",
                                    style: TextStyle(color: Colors.black)),
                              ]),
                        ))
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.fromLTRB(64, 0, 64, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 16, 0, 4),
                      child: Text("EMPRESA",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return buildModalSHeetCOntactInfo();
                            });
                      },
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 16, 0, 4),
                          child: Wrap(
                              spacing: 4.0,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.globe,
                                  color: Colors.black,
                                  size: 16,
                                ),
                                Text("CONTACTO",
                                    style: TextStyle(color: Colors.black)),
                              ])),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(64, 32, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 4),
                  child: Text("POLÍTICAS",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 4),
                  child: GestureDetector(
                    onTap: () {
                      var filename = privacidadUrl.split('/');
                      download(privacidadUrl, filename[filename.length - 1]);
                    },
                    child: Text("POLÍTICA DE PRIVACIDAD",
                        style: TextStyle(color: Colors.black)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 4),
                  child: GestureDetector(
                    onTap: () {
                      var filename = terminosUrl.split('/');
                      download(privacidadUrl, filename[filename.length - 1]);
                    },
                    child: Text("TÉRMINOS Y CONDICIONES DE USO",
                        style: TextStyle(color: Colors.black)),
                  ),
                )
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(64, 32, 64, 0),
              child: Divider(
                thickness: 1.5,
              )),
          Padding(
            padding: EdgeInsets.fromLTRB(128, 32, 64, 0),
            child: Text("© All rights reserved",
                style: TextStyle(color: Colors.black)),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(128, 32, 64, 0),
            child:
                Text("CUBA / LA HABANA", style: TextStyle(color: Colors.black)),
          ),
          Spacer()
        ],
      ),
    );
  }

  Container buildModalSHeetCOntactInfo() {
    return Container(
      height: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(32, 16, 0, 4),
            child: Text("Siéntete libre de contactarnos".toUpperCase(),
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(32, 16, 0, 4),
              child: Wrap(
                  spacing: 4.0,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.globe,
                      color: Colors.black,
                      size: 16,
                    ),
                    Text("TELÉFONO",
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                  ])),
          Padding(
            padding: EdgeInsets.fromLTRB(32, 16, 0, 4),
            child: SelectableText("+5359624232",
                style: TextStyle(color: Colors.grey)),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(32, 16, 0, 4),
              child: Wrap(
                  spacing: 4.0,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.mailBulk,
                      color: Colors.black,
                      size: 16,
                    ),
                    Text("CORREO",
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                  ])),
          Padding(
            padding: EdgeInsets.fromLTRB(32, 16, 0, 4),
            child: SelectableText("ventaspluis@gmail.com",
                style: TextStyle(color: Colors.grey)),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(32, 16, 0, 4),
              child: Wrap(
                  spacing: 4.0,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.mapPin,
                      color: Colors.black,
                      size: 16,
                    ),
                    Text("DIRECCIÓN",
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                  ])),
          Padding(
            padding: EdgeInsets.fromLTRB(32, 16, 0, 4),
            child: SelectableText(
                "Calle H #403 apto 103/17 y 19 Vedado La Habana",
                style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Future<bool> download(String url, String filename) async {
    String truePath = '';
    requestPermissions().then((ready) => {
          Settings.getAppExternalStorageBaseDirectory.then((directory) => {
                log('${directory.path}'),
                truePath = directory.path.replaceAll(
                        "Android/data/com.dcm.highvista.calzado_pluis/files",
                        "CalzadoPLuis") +
                    '/privacidad' +
                    '/' +
                    filename,
                context
                    .read<HomePageCubit>()
                    .downloadFile(url, truePath, onProgressCallback)
                    .then((value) => {
                          this._downloading = false,
                          if (value) {showModalForOpenFile(truePath)}
                        })
              })
        });
  }

  Future showModalForOpenFile(String truePath) {
    return showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            height: 150,
            child: Column(
              children: [
                Spacer(),
                Center(
                  child: Text(
                    "La descarga ha finalizado con éxito.",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: DarkButton(
                      text: "Abrir",
                      action: () {
                        final _result =
                            OpenFile.open(truePath).then((value) => {
                                  if (value.type == ResultType.noAppToOpen)
                                    {_showMyDialog()}
                                });
                      }),
                )
              ],
            ),
          );
        });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Aplicación no encontrada'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('NO existe aplicación para abrir el documento.'),
                Text('Verifique que contiene un lector de .docxs'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Entendido'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<Map<Permission, PermissionStatus>> requestPermissions() async {
    Map<Permission, PermissionStatus> status = await Settings.requestPermission(
        permissionsToRequest: [Permission.storage]);
    if (status.entries.any((element) => element.value.isDenied))
      return await requestPermissions();
    return status;
  }

  void onProgressCallback(int prog, int total) {
    setState(() {
      this._downloading = true;
    });
  }

  List<BlocProvider<HomePageCarouselCubit>> createCarouselFromGenres() {
    return List<BlocProvider<HomePageCarouselCubit>>.from(
        this.genres.map((e) => createCarouselProvider(e.gender_id)));
  }

  BlocProvider createCarouselProvider(String genreId) {
    return BlocProvider<HomePageCarouselCubit>(
      create: (_) => injectionContainer.sl<HomePageCarouselCubit>(),
      child: HomePageCarousel(
          genreIds: this.genres.map((e) => e.gender_id).toList()),
    );
  }
}
