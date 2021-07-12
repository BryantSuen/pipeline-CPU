with open('machine_code', 'r') as instruction:
	a = instruction.readlines()
	with open('machine_code_out', 'w') as mem:
		cnt = 0
		for line in a:
			mem.write('8\'d%d: instruction <= 32\'h%s;\n' % (cnt, line[:-1]))
			cnt = cnt + 1