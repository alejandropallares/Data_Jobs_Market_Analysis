/*
[ESP]
PREGUNTA:
¿Que profesiones del area de datos gana mas? 

[EN]
Question:
¿What are the roles in data who earn the most?

*/

SELECT 
    job_title_short,
    MEDIAN(salary_year_avg) as median_salary
FROM job_postings_fact
GROUP BY
    job_title_short
ORDER BY 
    median_salary DESC;


/*

Decidí utilizar la mediana para encontrar el salario medio de cada rol, ya que la mediana es menos
suseptible a valores atipicos.

Como se puede mostrar en la consulta los roles que mas dinero ganan tienen posiciones Senior sea de Ciencia de Datos o Ingenieria de Datos
exceptuando a los ingenieros de Software que entran dentro del top 3.

Los roles que menos dinero ganan son posiciones relacionadas al analisis de datos, incluso la posicion Senior de Analisis de Datos gana menos 
que un ingeniero de Nube.



┌───────────────────────────┬───────────────┐
│      job_title_short      │ median_salary │
│          varchar          │    double     │
├───────────────────────────┼───────────────┤
│ Senior Data Scientist     │      156500.0 │
│ Senior Data Engineer      │      147500.0 │
│ Software Engineer         │      144000.0 │
│ Machine Learning Engineer │      135000.0 │
│ Data Engineer             │      130000.0 │
│ Data Scientist            │      125320.0 │
│ Cloud Engineer            │      120000.0 │
│ Senior Data Analyst       │      110000.0 │
│ Business Analyst          │       91575.0 │
│ Data Analyst              │       90000.0 │
└───────────────────────────┴───────────────┘
*/
-- Business Question 2: How does remote work affect average salaries across data roles?
SELECT
    job_title_short,
    remote_salary,
    onsite_salary,
    remote_salary - onsite_salary AS salary_difference
FROM (
    SELECT 
        job_title_short,
        ROUND(AVG( 
            CASE 
                WHEN job_work_from_home = True 
                THEN salary_year_avg
            END 
        )) AS remote_salary,

        ROUND(AVG(
            CASE 
                WHEN job_work_from_home = False
                THEN salary_year_avg
            END
        )) AS onsite_salary

    FROM job_postings_fact

    GROUP BY job_title_short
) 
ORDER BY salary_difference;
