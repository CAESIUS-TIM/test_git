package java_test.thisAndSuper;

import java.util.function.*;

import java_test.thisAndSuper.impl.StudentImpl;
import java_test.thisAndSuper.impl.Undergraduate;

public interface Student{
    String getInfo();
    void info(Consumer<String> consumer);
    default void info(){
        info(null);
    }

    
}