import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:pa_mobile/screen/welcome.dart';
import 'package:pa_mobile/screen/widget.dart';
import 'package:pa_mobile/services/storage.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Storage().get_link("introduction"),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return IntroductionScreen(
                globalBackgroundColor:
                    Theme.of(context).scaffoldBackgroundColor,
                pages: [
                  PageViewModel(
                    title: "Selamat Datang di Toko 3Thrift",
                    decoration: PageDecoration(
                      pageColor: Theme.of(context).scaffoldBackgroundColor,
                      imagePadding: const EdgeInsets.only(top: 130),
                      titleTextStyle: TextStyle(
                          color: Theme.of(context).canvasColor, fontSize: 25),
                    ),
                    bodyWidget: Column(
                      children: [
                        Text(
                            "Temukan barang-barang berkualitas dengan harga terjangkau di toko thrift kami.",
                            style: GoogleFonts.lora(
                                textStyle:
                                    Theme.of(context).textTheme.bodyLarge,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                            textAlign: TextAlign.center),
                      ],
                    ),
                    image: Container(
                      alignment: Alignment.bottomCenter,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(snapshot.data![0][6]),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  PageViewModel(
                    title: "Cari Barang Favorit Anda",
                    decoration: PageDecoration(
                      pageColor: Theme.of(context).scaffoldBackgroundColor,
                      imagePadding: const EdgeInsets.only(top: 130),
                      titleTextStyle: TextStyle(
                          color: Theme.of(context).canvasColor, fontSize: 25),
                    ),
                    bodyWidget: Column(
                      children: [
                        Text(
                            "Jelajahi koleksi kami dan temukan barang thrift yang sesuai dengan selera Anda.",
                            style: GoogleFonts.lora(
                                textStyle:
                                    Theme.of(context).textTheme.bodyLarge,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                            textAlign: TextAlign.center),
                      ],
                    ),
                    image: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(snapshot.data![0][7]),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  PageViewModel(
                    title: "Beli dan Hemat",
                    decoration: PageDecoration(
                      pageColor: Theme.of(context).scaffoldBackgroundColor,
                      imagePadding: const EdgeInsets.only(top: 130),
                      titleTextStyle: TextStyle(
                          color: Theme.of(context).canvasColor, fontSize: 25),
                    ),
                    bodyWidget: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            "Dengan belanja di toko 3Thrift, Anda dapat mendapatkan barang berkualitas tanpa harus menguras dompet.",
                            style: GoogleFonts.lora(
                                textStyle:
                                    Theme.of(context).textTheme.bodyLarge,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                            textAlign: TextAlign.center),
                      ],
                    ),
                    image: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(snapshot.data![0][8]),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
                showNextButton: true,
                showSkipButton: true,
                skip: texts(context, "Lewati", 16, TextAlign.start),
                next: Icon(
                  Icons.arrow_forward_rounded,
                  size: 30,
                  color: Theme.of(context).canvasColor,
                ),
                done: texts(context, "Selesai", 16, TextAlign.start),
                onSkip: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const Welcome();
                      },
                    ),
                  );
                },
                onDone: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const Welcome();
                      },
                    ),
                  );
                },
              );
            } else {
              return Container(
                color: Theme.of(context).scaffoldBackgroundColor,
              );
            }
          }
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        });
  }
}
