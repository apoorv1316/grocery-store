require 'terminal-table/import'
class Grocery_store
  def initialize
    @total = 0
    @discount = 0
    @cart = Hash.new(0)
    @invoice_table =[]
    @item_prices =[]
    @items_list = {
      'milk' => {
        'price' => 3.97,
        'sale' => {
          'quantity' => 2,
          'sale_price' => 5
        }
      },
      'bread' => {
        'price' => 2.17,
        'sale' => {
          'quantity' => 3,
          'sale_price' => 6
        }
      },
      'banana' => {
        'price' => 0.99
      },
      'apple' => {
        'price' => 0.89
      }
    }
  end

  def calculate_amount(items)
    items.each { |item| @cart[item.downcase] += 1 if @items_list[item.downcase] }

    @cart.each do |item, order_quantity|
      if @items_list[item]['sale'] && order_quantity >= @items_list[item]['sale']['quantity']

        item_total = (@items_list[item]['sale']['sale_price']) +
                     ((@items_list[item]['price']) * (order_quantity - (@items_list[item]['sale']['quantity'])))
        
        @invoice_table << [item, order_quantity,item_total]
        @total += item_total

        @discount += (((@items_list[item]['sale']['quantity']) * (@items_list[item]['price'])) - (@items_list[item]['sale']['sale_price']))
      else
        item_total = (@items_list[item]['price']) * order_quantity
        @invoice_table << [item, order_quantity,item_total]
        @total += item_total
      end
    end
    
    invoice
  end
end

def invoice
  item_table = table { |t|
    t.headings = "Items", "Quantity", "Price"
    @invoice_table.each { |row| t << row }
  }
  puts item_table
  puts "Your total is $ #{@total}"
  puts "You saved $ #{@discount.round(2)}"
end


grocery = Grocery_store.new
puts 'Please enter all the items purchased separated by a comma'
items = gets.chomp.gsub(/\s+/, '').split(',')
grocery.calculate_amount(items)
