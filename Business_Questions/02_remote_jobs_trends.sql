/*
Business Question
How has the demand for remote data jobs changed over time?

*/

SELECT 
    MAX(job_posted_date) AS newest_date,
    MIN(job_posted_date) AS older_date
FROM job_postings_fact AS jpf;

/*

   newest_date     │     older_date      │
│      timestamp      │      timestamp      │
├─────────────────────┼─────────────────────┤
│ 2025-06-30 07:16:42 │ 2023-01-01 00:00:04

*/

-- ¿Cuántas ofertas remotas existen por año?

SELECT 
    job_title_short,
    EXTRACT(year FROM job_posted_date) AS year_analized,
    COUNT(jpf.job_posted_date) AS remote_jobs
FROM job_postings_fact AS jpf
WHERE
     job_work_from_home = True 
     AND year_analized < 2025
GROUP BY 
    EXTRACT(year FROM job_posted_date), job_title_short
ORDER BY year_analized, remote_jobs DESC;


/*
    job_title_short         │ year_analized │ remote_jobs │
│          varchar          │     int64     │    int64    │
├───────────────────────────┼───────────────┼─────────────┤
│ Data Engineer             │          2023 │       21284 │
│ Data Scientist            │          2023 │       14554 │
│ Data Analyst              │          2023 │       13344 │
│ Senior Data Engineer      │          2023 │        6561 │
│ Senior Data Scientist     │          2023 │        3811 │
│ Software Engineer         │          2023 │        2927 │
│ Business Analyst          │          2023 │        2784 │
│ Senior Data Analyst       │          2023 │        2370 │
│ Machine Learning Engineer │          2023 │        1485 │
│ Cloud Engineer            │          2023 │         573 │
│ Data Engineer             │          2024 │       19495 │
│ Data Scientist            │          2024 │       12885 │
│ Data Analyst              │          2024 │       11219 │
│ Senior Data Engineer      │          2024 │        5597 │
│ Software Engineer         │          2024 │        3164 │
│ Senior Data Scientist     │          2024 │        3089 │
│ Business Analyst          │          2024 │        2708 │
│ Machine Learning Engineer │          2024 │        2287 │
│ Senior Data Analyst       │          2024 │        1791 │
│ Cloud Engineer            │          2024 │         588 │
└───────────────────────────┴───────────────┴─────────────┘

Key Findings: Al revisar las fechas maximas y minimas de los empleos remotos posteados, solo hay dos años completos 2023 y 2024 es por ellos que el analisis 
se enfocara solo en estos años.



*/



-- ¿Qué porcentaje representan del total?


-- ¿Qué roles ofrecen más trabajo remoto?
SELECT 
    job_title_short,
    COUNT(jpf.job_posted_date) AS number_of_online_positions
FROM job_postings_fact AS jpf
WHERE
    job_posted_date >= '2024-01-01' AND job_posted_date <= '2024-12-31'
GROUP BY 
    job_title_short
ORDER BY COUNT(jpf.job_posted_date) DESC;

-- ¿Cuáles crecieron más?


SELECT 
    job_title_short,
    COUNT(jpf.job_posted_date) AS number_of_online_positions
FROM job_postings_fact AS jpf
WHERE
    job_posted_date >= '2025-01-01' AND job_posted_date <= '2025-06-30'
GROUP BY 
    job_title_short
ORDER BY COUNT(jpf.job_posted_date) DESC;


-- Conclusiones


/*

Business Question: la pregunta que quieres responder.
SQL Solution: una o varias consultas bien organizadas, reutilizando el código cuando sea posible (por ejemplo, agrupando por año en una sola consulta en lugar de repetir tres).
Key Findings: los hallazgos principales, explicando cualquier limitación (como que 2025 solo tiene datos hasta junio).
Technical Concepts Used: las técnicas SQL utilizadas (CTE, funciones de fecha, agregaciones, window functions, etc.).
*/