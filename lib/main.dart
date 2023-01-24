import 'package:blogclub/carousel/carousel_slider.dart';
import 'package:blogclub/data.dart';
import 'package:blogclub/gen/assets.gen.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const defualtFontFamily = 'Avenir';
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const primaryTextColor = Color(0xff0D253C);
    const secondaryTextColor = Color(0xff2D4379);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          bodyText2: TextStyle(
              fontFamily: defualtFontFamily,
              color: secondaryTextColor,
              fontSize: 12),
          headline4: TextStyle(
              fontFamily: defualtFontFamily,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: primaryTextColor),
          headline6: TextStyle(
              fontFamily: defualtFontFamily,
              fontWeight: FontWeight.bold,
              color: primaryTextColor),
          subtitle1: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w200,
              fontFamily: defualtFontFamily,
              color: secondaryTextColor),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stories = AppDatabase.stories;
    final categories = AppDatabase.categories;
    final textTheme = Theme.of(context).textTheme;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 16, 32, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hi, Jonathan!',
                      style: textTheme.subtitle1,
                    ),
                    Image.asset(
                      Assets.img.icons.notification.path,
                      width: 32,
                      height: 32,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 0, 20),
                child: Text(
                  'Explore today\'s',
                  style: textTheme.headline4,
                ),
              ),
              _StoryList(size: size, stories: stories),
              const SizedBox(
                height: 20,
              ),
              _CatagoryList(categories: categories, textTheme: textTheme)
            ],
          ),
        ),
      ),
    );
  }
}

class _CatagoryList extends StatelessWidget {
  const _CatagoryList({
    Key? key,
    required this.categories,
    required this.textTheme,
  }) : super(key: key);

  final List<Category> categories;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CarouselSlider.builder(
        itemCount: categories.length,
        itemBuilder: ((context, index, realIndex) {
          final categoriesIndex = categories[realIndex];
          final itemIndex = index;
          return _CategoryItem(
            categories: categories,
            categoriesIndex: categoriesIndex,
            textTheme: textTheme,
            itemIndex: itemIndex,
          );
        }),
        options: CarouselOptions(
            padEnds: false,
            aspectRatio: 1.3,
            scrollPhysics: const BouncingScrollPhysics(),
            initialPage: 0,
            disableCenter: true,
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
            enableInfiniteScroll: false,
            scrollDirection: Axis.horizontal),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final itemIndex;
  const _CategoryItem({
    Key? key,
    required this.categories,
    required this.categoriesIndex,
    required this.textTheme,
    required this.itemIndex,
  }) : super(key: key);

  final List<Category> categories;
  final Category categoriesIndex;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 100,
          right: 60,
          left: 60,
          bottom: 20,
          child: Container(
            decoration: const BoxDecoration(boxShadow: [
              BoxShadow(blurRadius: 20, color: Color.fromARGB(112, 13, 37, 60))
            ]),
          ),
        ),
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.fromLTRB(itemIndex == 0 ? 32 : 20, 0,
                itemIndex == categories.length - 1 ? 20 : 20, 35),
            child: Container(
              foregroundDecoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(32)),
                gradient: LinearGradient(
                    end: Alignment.topCenter,
                    begin: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 13, 37, 60),
                      Colors.transparent,
                    ]),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Image.asset(
                  'assets/img/posts/large/${categoriesIndex.imageFileName}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 70,
          left: 70,
          child: Text(
            categoriesIndex.title,
            style: textTheme.headline6!.apply(color: Colors.white),
          ),
        )
      ],
    );
  }
}

class _StoryList extends StatelessWidget {
  const _StoryList({
    Key? key,
    required this.size,
    required this.stories,
  }) : super(key: key);

  final Size size;
  final List<StoryData> stories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      width: size.width,
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: stories.length,
          itemBuilder: ((context, index) {
            final story = stories[index];
            var itemIndex = index;
            return _Story(stories: stories, story: story, itemIndex: itemIndex);
          })),
    );
  }
}

class _Story extends StatelessWidget {
  final itemIndex;

  const _Story({
    Key? key,
    required this.stories,
    required this.story,
    required this.itemIndex,
  }) : super(key: key);

  final List<StoryData> stories;
  final StoryData story;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(itemIndex == 0 ? 32 : 10, 3,
          itemIndex == stories.length - 1 ? 10 : 0, 0),
      child: Column(
        children: [
          Stack(children: [
            story.isViewed ? _profileImageviwed() : _profileImageNormal(),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                'assets/img/icons/${story.iconFileName}',
                height: 25,
                width: 25,
              ),
            )
          ]),
          const SizedBox(
            height: 10,
          ),
          Text(story.name)
        ],
      ),
    );
  }

  Widget _profileImageviwed() {
    return SizedBox(
      width: 68,
      height: 68,
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(24),
        color: const Color(0xff7b8bb2),
        strokeWidth: 2,
        dashPattern: const [5, 4],
        padding: const EdgeInsets.all(7),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
          child: _profileImage(),
        ),
      ),
    );
  }

  Widget _profileImageNormal() {
    return Container(
      width: 68,
      height: 68,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff376AED),
              Color(0xff49B0E2),
              Color(0xff9CECFB),
            ]),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(22)),
          child: Container(
            margin: const EdgeInsets.all(5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: Image.asset(
                'assets/img/stories/${story.imageFileName}',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(17),
      child: Image.asset(
        'assets/img/stories/${story.imageFileName}',
      ),
    );
  }
}
