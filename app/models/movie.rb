class Movie < ActiveRecord::Base

    def self.with_rating!(movies,ratingsHash)
        ratings = self.extract_ratings_from_hash(ratingsHash)
        return movies.where(rating: ratings)
    end

    def self.order_movies!(movies, orderBy)
        if orderBy == 'title'
            movies = movies.order(:title)
          elsif orderBy == 'date'
            movies = movies.order(:release_date)
        end
        return movies
    end

    def self.extract_ratings_from_hash(ratingsHash)
        if ratingsHash == nil
          ratings = Movie.get_all_ratings()
        else
          ratings = ratingsHash.keys.map { |rating| rating.upcase }
        end
        return ratings
    end

    def self.get_all_ratings()
        return ['G','PG','PG-13','R','NC-17']
    end

end
