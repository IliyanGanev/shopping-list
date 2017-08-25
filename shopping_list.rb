require "sqlite3"

db = SQLite3::Database.new("items.db")
db.results_as_hash = true

create_table = <<-SQL
CREATE TABLE IF NOT EXISTS items(
id INTEGER PRIMARY KEY,
name VARCHAR(255),
quantity INT 
)
SQL

db.execute(create_table)

def add_item(db, name, quantity)
	db.execute("INSERT INTO items (name, quantity) VALUES (?, ?)", [name, quantity])
end

def update_item(db, name, quantity, id)
	db.execute("UPDATE items SET name=?, quantity=? WHERE id=?", [name, quantity, id])
end

def delete_item(db, id)
	db.execute("DELETE FROM items WHERE id=?", [id])
end

def clear_table(db)
	db.execute("DELETE FROM items")
end

def print_items(db)
	items = db.execute("SELECT * FROM items")
	puts "\n=========SHOPPING LIST=========\n\n"
	items.each do |item|
		puts "item#{item["id"]}: |#{item["name"]}| quantity:#{item["quantity"]}"
	end	
	puts "\n==============================="	
end

#print list on startup
print_items(db)

loop do
	puts "\n SHOPPING LIST MENU"
	puts "------------------------------------------------------------------"
	puts "ADD ITEM:type 'a'   | UPDATE ITEM:type 'u' | DELETE ITEM:type 'd' |"
	puts "PRINT ALL:type 'p'  | QUIT:type 'q'        | DELETE ALL :type 'c' |"
	puts "------------------------------------------------------------------"
	answer = gets.chomp
	case answer
	when 'a'
		loop do
			puts "Type an item to add! Type 'done' when finished!"
			item = gets.chomp
			break if item == 'done'
			puts "Type amount"
			amount = gets.chomp
			break if amount == 'done'
			add_item(db, item, amount)
		end
		print_items(db)
	when "d"
		puts "Type the number of the item you want to delete!"
		id = gets.chomp
		delete_item(db, id) 
		puts "\nITEM #{id} was DELETED from the list!!!"
		print_items(db)
	when "u"
		puts "Type the number of the item you want to update!"
		id = gets.chomp
		puts "Type the name of the new item!"
		item = gets.chomp
		puts "Type the quantity!"
		quantity = gets.chomp
		update_item(db, item, quantity, id)
		print_items(db)
	when "c"
		clear_table(db)
		puts "TABLE IS EMPTY!"
	when "p"
		print_items(db)
	when "q" 
		print_items(db)
		puts "\xC2\xA9ShopFriendzy Ltd. :-)"
		exit	
	end
end









