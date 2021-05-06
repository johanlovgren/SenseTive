import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sensetive/blocs/welcome_bloc.dart';
import 'package:sensetive/blocs/welcome_bloc_provider.dart';
import 'package:sensetive/widgets/background_image.dart';

const String backgroundImagePath = 'lib/assets/images/pregnant_woman.jpg';

class Welcome extends StatefulWidget {
  const Welcome({Key key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  WelcomeBloc _welcomeBloc;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _welcomeBloc = WelcomeBlocProvider.of(context).welcomeBloc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(imagePath: backgroundImagePath),
          SafeArea(
            child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(64),
                      child: Image(image: AssetImage('lib/assets/images/sensetive_text_white.png')),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white.withOpacity(0.5),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'This is your first time using SenseTive, please enter your full name',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                            StreamBuilder(
                              stream: _welcomeBloc.name,
                              builder: (context, snapshot)
                              => TextField(
                                keyboardType: TextInputType.name,
                                onChanged: _welcomeBloc.addNameChanged.add,
                                decoration: InputDecoration(
                                    labelText: 'Full Name',
                                    errorText: snapshot.error,
                                    icon: Icon(
                                      Icons.person,
                                      color: Colors.black,
                                    )
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  onPressed: (){
                                    _welcomeBloc.nextButtonChanged.add(false);
                                  },
                                  child: Text('Exit'),
                                ),
                                StreamBuilder(
                                  initialData: false,
                                  stream: _welcomeBloc.enableNextButton,
                                  builder: (context, snapshot)
                                  => TextButton(
                                    onPressed: snapshot.data
                                        ? () => _welcomeBloc.nextButtonChanged.add(true)
                                        : null,
                                    child: Row(
                                      children: [
                                        Text('Continue'),
                                        Icon(Icons.navigate_next)
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
            ),
          )
        ],
      ),
    );
  }
}
