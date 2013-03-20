file = File.open("/home/lgorse/www/curiousbear/app/assets/english_wordforms.txt")
new_file = File.open("new.txt", "w")
file.each do |line|
	line_array = line.split
	new_file.puts line unless line_array[0] == line_array[2]
end
