import 'package:flutter/material.dart';

class Filter {
  bool isProfane(String stringToTest) {
    final lowerCaseStringToTest = stringToTest.toLowerCase();
    return wordList
        .where((word) => lowerCaseStringToTest.contains(word))
        .isNotEmpty;
  }

  String clean(String stringToObfuscate) {
    final listToTest = stringToObfuscate.split(' ');
    final clean = listToTest.map((e) {
      if (wordSet.contains(e.toLowerCase())) {
        return e.replaceAll(RegExp('.'), '*');
      }
      return e;
    });

    return clean.join(' ');
  }

  bool isShort(String name) {
    if (name.length < 4) {
      return true;
    }
    return false;
  }

  bool containBadCharacters(String name) {
    if (name.contains(' ')) {
      return true;
    }
    if (RegExp('[a-zA-Z0-9]').hasMatch(name)) {
      return false;
    }
    return true;
  }

  bool tooLong(String name) {
    if (name.length > 16) {
      return true;
    }
    return false;
  }

  bool operateCheck(TextEditingController nameController, context) {
    if (isProfane(nameController.text)) {
      nameController.text = '';
      showDialog(
        context: context,
        builder: (_) => BadNameOverlay(
          mainText: 'name contains profane words',
        ),
      );
      return false;
    }
    if (isShort(nameController.text)) {
      nameController.text = '';
      showDialog(
        context: context,
        builder: (_) => BadNameOverlay(
          mainText: 'name is too short',
        ),
      );
      return false;
    }
    if (containBadCharacters(nameController.text)) {
      nameController.text = '';
      showDialog(
        context: context,
        builder: (_) => BadNameOverlay(
          mainText: 'name contains bad letters',
        ),
      );
      return false;
    }
    if (tooLong(nameController.text)) {
      nameController.text = '';
      showDialog(
        context: context,
        builder: (_) => BadNameOverlay(
          mainText: 'name is too long',
        ),
      );
      return false;
    }
    return true;
  }
}

class BadNameOverlay extends StatefulWidget {
  final String mainText;
  BadNameOverlay({this.mainText = 'error'});
  @override
  State<StatefulWidget> createState() => BadNameOverlayState();
}

class BadNameOverlayState extends State<BadNameOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 377),
    );
    scaleAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.decelerate,
    );
    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: ShapeDecoration(
              color: Theme.of(context).backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Text(
                this.widget.mainText,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const wordList = <String>[
  "4r5e",
  "5h1t",
  "5hit",
  "a55",
  "anal",
  "anus",
  "ar5e",
  "arrse",
  "arse",
  "ass",
  "ass-fucker",
  "asses",
  "assfucker",
  "assfukka",
  "asshole",
  "assholes",
  "asswhole",
  "a_s_s",
  "b!tch",
  "b00b",
  "b00bs",
  "b17ch",
  "b1tch",
  "ballbag",
  "balls",
  "ballsack",
  "bastard",
  "beastial",
  "beastiality",
  "bellend",
  "bestial",
  "bestiality",
  "bi+ch",
  "biatch",
  "bitch",
  "bitcher",
  "bitchers",
  "bitches",
  "bitchin",
  "bitching",
  "bloody",
  "blow job",
  "blowjob",
  "blowjobs",
  "boiolas",
  "bollock",
  "bollok",
  "boner",
  "boob",
  "boobs",
  "booobs",
  "boooobs",
  "booooobs",
  "booooooobs",
  "breasts",
  "buceta",
  "bugger",
  "bum",
  "bunny fucker",
  "butt",
  "butthole",
  "buttmuch",
  "buttplug",
  "c0ck",
  "c0cksucker",
  "carpet muncher",
  "cawk",
  "chink",
  "cipa",
  "cl1t",
  "clit",
  "clitoris",
  "clits",
  "cnut",
  "cock",
  "cock-sucker",
  "cockface",
  "cockhead",
  "cockmunch",
  "cockmuncher",
  "cocks",
  "cocksuck",
  "cocksucked",
  "cocksucker",
  "cocksucking",
  "cocksucks",
  "cocksuka",
  "cocksukka",
  "cok",
  "cokmuncher",
  "coksucka",
  "coon",
  "cox",
  "crap",
  "cum",
  "cummer",
  "cumming",
  "cums",
  "cumshot",
  "cunilingus",
  "cunillingus",
  "cunnilingus",
  "cunt",
  "cuntlick",
  "cuntlicker",
  "cuntlicking",
  "cunts",
  "cyalis",
  "cyberfuc",
  "cyberfuck",
  "cyberfucked",
  "cyberfucker",
  "cyberfuckers",
  "cyberfucking",
  "d1ck",
  "damn",
  "dike",
  "dick",
  "dickhead",
  "dildo",
  "dildos",
  "dink",
  "dinks",
  "dirsa",
  "dlck",
  "dog-fucker",
  "doggin",
  "dogging",
  "donkeyribber",
  "doosh",
  "duche",
  "dyke",
  "ejaculate",
  "ejaculated",
  "ejaculates",
  "ejaculating",
  "ejaculatings",
  "ejaculation",
  "ejakulate",
  "fitt",
  "f u c k",
  "f u c k e r",
  "f4nny",
  "fag",
  "fagging",
  "faggitt",
  "faggot",
  "faggs",
  "fagot",
  "fagots",
  "fags",
  "fanny",
  "fannyflaps",
  "fannyfucker",
  "fanyy",
  "fatass",
  "fcuk",
  "fcuker",
  "fcuking",
  "feck",
  "fecker",
  "felching",
  "fellate",
  "fellatio",
  "fingerfuck",
  "fingerfucked",
  "fingerfucker",
  "fingerfuckers",
  "fingerfucking",
  "fingerfucks",
  "fistfuck",
  "fistfucked",
  "fistfucker",
  "fistfuckers",
  "fistfucking",
  "fistfuckings",
  "fistfucks",
  "flange",
  "fook",
  "fooker",
  "fuck",
  "fucka",
  "fucked",
  "fucker",
  "fuckers",
  "fuckhead",
  "fuckheads",
  "fuckin",
  "fucking",
  "fuckings",
  "fuckingshitmotherfucker",
  "fuckme",
  "fucks",
  "fuckwhit",
  "fuckwit",
  "fudge packer",
  "fudgepacker",
  "fuk",
  "fu(",
  "fuker",
  "fukker",
  "fukkin",
  "fuks",
  "fukwhit",
  "fukwit",
  "fux",
  "fux0r",
  "f_u_c_k",
  "gangbang",
  "gangbanged",
  "gangbangs",
  "gaylord",
  "gaysex",
  "goatse",
  "god-dam",
  "god-damned",
  "goddamn",
  "goddamned",
  "hardcoresex",
  "hell",
  "heshe",
  "hoar",
  "hoare",
  "hoer",
  "homo",
  "hore",
  "horniest",
  "horny",
  "hotsex",
  "jack-off",
  "jackoff",
  "jap",
  "jerk-off",
  "jism",
  "jiz",
  "jizm",
  "jizz",
  "kyrpa",
  "kawk",
  "kanker",
  "knob",
  "knobead",
  "knobed",
  "knobend",
  "knobhead",
  "knobjocky",
  "knobjokey",
  "kock",
  "kondum",
  "kondums",
  "kum",
  "kummer",
  "kumming",
  "kums",
  "kunilingus",
  "l3i+ch",
  "l3itch",
  "labia",
  "lust",
  "lusting",
  "m0f0",
  "m0fo",
  "m45terbate",
  "ma5terb8",
  "ma5terbate",
  "masochist",
  "master-bate",
  "masterb8",
  "masterbat3",
  "masterbat",
  "masterbate",
  "masterbation",
  "masterbations",
  "masturbate",
  "mo-fo",
  "mof0",
  "mofo",
  "mothafuck",
  "mothafucka",
  "mothafuckas",
  "mothafuckaz",
  "mothafucked",
  "mothafucker",
  "mothafuckers",
  "mothafuckin",
  "mothafucking",
  "mothafuckings",
  "mothafucks",
  "mother fucker",
  "motherfuck",
  "motherfucked",
  "motherfucker",
  "motherfuckers",
  "motherfuckin",
  "motherfucking",
  "motherfuckings",
  "motherfuckka",
  "motherfucks",
  "muff",
  "mutha",
  "muthafecker",
  "muthafuckker",
  "muther",
  "mutherfucker",
  "n1gga",
  "n1gger",
  "nazi",
  "nigg3r",
  "nigg4h",
  "nigga",
  "niggah",
  "niggas",
  "niggaz",
  "nigger",
  "niggers",
  "nob",
  "nob jokey",
  "nobhead",
  "nobjocky",
  "nobjokey",
  "numbnuts",
  "nutsack",
  "orgasim",
  "orgasims",
  "orgasm",
  "orgasms",
  "p0rn",
  "pawn",
  "pecker",
  "penis",
  "penisfucker",
  "phonesex",
  "phuck",
  "phuk",
  "phuked",
  "phuking",
  "phukked",
  "phukking",
  "phuks",
  "phuq",
  "pigfucker",
  "pimpis",
  "piss",
  "pissed",
  "pisser",
  "pissers",
  "pisses",
  "pissflaps",
  "pissin",
  "pissing",
  "pissoff",
  "poop",
  "porn",
  "porno",
  "pornography",
  "pornos",
  "prick",
  "pricks",
  "pron",
  "pube",
  "pusse",
  "pussi",
  "pussies",
  "pussy",
  "pussys",
  "rectum",
  "retard",
  "rimjaw",
  "rimming",
  "s hit",
  "s.o.b.",
  "sadist",
  "schlong",
  "screwing",
  "scroat",
  "scrote",
  "scrotum",
  "semen",
  "sex",
  "sh!+",
  "sh!t",
  "sh1t",
  "shag",
  "shagger",
  "shaggin",
  "shagging",
  "shemale",
  "shi+",
  "shit",
  "shitdick",
  "shite",
  "shited",
  "shitey",
  "shitfuck",
  "shitfull",
  "shithead",
  "shiting",
  "shitings",
  "shits",
  "shitted",
  "shitter",
  "shitters",
  "shitting",
  "shittings",
  "shitty",
  "skank",
  "slut",
  "sluts",
  "smegma",
  "smut",
  "snatch",
  "son-of-a-bitch",
  "spac",
  "spunk",
  "s_h_i_t",
  "t1tt1e5",
  "t1tties",
  "teets",
  "teez",
  "testical",
  "testicle",
  "tit",
  "titfuck",
  "tits",
  "titt",
  "tittie5",
  "tittiefucker",
  "titties",
  "tittyfuck",
  "tittywank",
  "titwank",
  "tosser",
  "turd",
  "tw4t",
  "twat",
  "twathead",
  "twatty",
  "twunt",
  "twunter",
  "v14gra",
  "v1gra",
  "vagina",
  "viagra",
  "vulva",
  "w00se",
  "wang",
  "wank",
  "wanker",
  "wanky",
  "whoar",
  "whore",
  "willies",
  "willy",
  "xrated",
  "xxx",
  "ahole",
  "ash0le",
  "ash0les",
  "asholes",
  "ass monkey",
  "assface",
  "assh0le",
  "assh0lez",
  "assholz",
  "asswipe",
  "azzhole",
  "bassterds",
  "bastards",
  "bastardz",
  "basterds",
  "basterdz",
  "biatch",
  "blow job",
  "boffing",
  "buttwipe",
  "c0cks",
  "c0k",
  "carpet muncher",
  "cawks",
  "clit",
  "cnts",
  "cntz",
  "cock-head",
  "cocksucker",
  "cuntz",
  "dild0",
  "dild0s",
  "dilld0",
  "dilld0s",
  "dominatricks",
  "dominatrics",
  "dominatrix",
  "enema",
  "fag1t",
  "faget",
  "fagg1t",
  "faggit",
  "fagg0t",
  "fagit",
  "fagz",
  "faig",
  "faigs",
  "fart",
  "flipping the bird",
  "fudge packer",
  "fukah",
  "fuken",
  "fukin",
  "fukk",
  "fukkah",
  "fukken",
  "fukker",
  "fukkin",
  "g00k",
  "god-damned",
  "h00r",
  "h0ar",
  "h0re",
  "hells",
  "hoor",
  "hoore",
  "japs",
  "jisim",
  "jiss",
  "knobs",
  "knobz",
  "kunt",
  "kunts",
  "kuntz",
  "lezzian",
  "lipshits",
  "lipshitz",
  "masokist",
  "massterbait",
  "masstrbait",
  "masstrbate",
  "masterbaiter",
  "masterbates",
  "motha fucker",
  "motha fuker",
  "motha fukkah",
  "motha fukker",
  "mother fucker",
  "mother fukah",
  "mother fuker",
  "mother fukkah",
  "mother fukker",
  "mother-fucker",
  "mutha fucker",
  "mutha fukah",
  "mutha fuker",
  "mutha fukkah",
  "mutha fukker",
  "n1gr",
  "nastt",
  "nigger;",
  "nigur;",
  "niiger;",
  "niigr;",
  "orafis",
  "orgasim;",
  "orgasum",
  "oriface",
  "orifice",
  "orifiss",
  "packi",
  "packie",
  "packy",
  "paki",
  "pakie",
  "paky",
  "peeenus",
  "peeenusss",
  "peenus",
  "peinus",
  "pen1s",
  "pen15",
  "penas",
  "penis-breath",
  "penus",
  "penuus",
  "phuc",
  "phuck",
  "phuk",
  "phuker",
  "phukker",
  "polac",
  "polack",
  "polak",
  "poonani",
  "pr1c",
  "pr1ck",
  "pr1k",
  "pussee",
  "puuke",
  "puuker",
  "queef",
  "queer",
  "queers",
  "queerz",
  "qweers",
  "qweerz",
  "qweir",
  "recktum",
  "scank",
  "sexy",
  "sh1ter",
  "sh1ts",
  "sh1tter",
  "sh1tz",
  "shitty",
  "shity",
  "shitz",
  "shyt",
  "shyte",
  "shytty",
  "shyty",
  "skanck",
  "skankee",
  "skankey",
  "skanks",
  "skanky",
  "slag",
  "slutty",
  "slutz",
  "va1jina",
  "vag1na",
  "vagiina",
  "vaj1na",
  "vajina",
  "vullva",
  "w0p",
  "wh00r",
  "wh0re",
  "b!+ch",
  "arschloch",
  "lesbian",
  "@\$\$",
  "amcik",
  "andskota",
  "assrammer",
  "ayir",
  "bi7ch",
  "butt-pirate",
  "cabron",
  "cazzo",
  "chraa",
  "chuj",
  "d4mn",
  "daygo",
  "dego",
  "dupa",
  "dziwka",
  "ejackulate",
  "ekto",
  "enculer",
  "faen",
  "fanculo",
  "feces",
  "feg",
  "felcher",
  "ficken",
  "flikker",
  "foreskin",
  "fotze",
  "futkretzn",
  "gook",
  "guiena",
  "h0r",
  "h4x0r",
  "helvete",
  "honkey",
  "huevon",
  "hui",
  "injun",
  "kike",
  "klootzak",
  "kraut",
  "knulle",
  "kuk",
  "kuksuger",
  "Kurac",
  "kurwa",
  "lesbo",
  "mamhoon",
  "mibun",
  "monkleigh",
  "mouliewop",
  "muie",
  "mulkku",
  "muschi",
  "nazis",
  "nepesaurio",
  "orospu",
  "perse",
  "picka",
  "pimmel",
  "pizda",
  "poontsee",
  "pr0n",
  "preteen",
  "pula",
  "pule",
  "puta",
  "puto",
  "qahbeh",
  "rautenberg",
  "schaffer",
  "schlampe",
  "schmuck",
  "screw",
  "sharmuta",
  "sharmute",
  "shipal",
  "shiz",
  "skribz",
  "skurwysyn",
  "sphencter",
  "spic",
  "spierdalaj",
  "splooge",
  "suka",
  "vittu",
  "wichser",
  "wetback",
  "yed",
  "zabourah",
  "🍆",
  "🔪",
  "🔫",
  "💩"
];

/// wordSet is the list of bad words as a set for quicker
final wordSet = Set.from(wordList);
