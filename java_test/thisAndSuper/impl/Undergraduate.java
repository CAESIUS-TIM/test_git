package java_test.thisAndSuper.impl;

import java.util.function.Consumer;

public class Undergraduate extends StudentImpl {
    private String college;

    public Undergraduate(int id, String name, String grade, String classname, String college) {
        super(id, name, grade, classname);
        this.college = college;
    }

    @Override
    public String getInfo() {
        var str = super.getInfo();
        return str.substring(0, str.length() - 2) + //
                ", " + "college=" + college + //
                "}";
    }

    @Override
    public void info(Consumer<String> consumer) {
        super.info(consumer);
        System.out.println("use console to info");
    }

    public static void main(String[] args) {
        new Undergraduate(19001727, "Tim", "U2", "IE192", "IT").info();
    }
}
