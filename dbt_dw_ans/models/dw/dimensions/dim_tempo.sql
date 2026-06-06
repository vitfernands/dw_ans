{{ config(materialized='table') }}

WITH dates AS (
    {{ dbt_utils.date_spine(
        datepart   = "day",
        start_date = "cast('2020-01-01' as date)",
        end_date   = "cast('2030-12-31' as date)"
    ) }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['date_day']) }} AS id_tempo,
    date_day                                             AS data,
    EXTRACT(YEAR    FROM date_day)::INT                  AS ano,
    EXTRACT(MONTH   FROM date_day)::INT                  AS nr_mes,
    EXTRACT(QUARTER FROM date_day)::INT                  AS trimestre,
    TO_CHAR(date_day, 'TMMonth')                         AS nm_mes
FROM dates