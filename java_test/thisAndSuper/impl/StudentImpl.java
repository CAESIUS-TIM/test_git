package java_test.thisAndSuper.impl;

import java.util.function.Consumer;

import java_test.thisAndSuper.Student;

public class StudentImpl implements Student {
    private int id;
    private String name;
    private String grade;
    private String classname;

    public static final Consumer<String> consumer = (x) -> System.out.println(x);

    public StudentImpl(int id, String name, String grade, String classname) {
        this.id = id;
        this.name = name;
        this.grade = grade;
        this.classname = classname;
    }

    @Override
    public String getInfo() {
        return "StudentImpl{" + //
                "id=" + id + //
                ", " + "name=" + name + //
                ", " + "grade=" + grade + //
                ", " + "classname=" + classname + //
                "}";
    }

    @Override
    public void info(Consumer<String> consumer) {
        if (consumer == null) {
            consumer = StudentImpl.consumer;
        }
        consumer.accept(this.getInfo());
        consumer.accept(getInfo());
    }

    public static void main(String[] args) {
        new StudentImpl(19001727, "Tim", "U2", "IE192").info();
    }
}