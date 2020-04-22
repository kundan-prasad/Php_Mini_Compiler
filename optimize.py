import re
import sys

if len(sys.argv) != 2: 
    print("Correct usage: Enter filename\n")
    exit()

icg_file = sys.argv[1]

#icg_file = "Output/icg.txt"

istemp = lambda s : bool(re.match(r"^T[0-9]*$", s)) 		#temporary variable
isid = lambda s : bool(re.match(r"^[$T][0-9A-Za-z][A-Za-z0-9_]*$", s)) #id + temporary variable

binary_operators = {"+", "-", "*", "/", "*", "&", "|", "^", "==", ">=", "<=", "!=", ">", "<"}
logop={"==", ">=", "<=", "!=", ">", "<"}

def printicg(list_of_lines, message = "") :
	print(message.upper())
	for line in list_of_lines :
		print(line.strip())


def eval_wrap(line) :
	tokens = line.split()
	if len(tokens) != 5 :
		return line
	if tokens[1] != "=" or tokens[3] not in binary_operators:
		return line
	#tokens = tokens[2:]
	if tokens[2].isdigit() and tokens[4].isdigit() :
		result = eval(str(tokens[2] + tokens[3] + tokens[4]))
		return " ".join([tokens[0], tokens[1], str(result)])
	if tokens[3] not in logop:
		if tokens[2].isdigit() or tokens[4].isdigit() : #Replace the identifier with a number and evaluate
			op1 = "5" if isid(tokens[2]) else tokens[2]
			op2 = "5" if isid(tokens[4]) else tokens[4]
			op = tokens[3]
			try : 
				result = int(eval(op1+op+op2))
				if result == 0 : #multiplication with 0
					return " ".join([tokens[0],tokens[1], "0"])
				elif result == 5 : #add zero, subtract 0, multiply 1, divide 1
					if isid(tokens[2]) and tokens[4].isdigit() :
						return " ".join([tokens[0], tokens[1], tokens[2]])
					elif isid(tokens[4]) and tokens[2].isdigit():
						return " ".join([tokens[0], tokens[1], tokens[4]])
				elif result == -5 and tokens[2] == "0" : # 0 - id
					return " ".join([tokens[0], tokens[1], "-"+tokens[4]])
				return " ".join(tokens)

			except NameError :
				return line
			except ZeroDivisionError :
				print("Division By Zero is undefined")
				quit()
	return line


def fold_constants(list_of_lines) :
	new_list_of_lines = []
	for line in list_of_lines :
		new_list_of_lines.append(eval_wrap(line))
	return new_list_of_lines

def remove_dead_code(list_of_lines) :
	num_lines = len(list_of_lines)
	temps_on_lhs = set()
	for line in list_of_lines :
		tokens = line.split()
		if istemp(tokens[0]) :
			temps_on_lhs.add(tokens[0])

	useful_temps = set()
	for line in list_of_lines :
		tokens = line.split()
		if len(tokens) > 2 :
			if istemp(tokens[2]) :
				useful_temps.add(tokens[2])
		if len(tokens) > 3 :
			if istemp(tokens[4]) :	
				useful_temps.add(tokens[4])
		if len(tokens) >= 2 :
			if istemp(tokens[1]) :	
				useful_temps.add(tokens[1])

	temps_to_remove = temps_on_lhs - useful_temps
	new_list_of_lines = []
	for line in list_of_lines :
		tokens = line.split()
		if tokens[0] not in temps_to_remove :
			new_list_of_lines.append(line)
	if num_lines == len(new_list_of_lines) :
		return new_list_of_lines
	return remove_dead_code(new_list_of_lines)

def wrap_temps(list_of_lines, unique_temps = 100) :
	number_of_lines = len(list_of_lines)
	a=dict()
	new_list_of_lines=[]
	new_list_of_lines2=[]
	for i in range(number_of_lines) :
		tokens = list_of_lines[i].split()
		if len(tokens) == 3 and istemp(tokens[0]) and ('$' not in list_of_lines[i]) : #a temp has been assigned to something else
			a[tokens[0]]= tokens[2]
		else:
			new_list_of_lines.append(list_of_lines[i])
	# print(a)
	# print(new_list_of_lines)
	for line in new_list_of_lines:
		tokens = line.split()
		newline=""
		for t in tokens:
			if (t in a.keys()):
				t=a[t]
			newline+=" "+t
		new_list_of_lines2.append(newline)
			
	return(new_list_of_lines2)

if __name__ == "__main__" :

	if len(sys.argv) == 2 :
		icg_file = str(sys.argv[1])
	
	list_of_lines = []
	f = open(icg_file, "r")
	for line in f :
		list_of_lines.append(line)
	f.close()

	printicg(list_of_lines, "ICG")
	print("\n")

	wrap_temp=wrap_temps(list_of_lines)
	print("\n")
	printicg(wrap_temp, "Optimized ICG after eliminating extra temporaries")
	print("\n")
	print("Eliminated", len(list_of_lines)-len(wrap_temp), "lines of code")
	folded_constants = fold_constants(wrap_temp)
	printicg(folded_constants, "Optimized ICG after constant folding")
	print("\n")
	print("Eliminated", len(list_of_lines)-len(folded_constants), "lines of code")
	without_deadcode = remove_dead_code(folded_constants)
	printicg(without_deadcode, "Optimized ICG after removing dead code")

	print("\n")
	print("Eliminated", len(list_of_lines)-len(without_deadcode), "lines of code")
	print("\n")



