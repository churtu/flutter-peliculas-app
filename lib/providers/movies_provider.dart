import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas_app/helpers/debouncer.dart';
import 'package:peliculas_app/models/models.dart';

class MoviesProvider extends ChangeNotifier{

  final String _apiKey = 'e6615f64e445171f839523a160e2badf';
  final String _language = 'es-ES';
  final String _baseUrl = 'api.themoviedb.org';
  int _popularPage = 0;

  List<Movie> playingMovies = [];
  List<Movie> popularMovies = [];
  Map<int, List<Cast>> moviesCast = {};

  final debouncer = Debouncer(duration: const Duration(milliseconds: 500));
  final StreamController<List<Movie>> _suggestionStreamController = StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => _suggestionStreamController.stream;

  MoviesProvider(){
    getOnNowPlayMovies();
    getPopularMovies();
  }

  Future<String>_getJsonData(String endpoint, [int page = 1])async{
    final url = Uri.https(
      _baseUrl,
      endpoint,
      {
        'api_key' : _apiKey,
        'language': _language,
        'page'    : '$page'
      }
    );

    final response = await http.get(url);
    return response.body;
  }

  Future<void> getOnNowPlayMovies()async{
    final String jsonData = await _getJsonData('/3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    playingMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  Future<void> getPopularMovies()async{
    _popularPage++;
    final String jsonData = await _getJsonData('/3/movie/popular', _popularPage);
    final popularMoviesResponse = PopularMoviesResponse.fromJson(jsonData);
    popularMovies = [ ...popularMovies, ...popularMoviesResponse.results ];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId)async{
    // Evaluacion si ya existe la key entonces que no haga la petición denuevo
    if(moviesCast.containsKey(movieId)) return moviesCast[movieId]!; 

    final String jsonData = await _getJsonData('/3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);
    moviesCast[movieId] = creditsResponse.cast;
    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies(String query)async{
    final url = Uri.https(
      _baseUrl,
      '3/search/movie',
      {
        'api_key' : _apiKey,
        'language': _language,
        'query'   : query
      }
    );

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);
    return searchResponse.results;
  }

  void getSuggestionByQuery(String queryTerm){
    debouncer.value = '';
    debouncer.onValue = (value)async {
      final results = await searchMovies(value);
      _suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(
      const Duration(milliseconds: 300),
      (timer) => debouncer.value = queryTerm, 
    );

    Future.delayed(const Duration(milliseconds: 301)).then((value) => timer.cancel());
  }
}