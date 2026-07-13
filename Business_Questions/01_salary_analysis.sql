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


/*
En relacion a mi pais, hice una consulta para ver como estan los salarios de datos en México, tambien a partir de la mediana y agregue una
columna mas para ver el conteo de los empleos con un salario anual registrado 

*/

SELECT 
    job_title_short,
    MEDIAN(salary_year_avg) AS median_salary_in_mexico,
    COUNT(jps.*) as job_counts
FROM 
    job_postings_fact AS jps
WHERE 
    job_country = 'Mexico'
GROUP BY
    job_title_short
ORDER BY MEDIAN(salary_year_avg) DESC;

/*

Resultado de la consulta: 

      job_title_short       │ median_salary_in_mexico │ job_counts │
│          varchar          │         double          │   int64    │
├───────────────────────────┼─────────────────────────┼────────────┤
│ Cloud Engineer            │                203500.0 │       1091 │
│ Senior Data Scientist     │                157500.0 │       1167 │
│ Software Engineer         │                155750.0 │       3179 │
│ Data Engineer             │                147500.0 │       8969 │
│ Senior Data Engineer      │                147500.0 │       1679 │
│ Senior Data Analyst       │               133135.75 │        711 │
│ Data Scientist            │                119725.0 │       5349 │
│ Machine Learning Engineer │                104414.5 │        858 │
│ Data Analyst              │                 98500.0 │       5868 │
│ Business Analyst          │                 80850.0 │       2654 │

A diferencia de los salarios generales de empleos de datos en México el rol mejor pagado es el Ingeniero de Nube
seguido de Cientifico de Datos Senior y al igual que en la consulta general los ingenieros de Software estan dentro del
top 3.

De igual forma los roles que tienen un menor salario son los relacionados a Analisis de Datos y de negocio. 

*/



