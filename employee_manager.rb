class Employee

  attr_accessor :name, :title, :salary, :boss

  def initialize(name, title, salary, boss)
    @name = name
    @title = title
    @salary = salary
    @boss = boss
  end

  def bonus(multiplier)
    salary * multiplier
  end

end

class Manager < Employee

  attr_accessor :employees

  def initialize(name, title, salary, boss)
    super(name, title, salary, boss)
    @employees = []
  end

  def add_employee(employee)
    @employees << employee
  end

  def bonus(multiplier)
    #return self.salary unless self.is_a?(Manager)

    subordinates_salaries = 0
    low_level_bonus = 0

    employees.each do |employee|
      # subordinates_salaries += employee.bonus(multiplier)
      if employee.is_a?(Manager)
        subordinates_salaries += employee.salary
        subordinates_salaries += employee.bonus(multiplier)
      else
        low_level_bonus += employee.bonus(multiplier)
      end
      
    end
    subordinates_salaries * multiplier + low_level_bonus
  end
end

ned = Manager.new("Ned", "Founder", 1000000, nil)
darren = Manager.new("Darren", "TA Manager", 78000, ned)
ned.add_employee(darren)

shawna = Employee.new("Shawna", "TA", 12000, darren)
david = Employee.new("David", "TA", 10000, darren)
[shawna, david].each { |employee| darren.add_employee(employee) }
# p ned.employees.first.employees.length


#darren.employees.each { |employee| p employee.name }
p ned.bonus(5)
p darren.bonus(4)
p david.bonus(3)
# p david.bonus(5)
# p darren.bonus(4)
# p david.bonus(3)
