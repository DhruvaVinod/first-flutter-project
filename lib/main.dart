//https://codelabs.developers.google.com/codelabs/flutter-codelab-first?hl=en#6
//refer 

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
// right now in this code the status bar is missing in the app on the device... we will fix that soon 
void main() {
  runApp(MyApp()); // main tells Flutter to run the app in MYApp()... runApp is a function 
}
// a widget is just a class that is predefined 
class MyApp extends StatelessWidget { //inheritance .. parent is StatelessWidget (class predefined)... child is MyApp and we need to run that 
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider( //provides info about when the MyAppState(in create ) chnages 
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // we dont need the debug banner 
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          // always use colorscheme and theme app-wide Theme as opposed to hard-coding values.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue), // changed color .. come back here 
        ),
        home: MyHomePage(), // homepage ... what opens when the app first opens 
      ),
    );
  }
}

class MyAppState extends ChangeNotifier { //  MyAppState defines the data the app needs to function 
// Changenotifiers notifies others about it's changes 
  var current = WordPair.random(); // Wordpair is a class defined in english words 
  // adding function to get next wordpair 
  void getnext(){
    current=WordPair.random();
    notifyListeners(); // notifying listeners that there's been a change in the current state of the app .. meaning the MyApp hears this 
    // because MyApp has the CHangeNotifierProvider 
  }
  var favorites = <WordPair>[]; // for favorites // new property 

  void toggleFavorite() {
    if (favorites.contains(current)) { // if it contains and the button is pressed then remove it from faves 
      favorites.remove(current);
    } else {
      favorites.add(current); // else add to faves 
    }
    notifyListeners();
  }
}

/*class MyHomePage extends StatelessWidget {
  @override // method overriding 
  Widget build(BuildContext context) {
    // instantatiating myAppState (not that this is not myapp )
    var appState = context.watch<MyAppState>(); // watching if the words have changed 
    // we will create a new widget for called pair for appstate.current because we only nee to know the wordpair (yea idrk what that means)
    var pair=appState.current;
    IconData icon; // this is for the heart 
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite; // Icons.favorites gives u the icon by defualt 
    } else {
      icon = Icons.favorite_border; // the heart 
    } 


    return Scaffold( // commonly used widget in real world apps 
      //appBar: AppBar(title: Text("home")),
      body:Center(
        child: Column ( // refactor and wrap with center 
        // we need antoher button next to next .. which means it should be a row 
          mainAxisAlignment: MainAxisAlignment.center, // aligns the column to the centre along the main axis .. i.e the centre 
          children: [
            //Text('random word generator:'), // hot reload happens when u change the source file ... it hot reloads.. hit r if you're working with terminal.. else just save and it'll reflect 
           // Text(appState.current.asLowerCase), // all lower case   
            //Text(appState.current.asCamelCase), //to get word1Word2
           // Text(pair.asPascalCase), //to get Word1Word2
            BigCard(pair: pair),
            SizedBox(height: 10), // creates virtual gap 
             //refactored the aboove comment "pascalcase"one // ctrl+shift+r and then extract widget an type name bigcard
            //refactoring it created an automatic widget at the end of the file called BIgCArd .. helpful for organising programs 
            // using pair ensures that the Text doesn't refer to the whole Appstate 
            //Text(appState.current.asSnakeCase), to get word1_word2
            // adding next button
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    print("liked"); 
                    appState.toggleFavorite();
                  }, 
                  icon:Icon(icon),
                  label: Text("LIKE"),

                ),
                SizedBox(width:10),
                ElevatedButton( // for extra button wrap with row here 
                //use mainAxisSize. This tells Row not to take all available horizontal space.
                  onPressed: (){
                  // using getnext now.. inside onpressed;
                  appState.getnext(); // appstate is instance of myAppState 
                  print("button pressed..."); // testing ... reflected in console 
                  }, 
                  child: Text('NEXT'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}*/
// ...

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //This class extends State, and can therefore manage its own values. (It can change itself.)
  //doesn't need external
  var selectedIndex = 0; // initially selected index is 0 
  @override
  Widget build(BuildContext context) { // you know selectedindex changes here so u can juts make this unction here 
    Widget page;
switch (selectedIndex) {
  case 0:
    page = GeneratorPage();
    break;
  case 1:
    page = FavoritesPage(); // placeholer draws rectangle to mark unfinished places of the app 
    break;
  default:
    throw UnimplementedError('no widget for $selectedIndex');
}

    return LayoutBuilder(
      builder: (context,constraints) { // LayoutBuilder's builder callback is called every time the constraints change.
        return Scaffold(
          body: Row(
            children: [
              SafeArea( // safarea  for nav bar 
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600, // so that it changes when something else changes iykwim 
                  //extended: false, // extending it will cause overflow on one side .. but it displays texts like home and favorites in this case 
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                    // index is selected here 
                  ],
                  selectedIndex: selectedIndex, // not hardcoded in anymore 
                  //selectedIndex: 0, // selected index 1 takes it to home 
                  onDestinationSelected: (value) { // callback function in navigationrail widget 
                    setState(() {
                      selectedIndex = value;
                    });
                    print('selected: $value'); // prints 0 on console if home is clicked 
                  },
                ),
              ),
              Expanded( // this widget takes as much space as it needs 
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer, // matching the color to color of theme 
                  child: page , // page changes with the selectedindex 
                ),
              ),
            ],
          ),
        );
      }
    );
    // now You could add selectedIndex as yet another property of MyAppState.
    // And it would work. But you can imagine that the app state would quickly grow beyond reason if every widget stored its values in it.
    //=>stateful widgets are to be used now ... god knows what that means 
  }
}
class FavoritesPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    var appstate= context.watch<MyAppState>();
    if(appstate.favorites.isEmpty){
      return Center(
        child: Text("No favorites yet!"),
      );
    }
    return ListView(
      children: [
        Padding(
        padding: const EdgeInsets.all(20),
        child: Text('You have ''${appstate.favorites.length} favorites:'),
      ),
      for (var pair in appstate.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}


class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center( // these were the contents of home page initially but now it's called the generator page .. it also doesn't have a scaffold
    // the scaffold wasn't extracted 
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getnext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ...

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  }); // on refactoring it created a widget on it's own called BIgCard 

  final WordPair pair; 

  @override
  Widget build(BuildContext context) { 
    final theme = Theme.of(context); // added theme for color .. code requests the app's current theme with Theme.of(context).
    final style = theme.textTheme.displayMedium!.copyWith( // ctrl+shit+space to see what all it can change 
    //copyWith() lets you change a lot more about the text style than just the color
      color: theme.colorScheme.surface,
    ); // deciding style 
    //theme.textTheme, you access the app's font theme
    //displayMedium .. ! ensures not null ... copywith copies the font 
    // Calling copyWith() on displayMedium returns a copy of the text style with the changes you define. 
    //In this case, you're only changing the text's color.
    //flutter decides : color scheme's onPrimary property defines a color that is a good fit for use on the app's primary color.


    return Card(
      color:theme.colorScheme.primary, //  defines the card's color to be the same as the theme's colorScheme 
      child: Padding(
        padding: const EdgeInsets.all(20.0), // also done using refactoring ... gave space between the lines in the columns 
        // Padding is a built in widget 
        child: Text(
          pair.asPascalCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}", // made this change so that the system worksbetter with visually imapred or summin dunno 
          // not imp and nto necessart ... could've left it how it was initially i.e pair.pascal case and style alone 
        ),
      ),
    );
  }

  // there was no breathing room in the beginning so now we will refactor it again and give it more space and ability to look good by doing 
  // ctrl+shift+r again around the text in the widget thing and wrap with padding 

  // after that we wanted it to come in the form of a card so we refactor Padding ... making it a child of the built in Widget Card. 
}
// prefer adding commas literally everywhere 