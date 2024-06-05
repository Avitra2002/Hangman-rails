class Movie < ActiveRecord::Base
  def self.with_ratings(ratings_list)
    if ratings_list.nil? || ratings_list.empty?
      # If ratings_list is nil or empty, retrieve ALL movies
      return Movie.all
    else
      # If ratings_list is not nil or empty, filter movies by the specified ratings
      return Movie.where(rating: ratings_list)
    end
  end
end
