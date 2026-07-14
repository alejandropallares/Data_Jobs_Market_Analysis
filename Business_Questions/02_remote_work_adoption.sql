

SELECT 
    MAX(job_posted_date) AS newest_date,
    MIN(job_posted_date) AS older_date
FROM job_postings_fact AS jpf;

/*
Al revisar las fechas maximas y minimas de los empleos remotos posteados, solo hay dos años completos 2023 y 2024 es por ello que el analisis 
se enfocara solo en estos años.


   newest_date        │     older_date      │
│      timestamp      │      timestamp      │
├─────────────────────┼─────────────────────┤
│ 2025-06-30 07:16:42 │ 2023-01-01 00:00:04

*/

/*
Business Question 1

 ¿Cuántas ofertas remotas existen por año (2023-2024)?

*/

SELECT 
    EXTRACT(year FROM job_posted_date) AS year_analized,
    COUNT(jpf.job_work_from_home) AS total_remote_jobs
FROM job_postings_fact AS jpf
WHERE 
    job_work_from_home = True AND job_posted_date < '2025-01-01'
GROUP BY 
    EXTRACT(year FROM job_posted_date);

/* 

Key Findings: 

*/

/*
Bussines Question 2:
    ¿Qué roles de datos ofrecen el mayor número de empleos remotos?

*/
SELECT 
    job_title_short,
    COUNT(jpf.*) AS total_remote_jobs 
FROM job_postings_fact AS jpf
WHERE 
    job_work_from_home = True AND job_posted_date < '2025-01-01'
GROUP BY 
    job_title_short
ORDER BY 
    total_remote_jobs DESC;

/*
    Key Findings: 
*/

/*
Business Question 3:
    ¿Qué porcentaje de las vacantes de cada rol corresponde a trabajo remoto?

*/

SELECT 
    job_title_short,
    COUNT(
        CASE 
            WHEN job_work_from_home = True THEN 1
        END
    ) AS total_remote_jobs, 
    COUNT(jpf.*) AS total_posting_jobs,
    ROUND(COUNT(
        CASE 
            WHEN job_work_from_home = True THEN 1
        END
    ) / COUNT(jpf.*), 3) * 100 AS porcentage_of_remote_job
FROM job_postings_fact AS jpf
WHERE 
    job_posted_date < '2025-01-01'
GROUP BY 
    job_title_short
ORDER BY 
    porcentage_of_remote_job DESC;

    
/*
    Key Findings: 

*/


/*
Business Question 4

¿Cómo cambió la adopción del trabajo remoto entre 2023 y 2024 para cada rol?

*/

SELECT
    job_title_short,
    EXTRACT(YEAR FROM job_posted_date) AS year_analyzed,

    ROUND(
        COUNT(
            CASE
                WHEN job_work_from_home = TRUE THEN 1
            END
        ) * 100.0
        /
        COUNT(*),
        3
    ) AS percentage_remote_jobs

FROM job_postings_fact

WHERE job_posted_date < '2025-01-01'

GROUP BY
    job_title_short,
    EXTRACT(YEAR FROM job_posted_date)

ORDER BY
    job_title_short,
    year_analyzed;

   
-- Conclusiones


/*

Business Question: la pregunta que quieres responder.
SQL Solution: una o varias consultas bien organizadas, reutilizando el código cuando sea posible (por ejemplo, agrupando por año en una sola consulta en lugar de repetir tres).
Key Findings: los hallazgos principales, explicando cualquier limitación (como que 2025 solo tiene datos hasta junio).
Technical Concepts Used: las técnicas SQL utilizadas (CTE, funciones de fecha, agregaciones, window functions, etc.).
*/