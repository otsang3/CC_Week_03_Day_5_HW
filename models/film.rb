require_relative('../db/sql_runner')
require_relative('./customer')

class Film
  attr_accessor :title, :price, :tickets_sold
  attr_reader :id

  def initialize(options)
    @title = options['title']
    @price = options['price']
    @id = options['id'].to_i
    @tickets_sold = 0
  end

  def save()
    sql = "INSERT INTO films (title, price, tickets_sold)
           VALUES ($1, $2, $3) RETURNING id"
    values = [@title, @price, @tickets_sold]
    film = SqlRunner.run(sql, values).first
    @id = film['id'].to_i
  end

  def Film.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql, [])
  end

  def Film.all()
    sql = "SELECT * FROM films"
    films = SqlRunner.run(sql, [])
    all_films = films.map {|film| Film.new(film)}
    return all_films
  end

  def update()
    sql = "UPDATE films
           SET title = $1, price = $2
           WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM films WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  # Return all customers that have purchased given film
  def customers()
    sql = "SELECT customers.*
           FROM customers
           INNER JOIN tickets ON customers.id = tickets.customer_id
           WHERE film_id = $1"
    values = [@id]
    customers = SqlRunner.run(sql, values)
    all_customers = customers.map {|customer| Customer.new(customer)}
    return all_customers
  end

  # Return tickets_sold for given film
  def no_of_customers()
    sql = "SELECT tickets_sold
           FROM films
           WHERE id = $1"
    values = [@id]
    no_of_customers = SqlRunner.run(sql, values).first
    return no_of_customers['tickets_sold']
  end

  def find()
    sql = "SELECT * FROM films WHERE id = $1"
    values = [@id]
    film = SqlRunner.run(sql, values).first
    return film
  end

end
