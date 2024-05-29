import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lnastaqim/features/bookmark/bussniess_logic/bookmark_cubit/bookmark_cubit.dart';
import 'package:lnastaqim/features/bookmark/data/models/bookmark_model.dart';
import 'package:lnastaqim/features/quran/bussniess_logic/quran/quran_cubit.dart';

import 'config/routing/app_routingconfig/app_router_configuration.dart';
import 'core/constants/constants.dart';
import 'features/bookmark/bussniess_logic/add_bookmark_cubit/add_bookmark_cubit.dart';
import 'features/quran/bussniess_logic/quran_sowar/quran_sowar_cubit.dart';
import 'features/quran/bussniess_logic/quran_sowar/search_or_not_cubit.dart';
import 'features/quran/bussniess_logic/sowra_detail/sora_details_cubit.dart';

void main() async {
  // List<List<int>> matchesInQuran=[];
  // List<int> boyerMore=boyer_more.searchPattern();
  // print("object");
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(BookmarkModelAdapter());
  await Hive.openBox<BookmarkModel>(kBookmarkBox);
  runApp(const Lnastaqim());
}

class Lnastaqim extends StatelessWidget {
  const Lnastaqim({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: const Size(393, 852),
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => QuranSowarCubit()..getAllQuranSowar(),
            ),
            BlocProvider(
              create: (context) => SearchOrNot(),
            ),
            BlocProvider(
              create: (context) => QuranSowarVersusCubit(),
            ),
            BlocProvider(
              lazy: false,
              create: (context) => QuranCubit()..loadQuran(),
            ),
            BlocProvider(create: (context) => AddBookmarkCubit()),
            BlocProvider(create: (context) => BookmarkCubit()..fetchBookmarks())
          ],
          child: GetMaterialApp(
            locale: const Locale('ar'),
            debugShowCheckedModeBanner: false,
            getPages: routes,
          ),
        );
      },
    );
  }
}
