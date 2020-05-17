import 'package:covid19/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'counter.dart';
import 'networking.dart';

enum selectedRegion { country, global }

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  selectedRegion region = selectedRegion.country;
  List<String> data = ['--', '--', '--', '--', '--'];

  Country selected = Country(
    asset: "assets/flags/np_flag.png",
    dialingCode: "977",
    isoCode: "NP",
    name: "Nepal",
    currency: "Nepalese rupee",
    currencyISO: "NPR",
  );

  void getNumbers() async {
    setState(() {
      data.clear();
      data = ['--', '--', '--', '--', '--'];
    });
    dynamic updatedData = await UpdateNumbers()
        .get(region == selectedRegion.global ? 'Global' : selected.isoCode);
    setState(() {
      data.clear();
      data = updatedData;
    });
  }

  @override
  void initState() {
    getNumbers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
//        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 30,
            child: Container(
              padding:
                  EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 10),
//              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xFF3383CD),
                    Color(0xFF4c60e0),
                  ],
                ),
//              borderRadius: BorderRadius.only(
//                bottomRight: Radius.circular(20.0),
//                bottomLeft: Radius.circular(20.0),
//              ),
              ),
              child: SafeArea(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'COVID-19',
                        style: kMainTitleStyle,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: <Widget>[
                          ImageText(
                            image: 'images/washHands.png',
                            text: 'Wash your hands',
                          ),
                          ImageText(
                            image: 'images/socialDistancing.png',
                            text: 'Avoid close contacts',
                          ),
                          ImageText(
                            image: 'images/masks.png',
                            text: 'Wear a facemask',
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(width: 1, color: Colors.black),
                ),
                child: CountryPicker(
                  showDialingCode: false,
                  showName: true,
                  showCurrency: false,
                  showCurrencyISO: false,
                  onChanged: (Country country) {
                    setState(() {
                      selected = country;
                      region == selectedRegion.country
                          ? getNumbers()
                          : region = selectedRegion.global;
                    });
                  },
                  selectedCountry: selected,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
              child: Container(
                padding: EdgeInsets.all(5.0),
                margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 5.0),
                decoration: BoxDecoration(
                  color: Color(0xFF3383CD),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RegionSelect(
                      title: selected.name,
                      color: region == selectedRegion.country
                          ? kActiveColor
                          : kInactiveColor,
                      onPress: () {
                        setState(() {
                          region = selectedRegion.country;
                          getNumbers();
                        });
                      },
                    ),
                    RegionSelect(
                      title: 'Global',
                      color: region == selectedRegion.global
                          ? kActiveColor
                          : kInactiveColor,
                      onPress: () {
                        setState(() {
                          region = selectedRegion.global;
                          getNumbers();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'Confirmed Cases',
                    style: kTitleTextStyle,
                  ),
                  Text(
                    'Last Updated: ' + data[0],
                    style: kSmallTextStyle,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 50,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.white,
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Counter(
                                number: data[1],
                                color: kInfectedColor,
                                title: 'Total Cases',
                              ),
                              Counter(
                                number: data[2],
                                color: kDeathColor,
                                title: 'Deaths',
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Counter(
                                number: data[3],
                                color: kActiveCasesColor,
                                title: 'Active Cases',
                              ),
                              Counter(
                                number: data[4],
                                color: kRecoverColor,
                                title: 'Recovered',
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RegionSelect extends StatelessWidget {
  final String title;
  final Color color;
  final Function onPress;

  RegionSelect({this.title, @required this.color, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onPress,
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            title,
            style: kSelectedTextStyle,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

class ImageText extends StatelessWidget {
  final String image;
  final String text;

  ImageText({this.image, this.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Image.asset(
              image,
            ),
          ),
          Text(
            text,
            style: kSubTextStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
