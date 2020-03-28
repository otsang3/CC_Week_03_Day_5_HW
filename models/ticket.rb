require_relative('../db/sql_runner')

class Ticket
  attr_accessor :customer_id, :film_id, :tickets_sold
  attr_reader :id

  def initialize(options)
    @customer_id = options['customer_id'].to_i
    @film_id = options['film_id'].to_i
    @id = options['id'].to_i
  end

  def save()
    sql = "INSERT INTO tickets (customer_id, film_id)
           VALUES ($1, $2) RETURNING *"
    values = [@customer_id, @film_id]
    ticket = SqlRunner.run(sql, values).first
    @id = ticket['id'].to_i
  end

  def Ticket.delete_all()
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql, [])
  end

  def Ticket.all()
    sql = "SELECT * FROM tickets"
    tickets = SqlRunner.run(sql, [])
    all_tickets = tickets.map {|ticket| Ticket.new(ticket)}
    return all_tickets
  end

  def update()
    sql = "UPDATE tickets
           SET customer_id = $1, film_id = $2
           WHERE id = $3"
    values = [@customer_id, @film_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM tickets WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def find()
    sql = "SELECT * FROM tickets WHERE id = $1"
    values = [@id]
    ticket = SqlRunner.run(sql, values).first
    return ticket
  end


end
