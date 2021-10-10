# This used to be the .ipynb equivalent (check previous versions)


import random

LEVELS = [
[1, 1, 1, 2, 0], # Level 1: 4+3      #  2 2
[1, 1, 2, 3, 0], # Level 2: 8+7+2    #  3 3 3
[1, 2, 1, 1, 1], # Level 3: 4+13     #  5 5 5 5 5 <--- starting mean
[1, 1, 3, 4, 0], # Level 4: 6+3+8+7  #  3 3 3
[1, 2, 2, 2, 1], # Level 5: 7+4+46   #  2 2
[2, 2, 1, 0, 2], # Level 6: 23+78
[1, 2, 3, 3, 1], # Level 7: 3+8+6+57
[1, 2, 2, 1, 2], # Level 8: 7+23+78
[2, 3, 1, 1, 1], # Level 9: 23+103
[2, 2, 3, 0, 4], # Level 10: 57+23+78+46
[2, 3, 2, 2, 1], # Level 11: 41+28+345
[2, 3, 3, 3, 1], # Level 12: 41+57+28+345
[3, 3, 2, 0, 3], # Level 13: 145+341+932
[3, 3, 3, 0, 4]  # Level 14: 666+145+341+932
]

def generate_number(num_dig):
    # Restrict final digit from being 0, 1, 2 or 5
    choices_f = [3, 4, 6, 7, 8, 9]
    choices_i = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    len_f = len(choices_f)-1
    len_i = len(choices_i)-1

    q = ''
    for j in range(num_dig-1):
        q += str(choices_i[random.randint(0, len_i)])
    q += str(choices_f[random.randint(0, len_f)])
    
    return q

def create_problem(args):
    min_dig = args[0] 
    max_dig = args[1]
    num_ops = args[2]
    num_min = args[3]
    num_max = args[4]
    ops = []
    for i in range(num_min):
        ops.append(generate_number(min_dig))

    for i in range(num_max):
        ops.append(generate_number(max_dig))

    if (num_max + num_min - 1) > num_ops:
        print('Num max: %d' % num_max)
        print('Num min: %d' % num_min)
        print('Num ops: %d' % num_ops)
        num_ops = num_max + num_min - 1
        
        print('Warning: num_ops smaller than num_max + num_min - 1; using sum - 1 as num_ops')

    # Populate remaining operators
    for i in range(num_ops - (num_max + num_min - 1)):
        ops.append(generate_number(random.randint(min_dig, max_dig)))

    # Generate label str and compute answer
    problem = ''
    answer = 0
    for op in ops:
        problem += op + '+'
        answer += int(op)
    problem = problem[:-1]
    
    return problem, answer

def generate_block(level_mean_, level_distribution_):
    if len(level_distribution_) % 2 == 0:
        print('ERROR, level distribution should be odd')
        level_distribution_ = level_distribution_[:-1]
    # Make sure we're never below minimum mean
    min_mean = int(((len(level_distribution_)-1)/2)+1)
    level_mean_ = max(level_mean_, min_mean)
    # Or max mean
    max_mean = len(LEVELS) - int(((len(level_distribution_)-1)/2))
    level_mean_ = min(level_mean_, max_mean)
    
    print('Mean level: %d' % level_mean_)
    level_range = range(int(level_mean_-((len(level_distribution_)-1)/2)),
                        int(level_mean_+((len(level_distribution_)-1)/2))+1) 

    # Initiate questions and iterate through levels and generate questions
    questions_ = []; questions__ = []
    difficulty_ = []; difficulty__ = []
    for i in range(len(level_distribution_)):
        lvl = level_range[i]
        for _j in range(level_distribution_[i]):
            questions_.append(create_problem(LEVELS[lvl-1]))
            if lvl < level_mean_:
                difficulty_.append('e');
            else:
                difficulty_.append('h')

    # Final question always easy
    ix = [x for x in range(len(questions_))]
    #random.randomize()
    random.shuffle(ix)
    for i in ix:
        questions__.append(questions_[i])
        difficulty__.append(difficulty_[i])

    # Final question always easy
    questions__.append(create_problem(LEVELS[level_range[0]-1]))
    difficulty__.append('e')

    return questions__, difficulty__
    
level_mean = 20
level_distribution = [2, 3, 5, 3, 2]

questions, difficulties = generate_block(level_mean, level_distribution)
for i in range(len(questions)):
    print(str(questions[i]) + ', ' + difficulties[i])
    
