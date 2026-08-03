{{ config(
    indexes=[
        {'columns': 'ds_faixa_etaria'}
    ]
) }}

SELECT * FROM ref({{ 'tr_mapeamento_faixa_etaria' }}) 