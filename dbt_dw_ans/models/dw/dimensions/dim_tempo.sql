SELECT
    CAST(TO_CHAR(date_day, 'YYYYMMDD') AS INT)   AS id_tempo,
    date_day                                      AS data,
    EXTRACT(YEAR    FROM date_day)::INT           AS ano,
    EXTRACT(QUARTER FROM date_day)::INT           AS trimestre,
    EXTRACT(MONTH   FROM date_day)::INT           AS nr_mes,
    CASE EXTRACT(MONTH FROM date_day) ... END     AS nm_mes,
    LEFT(CASE EXTRACT(MONTH FROM date_day) ... END, 3) AS nm_mes_abrev,
    EXTRACT(YEAR FROM date_day)::INT * 100 + EXTRACT(MONTH FROM date_day)::INT AS ano_mes,   
    EXTRACT(DAY     FROM date_day)::INT           AS dia,
    CASE WHEN EXTRACT(MONTH FROM date_day) <= 6 THEN 1 ELSE 2 END AS semestre,
    (date_day = (DATE_TRUNC('month', date_day) + INTERVAL '1 month' - INTERVAL '1 day')) AS fl_ultimo_dia_mes
FROM dates