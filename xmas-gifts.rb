require 'csv'
@students = []

def try_load_students
	filename = ARGV.first # first argument passed from the command line
	return if filename.nil? # exits out of method if no argument passed
	if File.exists?(filename)
		load_students(filename)
		puts "Loaded #{@students.length} records from #{filename}"
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
	puts "1. Input the students"
	puts "2. Show the students"
	puts "3. Save students to csv file"
	puts "4. Load students from csv file"
	puts "9. Exit"
end

def process(selection)
	case selection
		when "1" then input_students 
		when "2" then show_students 
		when "3" then save_students 
		when "4" then load_students 
		when "9" then exit
		else puts "I don't know what you mean, please try again."		
	end
end

def input_students
	puts "Please enter the names of the students"
	puts "To finish, just hit return twice!"
	capture_name
	while !@name.empty? do
		add_students(@name, capture_cohort, capture_country)
		print "You have entered #{@students.length} student name"
		puts @students.length != 1 ? "s" : ""
		capture_name
	end
	@students
end 

def capture_name
	@name = STDIN.gets.chomp
end

def capture_cohort
	puts "Please enter the cohort, or return to use december default"
	cohort = STDIN.gets.chomp
	if cohort.empty?
		cohort = 'december'
	end
	cohort
end

def capture_country
	puts "Please enter the student's country, or return to use UK default"
	country = STDIN.gets.chomp
	if country.empty?
		country = 'UK'
	end
	country
end

def add_students(name, cohort, country)
	@students << {:name => @name, :cohort => cohort.to_sym, :country => country}
end

def show_students
	if !@students.empty?
		print_header
		print_students_list
		print_footer
	else
		puts "You don't have any student names"
	end
end

def print_header
puts "The students of my cohort at Makers Academy"
puts "-------------------------------------------"	
end

def print_students_list
	@students.sort_by{ |x| x[:cohort]}.each.with_index(1) do |student, index|
		# optional filters
		# if student[:name][0].downcase == 'a'
		# if student[:name].length < 12
	puts "#{index}. #{student[:name].ljust(20)}, #{student[:cohort]} cohort, from #{student[:country]}"
	end	
end

def print_footer 
puts "Overall we have #{@students.length} great students"
end

def load_students # got stuck on trying to parse each line read in, until realised it was read as an array!
	CSV.foreach(get_filename) do |line| # doesn't validate that user input filename exists
		@name = line[0]
		cohort = line[1]
		country = line[2]
		add_students(@name, cohort, country)
	end
end

def save_students
	CSV.open(get_filename, "wb") do |csv|
		@students.each do |student|
  		csv << [student[:name], student[:cohort], student[:country]]
	end
end
end

def get_filename
	filename = "students.csv" # sets default filename can be overwritten by user
	puts "What filename would you like to use"
	puts "just hit enter to use default of students.csv"
	user_filename = STDIN.gets.chomp
	if !user_filename.empty? # if user has input something use that file name rather than the default
		filename = user_filename
	end
	filename
end

try_load_students
interactive_menu