import 'package:dartz/dartz.dart';
import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_movie/src/domain/entities/movie.dart';
import 'package:ditonton_movie/src/domain/repositories/movie_repository.dart';

class SearchMovies {
  final MovieRepository repository;

  SearchMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute(String query) {
    return repository.searchMovies(query);
  }
}
