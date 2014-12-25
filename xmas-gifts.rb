require 'csv'
@xmasgifts = []

def try_load_gifts
	filename = ARGV.first # first argument passed from the command line
	return if filename.nil? # exits out of method if no argument passed
	if File.exists?(filename)
		load_gifts(filename)
		puts "Loaded #{@xmasgifts.length} records from #{filename}"
	else
		puts "Sorry #{filename} doesn't exist."
		exit
	end
end

def interactive_menu
	loop do
		print_menu 
		process(STDIN.gets.chomp) 
	end
end

def print_menu
	puts "1. Input gifts"
	puts "2. Show the gifts"
	puts "3. Save gifts to csv file"
	puts "4. Load gifts from csv file"
	puts "9. Exit"
end

def process(selection)
	case selection
		when "1" then input_gifts 
		when "2" then show_gifts 
		when "3" then save_gifts 
		when "4" then load_gifts 
		when "9" then exit
		else puts "I don't know what you mean, please try again."		
	end
end

def input_gifts
	puts "Please enter a description of the gift received"
	puts "To finish, just hit return twice!"
	capture_gift
	while !@gift.empty? do
		add_gifts(@gift, capture_receiver, capture_giver)
		print "You have entered #{@xmasgifts.length} gift#{@xmasgifts.length != 1 ? "s" : ""}, please add another or return to get back to menu"
		capture_gift
	end
	@xmasgifts
end 

def capture_gift
	@gift = STDIN.gets.chomp
end

def capture_receiver
	puts "Please enter the receiver of the gift, or return to use unknown as default"
	receiver = STDIN.gets.chomp
	if receiver.empty?
		receiver = 'UK'
	end
	receiver
end

def capture_giver
	puts "Please enter who gave the gift, or return to use unknown as default"
	giver = STDIN.gets.chomp
	if giver.empty?
		giver = 'unknown'
	end
	giver
end

def add_gifts(gift, receiver, giver)
	@xmasgifts << {:gift => @gift, :receiver => receiver, :giver => giver}
end

def show_gifts
	if !@xmasgifts.empty?
		print_header
		print_gift_list
		print_footer
	else
		puts "You don't have any gifts"
	end
end

def print_header
puts "The gifts of Christmas 2014 at 32 Temple Road"
puts "---------------------------------------------"	
end

def print_gift_list
	@xmasgifts.sort_by{ |x| x[:receiver]}.each do |gifts|
		# optional filters
		# if student[:name][0].downcase == 'a'
		# if student[:name].length < 12
	puts "#{gifts[:receiver]} received #{gifts[:gift]} from #{gifts[:giver]}"
	end	
end

def print_footer 
puts "Overall we have received #{@xmasgifts.length} fabulous presents"
end

def load_gifts # got stuck on trying to parse each line read in, until realised it was read as an array!
	CSV.foreach(get_filename) do |line| # doesn't validate that user input filename exists
		@gift = line[0]
		receiver = line[1]
		giver = line[2]
		add_gifts(@gift, receiver, giver)
	end
end

def save_gifts
	CSV.open(get_filename, "wb") do |csv|
		@xmasgifts.each do |gifts|
  		csv << [gifts[:gift], gifts[:receiver], gifts[:giver]]
	end
end
end

def get_filename
	filename = "xmasgifts.csv" # sets default filename can be overwritten by user
	puts "What filename would you like to use"
	puts "just hit enter to use default of xmasgifts.csv"
	user_filename = STDIN.gets.chomp
	if !user_filename.empty? # if user has input something use that file name rather than the default
		filename = user_filename
	end
	filename
end

try_load_gifts
interactive_menu