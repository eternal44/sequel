require 'sequel'

DB = Sequel.sqlite # memory database, requires sqlite3

DB.create_table :items do
  primary_key :id
  String :name
  Float :price
end

items = DB[:items] # Create a dataset

# Populate the table
items.insert(:name => 'abc', :price => rand * 100)
items.insert(:name => 'def', :price => rand * 100)
items.insert(:name => 'ghi', :price => rand * 100)
items.insert(:name => 'cat', :price => rand * 100)
items.insert(:name => 'bat', :price => rand * 100)
items.insert(:name => 'dat', :price => rand * 100)
items.insert(:name => 'nose', :price => 50)
items.insert(:name => 'ear', :price => 50)

# Print out the number of records
puts "Item count: #{items.count}"

# Print out the average price
puts "The average price is: #{items.avg(:price)}"

# Another way of getting average
puts DB[:items].avg(:price)

# accessing dataset
dataset = DB['select * from items']
puts dataset.map(:name)
puts dataset.all
puts dataset.first

# mapping selected columns from results
result = []
DB['select * from items'].each do |row|
  result << [row[:id], row[:name]]
end

puts result.to_s

# idiomatic way of mapping selected columns from results
item_set = DB[:items]
puts item_set.map([:id, :name]).to_s

# 'where' statements
puts items[:id => 2]

puts items.where(:id => 1..3).all.to_s
puts items.where(:name => ['cat', 'bat']).all.to_s
puts items.where('price > 50').all.to_s

# passing in parameters to query
amount = 50
puts items.where("price > ?", amount).all.to_s

# sorting results
puts 'first' + item_set.order(:price).all.to_s

# order by 2 parameters.
# In the case where 2 items have the same price -> they're ordered by their names
puts 'second' + item_set.order(:price).order_append(:name).all.to_s

puts ''

# select
puts item_set.select(:price, :name).all.to_s

# delete.  use similar pattern for 'update'
puts item_set.where('price < ?', amount).delete

# transactions
DB.transaction do
  items.insert(:name => 'abc', :price => rand * 100)
  if items.order(:id).last[:price]> 50
    raise Sequel::Rollback
  end
end

class Item < Sequel::Model
end


