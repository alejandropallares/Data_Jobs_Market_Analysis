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


-- Business Question 3: Which country has the highest salary average for each rol? 


SELECT 
    salary_by_country.job_title_short,
    salary_by_country.job_country,
    salary_by_country.salary_year_avg_by_position AS top_avg_salary

FROM (
    SELECT 
        job_title_short,
        job_country,
        AVG(salary_year_avg) AS salary_year_avg_by_position

    FROM job_postings_fact

    WHERE 
        job_country IS NOT NULL
        AND salary_year_avg IS NOT NULL

    GROUP BY 
        job_title_short,
        job_country
) AS salary_by_country

INNER JOIN (
    SELECT 
        job_title_short,
        MAX(salary_year_avg_by_position) AS top_salary

    FROM (
        SELECT 
            job_title_short,
            job_country,
            AVG(salary_year_avg) AS salary_year_avg_by_position

        FROM job_postings_fact

        WHERE 
            job_country IS NOT NULL
            AND salary_year_avg IS NOT NULL

        GROUP BY 
            job_title_short,
            job_country
    ) AS salary_by_country

    GROUP BY 
        job_title_short
) AS top_salary_by_role

    ON salary_by_country.job_title_short = top_salary_by_role.job_title_short
    AND salary_by_country.salary_year_avg_by_position = top_salary_by_role.top_salary

ORDER BY 
    top_avg_salary DESC;



/*───────────────────────────┬───────────────────────────────────┬────────────────────┐
│      job_title_short      │            job_country            │   top_avg_salary   │
│          varchar          │              varchar              │       double       │
├───────────────────────────┼───────────────────────────────────┼────────────────────┤
│ Data Analyst              │ Belarus                           │           400000.0 │
│ Data Engineer             │ Panama                            │  383573.6842105263 │
│ Senior Data Scientist     │ South Africa                      │         328709.125 │
│ Data Scientist            │ Russia                            │           285000.0 │
│ Cloud Engineer            │ Russia                            │           280000.0 │
│ Machine Learning Engineer │ Northern Mariana Islands          │           275000.0 │
│ Machine Learning Engineer │ Cayman Islands                    │           275000.0 │
│ Software Engineer         │ Congo, Democratic Republic of the │           275000.0 │
│ Business Analyst          │ Curaçao                           │           264000.0 │
│ Business Analyst          │ Guyana                            │           264000.0 │
│ Senior Data Engineer      │ Czechia                           │ 239433.33333333334 │
│ Senior Data Analyst       │ Panama                            │           160000.0 │
└───────────────────────────┴───────────────────────────────────┴────────────────────┘*/


-- Busines Question 4 ¿Qué empresas ofrecen los salarios promedio más altos para cada rol?

SELECT 
    salary_by_company.job_title_short,
    salary_by_company.company_name,
    salary_by_company.avg_salary AS highest_average_salary

FROM (
    SELECT 
        jpf.job_title_short,
        cd.name AS company_name,
        AVG(jpf.salary_year_avg) AS avg_salary

    FROM job_postings_fact AS jpf

    INNER JOIN company_dim AS cd
        ON jpf.company_id = cd.company_id

    WHERE 
        jpf.salary_year_avg IS NOT NULL

    GROUP BY 
        jpf.job_title_short,
        cd.name
) AS salary_by_company

INNER JOIN (
    SELECT 
        job_title_short,
        MAX(avg_salary) AS highest_average_salary

    FROM (
        SELECT 
            jpf.job_title_short,
            cd.name AS company_name,
            AVG(jpf.salary_year_avg) AS avg_salary

        FROM job_postings_fact AS jpf

        INNER JOIN company_dim AS cd
            ON jpf.company_id = cd.company_id

        WHERE 
            jpf.salary_year_avg IS NOT NULL

        GROUP BY 
            jpf.job_title_short,
            cd.name
    ) AS salary_by_company

    GROUP BY 
        job_title_short
) AS top_avg_salary_by_role

    ON salary_by_company.job_title_short =
       top_avg_salary_by_role.job_title_short

    AND salary_by_company.avg_salary =
        top_avg_salary_by_role.highest_average_salary

ORDER BY 
    highest_average_salary DESC;