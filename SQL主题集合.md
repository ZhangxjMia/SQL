### nth Highest Salary

<img src="/Users/xiaojiazhang/Library/Application Support/typora-user-images/Screen Shot 2021-02-09 at 4.50.32 PM.png" alt="Screen Shot 2021-02-09 at 4.50.32 PM" style="zoom: 50%;" />

* 方法一：窗口函数 DENSE_RANK()

> 这个方法用来写第n高也是可以的，通用型
>
> AS tb表命名一定要有！
>
> 窗口函数的命名不能为rank（reserve word），若一定要命名，为"Rank"

```sql
SELECT MAX(salary) AS SecondHighestSalary
FROM
(SELECT salary, DENSE_RANK() OVER(ORDER BY salary DESC) AS ranking
FROM employee) AS tb
WHERE ranking = 2;
```

* 方法二：不是最大数的最大数

```sql
SELECT MAX(salary) AS SecondHighestSalary
FROM employee
WHERE salary <> (SELECT MAX(salary) FROM employee);
```

* 方法三：IFNULL(), LIMIT & OFFSET

> LIMIT 1 OFFSET 4：忽略前四行，从第五行显示1个，可运用在查找第五高的工资

```sql
SELECT IFNULL(
(SELECT DISTINCT salary
 FROM employee
 ORDER BY salary DESC
 LIMIT 1 OFFSET 1),
 NULL
) AS SecondHighestSalary;
```



### “员工与经理”集合

* 查找又是员工又是经理的人

> INNER JOIN

```sql
SELECT e.first_name
FROM worker e
INNER JOIN worker m
WHERE e.id = m.id;
```

* 只找经理

> SELF-JOIN

```sql
SELECT e.first_name, m.first_name AS manager
FROM worker e, worker m
WHERE e.emp_id = m.report_id;
```

* 员工工资比经理工资高

Dept_emp:

| emp_no | dept_no | from_date | to_date |
| ------ | ------- | --------- | ------- |
|        |         |           |         |

Dept_manager:

| dept_no | emp_no | from_date | to_date |
| ------- | ------ | --------- | ------- |
|         |        |           |         |

Salaries:

| emp_no | salary | from_date | to_date |
| ------ | ------ | --------- | ------- |
|        |        |           |         |

> salary表要self join

```sql
SELECT de.emp_no, dm.emp_no AS manager_no, s1.salary AS emp_salary, s2.salary AS manager_salary
FROM dept_emp de, dept_manager dm, salaries s1, salaries s2
WHERE de.dept_no = dm.dept_no
AND de.emp_no = s1.emp_no
AND dm.emp_no = s2.emp_no
AND s1.salary > s2.salary;
```

* 有相同工资的员工

> SELF JOIN

```sql
SELECT DISTINCT w.first_name, w.salary
FROM worker w, worker w1
WHERE w.salary = w1.salary
AND w.worker_id <> w1.worker_id
```

* 所有员工工资涨幅

```sql
SELECT a.emp_no, (b.salary - a.salary) AS growth
FROM(
	SELECT s.emp_no, s.salary
  FROM employee e, salaries s
  WHERE e.emp_no = s.emp_no
  AND e.hire_date = s.from_date
) AS a,
(
	SELECT emp_no, salary
  FROM salaries
  WHERE to_date = '9999-01-01'
) AS b
WHERE a.emp_no = b.emp_no
ORDER BY growth;
```

* 员工号为10001的薪资涨幅

```sql
SELECT (
	SELECT salary
	FROM salaries
  WHERE emp_no = 10001
  ORDER BY to_date DESC
  LIMIT 1
) -
SELECT (
	SELECT salary
  FROM salaries
  WHERE emp_no = 10001
  ORDER BY to_date ASC
  LIMIT 1
) AS growth;
```

* 查找入职员工时间排名倒数第三的员工所有信息

```sql
SELECT * FROM employee
WHERE hire_date = 
(SELECT DISTINCT hire_date
 FROM employee
 ORDER BY hire_date DESC
 LIMIT 1 OFFSET 2);
```



### EXISTS集合

* 显示顾客至少有一次大于11的消费

```sql
SELECT first_name
FROM customer c
WHERE EXISTS
(SELECT * FROM payment p
 WHERE c.customer_id = p.customer_id
 AND amount > 11)
```

* Fetch all employee records from worker_detail table who have a salary record in worker_salary table

```sql
SELECT first_name
FROM worker_detail d
WHERE EXISTS
(SELECT * FROM worker_salary s
 WHERE d.worker_id = s.worker_id)
```

* 使用含有关键字exists查找未分配具体部门的员工的所有信息

Employee:

| emp_no | birth_date | first_name | last_name | gender | hire_date |
| ------ | ---------- | ---------- | --------- | ------ | --------- |
|        |            |            |           |        |           |

Dept_emp:

| emp_no | dept_no | from_date | to_date |
| ------ | ------- | --------- | ------- |
|        |         |           |         |

```sql
SELECT * FROM employee e
WHERE NOT EXISTS
(SELECT * FROM dept_emp d
 WHERE e.emp_no = d.emp_no);
```



### ALL集合

> 当条件是最大值可用all

* 找出哪些order id的最大数量是超过平均数量的

```sql
SELECT order_id
FROM order_detail
GROUP BY order_id
HAVING MAX(quantity) > ALL (
	SELECT AVG(quantity)
  FROM order_detail
  GROUP BY order_id
);
```

* 查询总销售额最高的销售者，如果有并列的，就都展示出来

```sql
SELECT seller_id
FROM sales
GROUP BY seller_id
HAVING SUM(price) >= ALL (
	SELECT SUM(price)
  FROM sales
  GROUP BY seller_id
);
```



### JOIN集合

![SQL JOINS](/Users/xiaojiazhang/Desktop/SQL JOINS.png)

> Staff table & Department table

| id   | name  |
| ---- | ----- |
| 1    | Nancy |
| 2    | Tracy |
| 3    | Cathy |

| id   | team       |
| ---- | ---------- |
| 1    | Accounting |
| 3    | Consulting |
| 4    | Banking    |

* LEFT JOIN

> SELECT * FROM staff LEFT JOIN department ON staff.id = department.id

| id   | name  | id   | team       |
| ---- | ----- | ---- | ---------- |
| 1    | Nancy | 1    | Accounting |
| 2    | Tracy | NULL | NULL       |
| 3    | Cathy | 3    | Consulting |

* RIGHT JOIN

> SELECT * FROM staff RIGHT JOIN department ON staff.id = department.id

| id   | Team       | id   | Name  |
| ---- | ---------- | ---- | ----- |
| 1    | Accounting | 1    | Nancy |
| 3    | Consulting | 3    | Cathy |
| 4    | Banking    | NULL | NULL  |

* FULL JOIN

> SELECT * FROM staff FULL JOIN department ON staff.id = department.id

| id   | name  | id   | team       |
| ---- | ----- | ---- | ---------- |
| 1    | Nancy | 1    | Accounting |
| 2    | Tracy | NULL | NULL       |
| 3    | Cathy | 3    | Consulting |
| NULL | NULL  | 4    | Banking    |

* INNER JOIN

> SELECT * FROM staff INNER JOIN department ON staff.id = department.id
>
> SELECT * FROM staff  JOIN department ON staff.id = department.id
>
> SELECT * FROM staff, department WHERE staff.id = department.id

| id   | name  | id   | team       |
| ---- | ----- | ---- | ---------- |
| 1    | Nancy | 1    | Accounting |
| 3    | Cathy | 3    | Banking    |

* CROSS JOIN

> SELECT * FROM staff CROSS JOIN department

| id   | name  | id   | team       |
| ---- | ----- | ---- | ---------- |
| 1    | Nancy | 1    | Accounting |
| 2    | Tracy | 1    | Accounting |
| 3    | Cathy | 1    | Accounting |
| 1    | Nancy | 3    | Consulting |
| 2    | Tracy | 3    | Consulting |
| 3    | Cathy | 3    | Consulting |
| 1    | Nancy | 4    | Banking    |
| 2    | Tracy | 4    | Banking    |
| 3    | Cathy | 4    | Banking    |

> SELECT * FROM staff CROSS JOIN department WHERE staff.id = department.id

| id   | name  | id   | team       |
| ---- | ----- | ---- | ---------- |
| 1    | Nancy | 1    | Accounting |
| 3    | Cathy | 3    | Banking    |

