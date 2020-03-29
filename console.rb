require('pry-byebug')
require_relative('./models/customer')
require_relative('./models/film')
require_relative('./models/ticket')
require_relative('./models/screen')

Screen.delete_all()
Customer.delete_all()
Film.delete_all()
Ticket.delete_all()

customer1 = Customer.new({'name' => 'Oscar', 'funds' => 20})
customer2 = Customer.new({'name' => 'Erika', 'funds' => 30})
customer1.save()
customer2.save()

film1 = Film.new({'title' => 'Matrix', 'price' => 8})
film2 = Film.new({'title' => 'Terminator', 'price' => 10})
film1.save()
film2.save()

ticket1 = Ticket.new({'customer_id' => customer1.id, 'film_id' => film1.id})
ticket2 = Ticket.new({'customer_id' => customer2.id, 'film_id' => film1.id})
ticket1.save()
ticket2.save()

screen1 = Screen.new({'film_id' => film1.id, 'showing_time' => '18:45',
                      'remaining_tickets' => 50})
screen2 = Screen.new({'film_id' => film1.id, 'showing_time' => '21:00',
                      'remaining_tickets' => 25})
screen1.save()
screen2.save()

binding.pry
nil
