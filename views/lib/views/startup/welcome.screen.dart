import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:comies/main.dart';
import 'package:comies/services/settings.service.dart';
import 'package:comies/utils/declarations/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  Welcome createState() => Welcome();
}

class Welcome extends State<WelcomeScreen> {
  SettingsService service = new SettingsService();

  int onScreen = 0;

  bool allSet = false;

  void nextPage() {
    slider.nextPage();
    setState(() {
      onScreen++;
    });
  }

  void previousPage() {
    slider.previousPage();
    setState(() {
      onScreen--;
    });
  }

  void actionIfUserIsInTheCloud() {
    session.server = onlineURL;
    service.addSetting('cloud', true);
    service.addSetting('url', session.server);
    service.addSetting('allSet', true);
    setState(() {
      allSet = true;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Ok, tudo pronto. Podemos iniciar agora!"),
          action: SnackBarAction(label: "Iniciar", onPressed: () => Navigator.pushNamed(context, "/"))
        )
      );
    });
  }

  void actionIfUserHasOwnServer(String serverURL) {
    service.addSetting('cloud', false);
    service.addSetting('url', serverURL);
    service.addSetting('allSet', true);
    setState(() {
      session.server = serverURL;
      allSet = true;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Ok, tudo pronto. Podemos iniciar agora!"),
          action: SnackBarAction(label: "Iniciar", onPressed: () => Navigator.pushNamed(context, "/"))
        )
      );
    });
  }

  CarouselController slider = new CarouselController();

  List<Widget> carouselItems() {
    return [
      WelcomeCard(),
      SettingAPIAddressCard(
        actionIfUserHasOwnServer: actionIfUserHasOwnServer,
        actionIfUserIsInTheCloud: actionIfUserIsInTheCloud,
      ),
    ];
  }

  Widget carouselSlider() {
    return CarouselSlider(
      items: carouselItems(),
      options: CarouselOptions(
        onPageChanged: (page, reason) => setState(() => onScreen = page),
        enableInfiniteScroll: false,
        height: MediaQuery.of(context).size.height / 1.5,
        enlargeCenterPage: true,
      ),
      carouselController: slider,
    );
  }

  Widget navigationArrows() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      alignment: Alignment.bottomCenter,
      width: 300,
      child: Wrap(
        children: [
          IconButton(
            icon: Icon(Icons.keyboard_arrow_left_outlined),
            onPressed: onScreen == 0 ? null : previousPage,
          ),
          SizedBox(width: 50),
          IconButton(
            icon: Icon(Icons.keyboard_arrow_right_outlined),
            onPressed: onScreen == 1 ? null : nextPage,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Theme.of(context).primaryColor
          : null,
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top: 20),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              carouselSlider(),
              navigationArrows(),
            ],
          ),
        ),
      ),
    );
  }
}

class BaseWelcomeCard extends StatefulWidget {
  final List<Widget> children;
  final String image;

  BaseWelcomeCard({Key key, this.children, this.image}) : super(key: key);

  @override
  BaseWelcomeCardState createState() => BaseWelcomeCardState();
}

class BaseWelcomeCardState extends State<BaseWelcomeCard> {
  @override
  Widget build(BuildContext context) {
    if (widget.image != null) {
      widget.children.add(Image.asset(
        widget.image,
        height: 150,
        width: MediaQuery.of(context).size.width > widthDivisor
            ? MediaQuery.of(context).size.width / 4
            : MediaQuery.of(context).size.width / 1.1,
        alignment: Alignment.bottomCenter,
      ));
    }
    return Card(
      color: Colors.transparent,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width > widthDivisor ? 500 : 1000,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Theme.of(context).primaryColorDark,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.children,
            ),
          ),
        ),
      ),
    );
  }
}

class WelcomeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWelcomeCard(
      children: [
        SizedBox(height: 20),
        Text(
          "BEM-VINDO(A) AO",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(height: 20),
        Text(
          "COMIES",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline4,
        ),
        Text(
          "SEU BRAÇO DIREITO PRA CUIDAR DE SEU NEGÓCIO",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }
}

class SettingAPIAddressCard extends StatefulWidget {
  final Function actionIfUserIsInTheCloud;
  final Function(String) actionIfUserHasOwnServer;

  SettingAPIAddressCard(
      {Key key, this.actionIfUserHasOwnServer, this.actionIfUserIsInTheCloud})
      : super(key: key);

  @override
  SettingAPIAddressState createState() => SettingAPIAddressState();
}

class SettingAPIAddressState extends State<SettingAPIAddressCard> {
  int optionSet = -1;
  bool enableButton = false;

  RadioListTile option(String optionLabel, int optionValue) {
    return RadioListTile<int>(
      title: Text(optionLabel, style: Theme.of(context).textTheme.caption),
      value: optionValue,
      groupValue: optionSet,
      activeColor: Theme.of(context).accentColor,
      onChanged: (value) {
        setState(() {
          optionSet = value;
          if (optionSet == 0){
            widget.actionIfUserIsInTheCloud();
            enableButton = true;
          } 
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = new TextEditingController();
    return BaseWelcomeCard(
      image: 'assets/illustrations/people.discussing.png',
      children: [
        Text(
          "VAMOS AJUSTAR UMAS COISAS",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.caption,
        ),
        SizedBox(height: 20),
        Text(
          "Você vai usar o aplicativo online ou na rede interna do seu trabalho?",
          style: Theme.of(context).textTheme.caption,
          textAlign: TextAlign.justify,
        ),
        option('Vou usar online', 0),
        option('Só na rede do trabalho', 1),
        if (optionSet == 1)
          TextFormField(
            controller: controller,
            onFieldSubmitted: (value){ widget.actionIfUserHasOwnServer(value); setState((){enableButton = true;});},
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
                suffix: IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () { widget.actionIfUserHasOwnServer(controller.text); setState((){enableButton = true;});},
                ),
                labelText: "URL de acesso",
                helperText: 'Pergunte a um responsável.'),
            maxLines: 1,
          ),
        SizedBox(height: 20),
        ElevatedButton(
          child: Text("Continuar"),
          onPressed: enableButton ? () => Navigator.pushNamed(context, "/authentication") : null,
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
