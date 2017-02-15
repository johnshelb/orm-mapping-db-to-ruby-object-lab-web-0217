require "pry"
class Student
  attr_accessor :id, :name, :grade

  def self.students_below_12th_grade
    sql=<<-SQL
      SELECT * FROM students
      WHERE grade<12
      SQL
      rows=DB[:conn].execute(sql)
      rows.map {|row| Student.new_from_db(row)}
  end

  def self.first_student_in_grade_10
    sql=<<-SQL
      SELECT *
      FROM students
      WHERE grade=10
      ORDER BY id
      LIMIT 1
      SQL
      rows=DB[:conn].execute(sql)
      rows.map {|row| Student.new_from_db(row)}.first
  end
######hard-coded grade=10 but still won't pass
   def self.all_students_in_grade_x(x)
     sql=<<-SQL
       SELECT *
       FROM students
       WHERE grade=?
       SQL
       DB[:conn].execute(sql, x).map {|row| Student.new_from_db(row)}
   end

  def self.count_all_students_in_grade_9
    sql=<<-SQL
      SELECT COUNT(*) FROM students
      WHERE grade=9
      SQL
      rows=DB[:conn].execute(sql)
      rows.map {|row| Student.new_from_db(row)}
  end

  def self.first_x_students_in_grade_10(arg)
    sql=<<-SQL
      SELECT *
      FROM students
      WHERE grade=10
      LIMIT ?
      SQL
      rows=DB[:conn].execute(sql, arg)
      rows.map {|row| Student.new_from_db(row)}
  end

  def self.new_from_db(row)
    new_student=Student.new
    new_student.id=row[0]
    new_student.name=row[1]
    new_student.grade=row[2]
    new_student
  end

  def self.all
    sql=<<-SQL
      SELECT * FROM students
      SQL
      rows=DB[:conn].execute(sql)
      rows.map {|row| Student.new_from_db(row)}
  end

  def self.find_by_name(name)
    sql=<<-SQL
      SELECT *
      FROM students
      WHERE name=?
      LIMIT 1
      SQL
      DB[:conn].execute(sql,name).map do |datarow|

      self.new_from_db(datarow)
    end.first
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
