% Rule to check if employee works in Seattle
is_seattle_employee(Name) :- 
% searching for employees with matching seattle 
employee(_, Name, _, _, _, _, _, _, _, ‘Seattle’, _, _, _, _), 

% Rule to check if employee is Senior Manager in IT
is_senior_manager_in_IT(Name) :- 
employee(_, Name, ‘Senior Manager’, ‘IT’, _, _, _, _, _, _, _, _, _, _).


%Rule to check if emply is Director in Finance who works In Miami
is_director_of_finance_miami(Name) :- 
employee(_, Name, ‘Director’, ‘Finance’, _, _, _, _, _, ‘Miami’, _, _, _, _),

%Rule to check if employee is from US, in Manufacturing , Age > 40, Asian Male
is_40plus_asianmale_US_manufacturing(Name,Business_Unit, Gender, Ethnicity, Age)

%checks if employee meets all criterias below 
employee(_, Name, _, _, _, Business_Unit, ‘United States’, _, _, _, Gender, ‘Asian’, Age, _), 

Age > 40.  	 	% extra flexibility to access that int Age must be greater than 40
Gender == ‘Male’.       % gender must be equal to Male value to be selected for rule

Rule to greet employee
greet(EEID) :- 
	employee(EEID, Name, JobTitle, Department, Business_Unit, _, _, _, _, _, _, _, _, _),

% print custom greeting using details matching inputted EEID
format(‘Hi, ~w, ~w of ~w!’,[Name, JobTitle, Department]). % plugs in values to ~w

Rule to calc years until retirement (65 - age)
years_until_retirement(Name, Age, Years_till_retire) :- 

%checks if employee has a Name and Age, everything else dont matter
employee(_, Name, _, _, _, _, _, _, _, _, _, _, Age, _),
Years_till_retire is 65 - Age.

Rule to find R&D emply who are Black andaged 25-50
is_rd_black_middleAged(Name, Business_unit, Ethnicity, Age) :- 
employee(_, Name, _, ‘Research & Development’ , _, _, _, _, _, _, _, ‘Black’, Age, _),
Age >= 25, Age <= 50.

Rule to find Employee from IT or Fin in Phoenix, Miami, or Austin
is_ITorFin_PHXorMIAorAUS(Name, Department, City) :- 
	employee(_, Name, _, Department, _, _, _, _, _, City, _, _, _, _),
	(Department == ‘IT’; Department == ‘Finance’),      % matches if has either of the options 
	(City == Phoenix; City == Miami; City == ‘Austin’).




Rule for Female emplys in Senior role
is_female_senior_role(Name, JobTitle) :- 
employee(_, Name, JobTitle, _, _, _, _, _, _, _, ‘Female’, _, _, _),
atom_concat(‘Sr.’, _, JobTitle).             			% checks if job begins with Sr.
Rule for highly paid senior managers
is_highly_paid_senior_manager(Name, Salary) :- 
	employee(_, Name, ‘Senior Manager’, _, _, _, _, SalaryStr, _, _, _, _, _, _),
% converts salary to num
	atom_number(SalaryStr, Salary),
	Salary > 120000 % if true, then employee is highly paid manager

Rule to determine if Emplys Age is prime number

is_prime(N) :- 
	N > 2,
	N mod 2 =\= 0, 	% prime numbs are not divisible by 2 having 0 remainders
	not(divisible(N, 3)). 		

divisible(N, L) :- 
	N mod L =:= 0.  	% if N is divisible by L, then N is not prime
divisible(N, L) :- 
	L * L < N,  		% Increases L, ensuring skipping of evens 
	L2 is L + 2,  
	divisible(N, L2).

is_prime_age(Name, Age) :- 
	employee(_, Name, _, _, _, _, _, _, _, _, _, _, Age, _),
is_prime(Age). % uses helper pred to check if emply age is prime, following above rules

Rule to find average of salaries for job title and employees

calc_sum_of_salaries(Job_Title, Sum, Count) :-  
findall(Salary,
		(employee(_, _, Job_Title, _, _, _, _, SalaryStr, _, _, _, _, _, _),
		atom_number(SalaryStr, Salary)),
		Salaries),
		sum_list(Salaries, Sum),
		length(Salaries, Count).

average_salary(Job_Title, Average) :- 
	calc_sum_of_salaries(Job_Title, Sum, Count),
	Count > 0,
	Average is Sum / Count.

Rule to compute total overall salary of a employee
total_salary(Name, TotalSalary) :- 
employee(_, Name, _, _, _, _, _, SalaryStr, BonusPercent, _, _, _, _, _),
atom_number(SalaryStr, Salary),
TotalSalary is Salary + (Salary * BonusPercent / 100).
Rule calculating take home salary post tax

tax_bracket(Salary, Tax) :- 
	(Salary < 50000 -> Tax = 20;
	 Salary =< 100000 -> Tax = 25;
	 Salary =< 200000 -> Tax = 30;
	 Salary > 200000 -> Tax = 35).

takehome_salary(Name, Job_Title, TakeHomeSalary) :- 
	pretax_salary(Name, TotalSalary),
	tax_bracket(TotalSalary, TaxPercent), 
	TakeHomeSalary is TotalSalary - (TotalSalary * TaxPercent), 
	TakeHomeSalary is TotalSalary - (TotalSalary * TaxPercent / 100).


