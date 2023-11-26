import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:pa_mobile/screen/welcome.dart';
import 'package:pa_mobile/services/storage.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Storage().get_link("introduction"),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data!.length > 0) {
              return IntroductionScreen(
                globalBackgroundColor:
                    Theme.of(context).scaffoldBackgroundColor,
                pages: [
                  PageViewModel(
                    title: "Selamat Datang di Toko 3Thrift",
                    decoration: PageDecoration(
                      pageColor: Theme.of(context).highlightColor,
                      titleTextStyle: TextStyle(
                          color: Theme.of(context).hintColor, fontSize: 25),
                    ),
                    bodyWidget: Column(
                      children: [
                        Text(
                            "Temukan barang-barang berkualitas dengan harga terjangkau di toko thrift kami.",
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center),
                      ],
                    ),
                    image: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(snapshot.data![0][0]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  PageViewModel(
                    title: "Cari Barang Favorit Anda",
                    decoration: PageDecoration(
                      pageColor: Theme.of(context).highlightColor,
                      titleTextStyle: TextStyle(
                          color: Theme.of(context).hintColor, fontSize: 25),
                    ),
                    bodyWidget: Column(
                      children: [
                        Text(
                            "Jelajahi koleksi kami dan temukan barang thrift yang sesuai dengan selera Anda.",
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center),
                      ],
                    ),
                    image: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(snapshot.data![0][1]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  PageViewModel(
                    title: "Beli dan Hemat",
                    decoration: PageDecoration(
                      pageColor: Theme.of(context).highlightColor,
                      titleTextStyle: TextStyle(
                          color: Theme.of(context).hintColor, fontSize: 25),
                    ),
                    bodyWidget: Column(
                      children: [
                        Text(
                            "Dengan belanja di toko 3Thrift, Anda dapat mendapatkan barang berkualitas tanpa harus menguras dompet.",
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center),
                      ],
                    ),
                    image: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(snapshot.data![0][2]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
                showNextButton: true,
                showSkipButton: true,
                skip: const Text("Lewati"),
                next: const Text("Selanjutnya"),
                done: const Text("Selesai"),
                onSkip: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const welcome();
                      },
                    ),
                  );
                },
                onDone: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const welcome();
                      },
                    ),
                  );
                },
              );
            } else {
              return Container(
                color: ThemeData().scaffoldBackgroundColor,
              );
            }
          }
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        });
  }
}