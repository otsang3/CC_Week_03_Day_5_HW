require_relative('../db/sql_runner')
require_relative('./film')
require_relative('./ticket')

class Customer
  attr_accessor :name, :funds, :tickets_purchased
  attr_reader :id

  def initialize(options)
    @name = options['name']
    @funds = options['funds']
    @id = options['id'].to_i
    @tickets_purchased = 0
  end

  def save()
    sql = "INSERT INTO customers (name, funds, tickets_purchased)
           VALUES ($1, $2, $3) RETURNING *"
    values = [@name, @funds, @tickets_purchased]
    customer = SqlRunner.run(sql, values).first
    @id = customer['id'].to_i
  end

  def Customer.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql, [])
  end

  def Customer.all()
    sql = "SELECT * FROM customers"
    customers = SqlRunner.run(sql, [])
    all_customers = customers.map {|customer| Customer.new(customer)}
    return all_customers
  end

  def update()
    sql = "UPDATE customers
           SET name = $1, funds = $2, tickets_purchased = $3
           WHERE id = $4"
    values = [@name, @funds, @tickets_purchased, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  # find all the films that has been purchased by given customer
  def film()
    sql = "SELECT films.*
           FROM films
           INNER JOIN tickets
           ON films.id = tickets.film_id
           WHERE customer_id = $1"
    values = [@id]
    films = SqlRunner.run(sql, values)
    all_films = films.map {|film| Film.new(film)}
  end

  # find a customer for given customer id
  def find
    sql = "SELECT * FROM customers WHERE id = $1"
    values = [@id]
    customer = SqlRunner.run(sql, values).first
    return customer
  end

  # increase tickets_sold in the films table by 1
  def increase_tickets_sold(film)
    tickets_sold = film.tickets_sold += 1
    sql = "UPDATE films
           SET title = $1, price = $2, tickets_sold = $3
           WHERE id = $4"
    values = [film.title, film.price, film.tickets_sold, film.id]
    SqlRunner.run(sql, values)
  end

  # decrease remaining_tickets in the screenings table by 1
  def decrease_screen_ticket(screen)
    screen.remaining_tickets -= 1
    sql = "UPDATE screenings
           SET film_id = $1, showing_time = $2,
           remaining_tickets = $3
           WHERE id = $4"
    values = [screen.film_id, screen.showing_time,
              screen.remaining_tickets, screen.id]
    SqlRunner.run(sql, values)
  end

  # Customer buys ticket method
  # Return nil if customer does not have enough funds
  # Return nil if remaining tickets = 0
  # Ensure that when passed, customer funds is reduced by film price
  # tickets_purchased for customer in customers table is increased by 1
  # tickets_sold for film in films table is increased by 1
  def buys_ticket(screen, film)
    return 'Sorry, you do not have enough funds to make this purchase.' if @funds < film.price
    return 'Sorry, screening is full' if screening.remaining_tickets == 0
      @funds -= film.price
      @tickets_purchased += 1
      increase_tickets_sold(film)
      decrease_screen_ticket(screen)
      update
      new_ticket = Ticket.new({'customer_id' => @id,
                               'film_id' => film.id})
      new_ticket.save
      return "You have successfully purchased a ticket for #{film.title}!"
  end

  # Returns the number of tickets_purchased for a given customer
  def tickets_purchased()
    sql = "SELECT tickets_purchased
           FROM customers WHERE id = $1"
    values = [@id]
    quantity = SqlRunner.run(sql, values).first
    return quantity['tickets_purchased']
  end



end
