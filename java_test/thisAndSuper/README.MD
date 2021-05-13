# 在super中调用被重写过的函数

## 部分程序与输出

### `public class StudentImpl implements Student`

```java
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
            consumer = this.consumer;
        }
        consumer.accept(this.getInfo());
        consumer.accept(getInfo());
    }
```

### `public class Undergraduate extends StudentImpl`

```java
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
```

### `main`

```java
    public static void main(String[] args) {
        new StudentImpl(19001727, "Tim", "U2", "IE192").info();
    }
```

### 输出 

```text
StudentImpl{id=19001727, name=Tim, grade=U2, classname=IE19, college=IT}
StudentImpl{id=19001727, name=Tim, grade=U2, classname=IE19, college=IT}
use console to info
```

## 结论

当通过super调用父类方法，如果该父类方法调用了被重写过的方法，无论调用时加了this与否，都使用的是重写的方法，而非父类的原方法。