import 'package:flutter/material.dart';
import 'package:google_gemini/google_gemini.dart';

const apiKey =
    "AIzaSyAkf6_NHYVRxmNIqiqpiS6FctQUu9d2W4Q"; // inserta tu clave de API de Gemini aquí.

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      useMaterial3: true,
    ),
    home: const MyHomePage(),
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Google Gemini IA 😲",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: <Widget>[
          Image.network('https://urianviera.com/assets/imgs/perfil.png'),
        ],
      ),
      body: const TextWithImage(),
    );
  }
}

class TextWithImage extends StatefulWidget {
  const TextWithImage({Key? key}) : super(key: key);

  @override
  State<TextWithImage> createState() => _TextWithImageState();
}

class _TextWithImageState extends State<TextWithImage> {
  bool loading = false;
  List textChat = [];

  final TextEditingController _textController = TextEditingController();
  final ScrollController _controller = ScrollController();

  // Crear instancia de Gemini
  final gemini = GoogleGemini(apiKey: apiKey);

  // Entrada solo de texto
  void fromText({required String query}) {
    setState(() {
      loading = true;
      textChat.add({
        "role": "User",
        "text": query,
      });
      _textController.clear();
    });
    scrollToTheEnd();

    gemini.generateFromText(query).then((value) {
      setState(() {
        loading = false;
        textChat.add({"role": "Gemini", "text": value.text});
      });
      scrollToTheEnd();
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
        textChat.add({"role": "Gemini", "text": error.toString()});
      });
      scrollToTheEnd();
    });
  }

  void scrollToTheEnd() {
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (textChat.isEmpty) ...[
            const Expanded(
                flex: 10,
                child: Center(
                  child: Text(
                    'Hola👋 soy Gemini:)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontSize: 20,
                    ),
                  ),
                ))
          ],
          Expanded(
            child: ListView.builder(
              controller: _controller,
              itemCount: textChat.length,
              padding: const EdgeInsets.only(bottom: 20),
              itemBuilder: (context, index) {
                return ListTile(
                  isThreeLine: true,
                  leading: CircleAvatar(
                    child: Text(textChat[index]["role"].substring(0, 1)),
                  ),
                  title: Text(textChat[index]["role"]),
                  subtitle: Text(textChat[index]["text"]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 26),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _textController,
                    minLines: 1,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Preguntale a Gemini 😲',
                      contentPadding: const EdgeInsets.only(
                        left: 20,
                        top: 10,
                        bottom: 10,
                      ),
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(height: 0),
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: loading
                            ? const CircularProgressIndicator()
                            : InkWell(
                                onTap: () {
                                  fromText(query: _textController.text);
                                },
                                child: const CircleAvatar(
                                  backgroundColor: Colors.deepPurpleAccent,
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
