class Person{
  String name;
  int age;


  Person(this.name, this.age);

  say(String name) {
    print("are you ok $name,nide age $age");
  }
}


class Student extends Person{

  String course;

  Student(String name, int age,this.course) : super(name, age);



}