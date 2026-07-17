# Java 学习计划

## 当前状态

- 计划版本：v1（华贵铂金）
- 当前评分：43 分
- 当前段位：华贵铂金
- 计划范围：只覆盖华贵铂金阶段
- 计划状态：进行中
- 学习目标：未设定
- 每周可投入时间：未设定
- 当前优先级：对象语义、泛型边界和集合/并发综合理解
- 来源评分档案：[`technical-levels.md`](../technical-levels.md)
- 学习经验记录：[`learning-experiences/java.md`](../learning-experiences/java.md)

## 核心学习范围

- `==` 与 `equals()`、对象引用和值语义
- `this`、参数遮蔽、封装和对象状态
- 继承、抽象类、接口与运行时多态
- 集合可变性：`Arrays.asList`、`ArrayList`、`Map`
- 异常处理与 `finally`
- 泛型通配符：`extends` 与 `super`
- `synchronized`、竞态条件和线程安全
- Stream 的 `filter`、`map` 与集合结果
- `Map.merge` 等集合计数模式

## 待加强

- 区分字符串引用比较和内容比较。
- 准确理解 `List<? extends T>` 不能安全写入、`List<? super T>` 可接收写入。
- 区分固定长度列表与完全不可变列表。
- 理解 `equals/hashCode` 契约、`volatile` 可见性、Lambda effectively final 和 Optional 空值语义。
- 加强 Java 值传递、`String`/`StringBuilder`、接口默认方法冲突、枚举和 `computeIfAbsent`。
- 将集合、泛型、异常和并发知识组合到代码阅读中。

## 验证练习

- 预测不同字符串创建方式下 `==` 和 `equals()` 的结果。
- 判断 `extends/super` 泛型代码是否可编译。
- 分析集合修改操作可能抛出的异常。
- 阅读包含 `Map.merge`、异常和线程同步的综合代码。

## 完成条件

- 对象语义：两道变式题和一次代码迁移均正确。
- 泛型与集合：两道边界题正确，并能解释可变性限制。
- 异常与并发：各通过一道结果预测题。
- 综合理解：完成一次包含集合、泛型或并发的综合代码分析。
