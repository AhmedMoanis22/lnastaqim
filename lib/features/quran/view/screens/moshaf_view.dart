import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lnastaqim/features/quran/bussniess_logic/quran/quran_cubit.dart';
import 'package:lnastaqim/features/quran/view/widgets/custom_span.dart';

class Moshaf extends StatelessWidget {
  const Moshaf({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: PageView.builder(
              itemCount: 604,
              padEnds: false,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                return MoshafPage(pageIndex: index);
              })),
    );
  }
}

class MoshafPage extends StatelessWidget {
  const MoshafPage({super.key, required this.pageIndex});

  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranCubit, QuranState>(
      builder: (context, state) {
        var cubit = QuranCubit.get(context);
        var pageAyahs =
            cubit.getCurrentPageAyahsSeparatedForBasmalah(pageIndex);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(pageAyahs.length, (i) {
            final ayahs = pageAyahs[i];
            return Column(
              children: [
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: RichText(
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        children: List.generate(ayahs.length, (ayahIndex) {
                      if (ayahIndex == 0) {
                        return span(
                            isFirstAyah: true,
                            text:
                                "${ayahs[ayahIndex].code_v2[0]}${ayahs[ayahIndex].code_v2.substring(1)}",
                            pageIndex: pageIndex,
                            fontSize: 100,
                            surahNum: cubit.getSurahNumberFromPage(pageIndex),
                            ayahNum: ayahs[ayahIndex].ayahUQNumber);
                      }
                      return span(
                        isFirstAyah: false,
                        text: ayahs[ayahIndex].code_v2,
                        pageIndex: pageIndex,
                        fontSize: 100,
                        surahNum: cubit.getSurahNumberFromPage(pageIndex),
                        ayahNum: ayahs[ayahIndex].ayahUQNumber,
                      );
                    })),
                  ),
                )
              ],
            );
          }),
        );
      },
    );
  }
}