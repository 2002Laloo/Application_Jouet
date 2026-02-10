import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mokache',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> mots = [
    {'mot': 'BONJOU', 'indice': 'Yon mo ou itilize pou salye moun.'},
    {'mot': 'CHAT', 'indice': 'Yon ti bèt kay ki myaule.'},
    {'mot': 'KAY', 'indice': 'Kote ou rete ak fanmi ou.'},
    {'mot': 'MACHIN', 'indice': 'Yon veyikil ki gen kat wou.'},
    {'mot': 'JADEN', 'indice': 'Yon espas vèt kote ou plante flè.'},
    {'mot': 'SOLÈY', 'indice': 'Li klere nan syèl la pandan jounen.'},
    {'mot': 'CHOKOLA', 'indice': 'Yon fwiyandiz dous ki fèt ak kakao.'},
    {'mot': 'MIZIK', 'indice': 'Yon atizay ki melanje son ak ritm.'},
    {'mot': 'FANMI', 'indice': 'Yon gwoup moun ki lye pa san.'},
    {'mot': 'LEKOL', 'indice': 'Kote timoun ale pou aprann.'},
    {'mot': 'ZORANJ', 'indice': 'Yon fwi won ki gen anpil vitamin C.'},
    {'mot': 'AYITI', 'indice': 'Peyi nan Karayib, kapital Pòtoprens.'},
    {'mot': 'MANGO', 'indice': 'Yon fwi tropikal dous e jisi.'},
    {'mot': 'FUTBOL', 'indice': 'Espò popilè ak yon balon won.'},
    {'mot': 'DLO', 'indice': 'Ou bwè sa chak jou pou viv.'},
  ];

  late String motCache;
  late String indice;
  List<String> lettresEssayees = [];
  int chancesRestantes = 5;
  List<String> motAffiche = [];
  final _random = Random();
  bool jeuTermine = false;

  final List<String> rangee1 = [
    'Q',
    'W',
    'E',
    'R',
    'T',
    'Y',
    'U',
    'I',
    'O',
    'P',
  ];
  final List<String> rangee2 = ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'];
  final List<String> rangee3 = ['Z', 'X', 'C', 'V', 'B', 'N', 'M'];

  @override
  void initState() {
    super.initState();
    demarrerNouveauJeu();
  }

  void demarrerNouveauJeu() {
    var element = mots[_random.nextInt(mots.length)];
    motCache = element['mot']!;
    indice = element['indice']!;
    lettresEssayees = [];
    chancesRestantes = 5;
    jeuTermine = false;
    motAffiche = [];
    for (int i = 0; i < motCache.length; i++) {
      motAffiche.add('*');
    }
    setState(() {});
  }

  void essayerLettre(String lettre) {
    if (lettresEssayees.contains(lettre) || jeuTermine) return;
    setState(() {
      lettresEssayees.add(lettre);
      if (motCache.contains(lettre)) {
        for (int i = 0; i < motCache.length; i++) {
          if (motCache[i] == lettre) motAffiche[i] = lettre;
        }
      } else {
        chancesRestantes = chancesRestantes - 1;
      }
      if (!motAffiche.contains('*')) {
        jeuTermine = true;
        allerEcranResultat(gagne: true);
      } else if (chancesRestantes == 0) {
        jeuTermine = true;
        allerEcranResultat(gagne: false);
      }
    });
  }

  void allerEcranResultat({required bool gagne}) {
    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EcranResultat(
            gagne: gagne,
            mot: motCache,
            onRecommencer: () {
              Navigator.pop(context);
              demarrerNouveauJeu();
            },
          ),
        ),
      );
    });
  }

  Widget construireBoutonLettre(String lettre) {
    bool dejaEssayee = lettresEssayees.contains(lettre);
    bool bonneLettre = motCache.contains(lettre);
    Color? couleur;
    if (dejaEssayee && bonneLettre) {
      couleur = Colors.green;
    } else if (dejaEssayee && !bonneLettre) {
      couleur = Colors.red;
    } else {
      couleur = null;
    }
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(2),
        child: ElevatedButton(
          onPressed: (dejaEssayee || jeuTermine)
              ? null
              : () => essayerLettre(lettre),
          style: couleur != null
              ? ElevatedButton.styleFrom(
                  backgroundColor: couleur,
                  foregroundColor: Colors.white,
                  minimumSize: Size(0, 44),
                  padding: EdgeInsets.all(0),
                )
              : ElevatedButton.styleFrom(
                  minimumSize: Size(0, 44),
                  padding: EdgeInsets.all(0),
                ),
          child: Text(lettre, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget construireRangeeClavier(List<String> lettres) {
    List<Widget> boutons = [];
    for (int i = 0; i < lettres.length; i++) {
      boutons.add(construireBoutonLettre(lettres[i]));
    }
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: boutons);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mokache"),
        leading: TextButton(child: Icon(Icons.gamepad), onPressed: () {}),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              demarrerNouveauJeu();
            },
          ),
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Center(
              child: Text(
                'Chances: $chancesRestantes',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                'Endis : $indice',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  motAffiche.join('  '),
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text('(${motCache.length} lèt)'),
              SizedBox(height: 15),
              if (lettresEssayees.isNotEmpty)
                Text('Eseye : ${lettresEssayees.join(", ")}'),
              Spacer(),
              construireRangeeClavier(rangee1),
              construireRangeeClavier(rangee2),
              construireRangeeClavier(rangee3),
              SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}

class EcranResultat extends StatelessWidget {
  final bool gagne;
  final String mot;
  final VoidCallback onRecommencer;

  const EcranResultat({
    required this.gagne,
    required this.mot,
    required this.onRecommencer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                gagne ? Icons.emoji_events : Icons.sentiment_very_dissatisfied,
                size: 100,
                color: gagne ? Colors.green : Colors.red,
              ),
              SizedBox(height: 20),
              Text(
                gagne ? 'BRAVO !' : 'OU PÈDI !',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                gagne ? 'Ou jwenn mo a !' : 'Ou pa gen chans ankò...',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 30),
              Text('Mo a se te :', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text(
                mot,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
              ElevatedButton(onPressed: onRecommencer, child: Text('Rejwe')),
            ],
          ),
        ),
      ),
    );
  }
}