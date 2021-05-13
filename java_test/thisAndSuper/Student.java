package java_test.thisAndSuper;

import java.util.function.*;

public interface Student{
    String getInfo();
    void info(Consumer<String> consumer);
    default void info(){
        info(null);
    }

    
}