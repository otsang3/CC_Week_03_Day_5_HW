class Screen
  attr_accessor :film_id, :showing_time, :remaining_tickets
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i
    @film_id = options['film_id'].to_i
    @showing_time = options['showing_time']
    @remaining_tickets = options['remaining_tickets'].to_i
  end

  def save()
    sql = "INSERT INTO screenings
           ( film_id, showing_time, remaining_tickets )
           VALUES ( $1, $2, $3) RETURNING id"
    values = [@film_id, @showing_time, @remaining_tickets]
    screen = SqlRunner.run(sql, values).first
    @id = screen['id'].to_i
  end

  # delete everything from the screening table
  def Screen.delete_all()
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql, [])
  end

  # find all screening times for a giving film
  def find_screening_times(film)
    sql = "SELECT * FROM screenings
           WHERE film_id = $1"
    values = [film.id]
    showing_times = SqlRunner.run(sql, values)
    showing_times.map {|showing_time| Screen.new(showing_time)}
  end

  # return movie screen with the lowest remaining tickets, ie. most popular
  def Screen.popular(film)
    sql = "SELECT * FROM screenings
           WHERE film_id = $1"
    values = [film.id]
    films = SqlRunner.run(sql, values)
    result = films.map {|film_hash| Screen.new(film_hash)}
    return result.min_by {|time| time.remaining_tickets}
  end

end
