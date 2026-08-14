{{ config(
    unique_key=['id_tempo'],
    indexes=[
        {'columns': ['id_tempo']}
    ]
) }}

with datas as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2015-01-01' as date)",
        end_date="cast('2030-12-31' as date)"
    ) }}
)

select
    date_day as data,
    cast(to_char(date_day, 'YYYYMMDD') as int)      as id_tempo,
    extract(year from date_day)                     as ano,
    extract(month from date_day)                    as mes,
    extract(day from date_day)                      as dia,
    extract(quarter from date_day)                  as trimestre,
    extract(dow from date_day)                      as dia_semana_num,
    to_char(date_day, 'Day')                        as dia_semana_nome,
    to_char(date_day, 'Month')                      as mes_nome,
    case 
        when extract(dow from date_day) in (0, 6) then true 
        else false 
    end                                              as fim_de_semana,
    date_trunc('week', date_day)::date               as inicio_semana,
    date_trunc('month', date_day)::date              as inicio_mes,
    (date_trunc('month', date_day) + interval '1 month' - interval '1 day')::date as fim_mes
from datas
