create database student_management_system;
use student_management_system;
select * from students;
select * from classes;
select * from teachers;
select * from subjects;
select * from grades;
select * from attendance;

-- count no of students and teachers
select count(*) as total_students from students;
select count(*) as total_teachers from teachers;

-- list all classes and their respective teacher
select classes.class_name,concat(teachers.first_name,' ',teachers.last_name)as teacher_name
from classes
join teachers on classes.teacher_id=teachers.teacher_id;

-- get the gardes of a sepcific student (e.g) student_id=1
select subjects.subject_name,grades.grade,grades.exam_date
from grades
join subjects on grades.subject_id=subjects.subject_id
where grades.student_id=1;

-- retrieve attendance records for a specific student(e.g student_id=1)
select attendance_date,status
from attendance
where student_id=10;

-- list all students along with their class name
select students.student_id,concat(students.first_name,' ',students.last_name) as student_name,classes.class_name
from students
join classes on students.class_id=classes.class_id;

-- count attendance (e.g present,absent)
select status,count(*) as count
from attendance
group by status;

-- list students with their last attendance date
select students.student_id,
concat(students.first_name,' ',students.last_name)as student_name,
max(attendance.attendance_date) as last_attendance_date
from students
left join attendance on students.student_id=attendance.student_id
group by students.student_id,students.first_name,students.last_name
limit 0,5000;

-- student who failed i.e grade greater than c
select distinct concat(students.first_name,' ',students.last_name) as student_name,
classes.class_name,
grades.grade
from students
join grades on students.student_id=grades.student_id
join subjects on grades.subject_id=subjects.subject_id
join classes on subjects.class_id=classes.class_id
where grades.grade>'c'
order by classes.class_name,student_name;

-- student who scored grade a in each classes
select s.student_id,s.first_name,s.last_name,c.class_name
from students s
join grades g on s.student_id=g.student_id
join classes c on s.class_id=c.class_id
where g.grade='A';

-- average number of teaching subjects per teacher 
select 
t.teacher_id,
t.first_name,
t.last_name,
count(distinct s.subject_id)as teaching_subject_count
from teachers t
left join subjects s on t.subject_id=s.subject_id
group by t.teacher_id,t.first_name,t.last_name;

-- count of students in each class
select c.class_name,count(s.student_id) as student_count
from classes c 
join students s on c.class_id =s.class_id
group by c.class_name;

-- most common garde in each subject
select sub.subject_name,g.grade,count(g.grade) as grade_count
from grades g
join subjects sub on g.subject_id=sub.subject_id
group by sub.subject_name,g.grade
order by sub.subject_name,grade_count desc;

-- changing gardes to marks
set sql_safe_updates=0;
update grades
set grade=case
when grade='a'then 99
when grade='b'then 89
when grade='c'then 79
when grade='d'then 69
when grade='e'then 49
when grade='f'then 39
end
where grade in('a','b','c','d','e','f');
select * from grades;

-- maximum and minimum marks per subject
select subject_id,max(grade) as max_grade,min(grade) as min_grade
from grades
group by subject_id;

-- average marks per class
select c.class_name,avg(g.grade) as avg_grade
from grades g
join students s on g.student_id=s.student_id
join classes c on s.class_id=c.class_id
group by c.class_name;

-- monthly attendance count
select date_format(attendance_date,'%Y-%m') as month,count(*) as attendance_count
from attendance
group by month
order by month;





