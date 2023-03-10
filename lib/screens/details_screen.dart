import 'package:flutter/material.dart';
import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
   
  const DetailsScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _CustomAppBar(movie),
          SliverList(
            delegate: SliverChildListDelegate([
              _PosterAndTitle(movie),
              _Overview(movie),
              CastingCads(movie.id)

            ])
          )
        ],
      )
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final Movie movie;

  const _CustomAppBar(this.movie);
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.bottomCenter,
          color: Colors.black12,
          width: double.infinity,
          child: Text(
            movie.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16))),
        background: FadeInImage(
          placeholder: const AssetImage('assets/loading.gif'),
          image: NetworkImage(movie.getFullBackdropPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final Movie movie;

  const _PosterAndTitle(this.movie);
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: NetworkImage(movie.getFullPosterUrl),
                height: 150,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title, 
                  style: textTheme.headline6, 
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2
                ),
                Text(
                  movie.originalTitle, 
                  style: textTheme.subtitle1, 
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star_outline, 
                      size: 15,
                      color: Colors.grey,  
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${movie.voteAverage}',
                      style: textTheme.caption,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  final Movie movie;
  const _Overview(this.movie);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
        movie.overview,
        style: Theme.of(context).textTheme.subtitle1,
        textAlign: TextAlign.justify,
        )
      );
  }
}