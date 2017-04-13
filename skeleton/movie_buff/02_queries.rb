def eighties_b_movies
  # List all the movies from 1980-1989 with scores falling between 3 and 5 (inclusive).
  # Show the id, title, year, and score.
  Movie.select(:id, :title, :yr, :score)
    .where(score: 3..5, yr: 1980..1989)
end

def bad_years
  # List the years in which a movie with a rating above 8 was not released.
  Movie.select(:yr)
    .group(:yr)
    .having("MAX(score) < 8")
    .pluck(:yr)
end

def cast_list(title)
  # List all the actors for a particular movie, given the title.
  # Sort the results by starring order (ord). Show the actor id and name.
  Movie.select("actors.id, actors.name")
    .joins(:actors)
    .where("movies.title = ?", title)
    .group("actors.id, actors.name, castings.ord")
    .order("castings.ord ASC")
end

def vanity_projects
  # List the title of all movies in which the director also appeared as the starring actor.
  # Show the movie id and title and director's name.

  # Note: Directors appear in the 'actors' table.
  Movie.select("movies.id, movies.title, actors.name")
    .joins(:director)
    .where("actors.name in
            (SELECT actors.name
            FROM castings
            JOIN actors on castings.actor_id = actors.id
            WHERE ord = 1
            AND movie_id = movies.id)")

end

def most_supportive
  # Find the two actors with the largest number of non-starring roles.
  # Show each actor's id, name and number of supporting roles.
  Actor.select("actors.id, actors.name, count(*) as roles")
    .joins(:castings)
    .where("ord != 1")
    .group("actors.id, actors.name")
    .order("count(ord) desc")
    .limit(2)
end