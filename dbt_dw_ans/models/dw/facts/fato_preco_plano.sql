WITH mensalidade_por_faixa_etaria AS (
    SELECT 
        mp.id_plano,
        mp.cd_operadora,
        mp.dt_ntrp,
        mp.faixa_etaria,
        mp.vl_comercial_mensalidade,
        mp.vl_desp_assistencial,
        mp.vcm_minimo,
        mp.vcm_maximo
    FROM ref({{ 'tr_mensalidade_por_faixa_etaria' }}) mp
    WHERE cd_nota = (
        SELECT MAX(cd_nota)
        FROM ref({{ 'tr_mensalidade_por_faixa_etaria'}}) mp2
        WHERE mp2.id_plano = mp.id_plano
        AND mp2.dt_ntrp = mp.dt_ntrp
        AND mp2.faixa_etaria = mp.faixa_etaria
    )
)

SELECT
    p.id_plano,
    o.id_operadora,
    fe.ds_faixa_etaria,
    t.id_tempo,
    men.vl_comercial_mensalidade,
    men.vl_desp_assistencial,
    men.vcm_minimo,
    men.vcm_maximo
FROM mensalidade_por_faixa_etaria men
JOIN ref({{ 'dim_plano' }}) p ON p.id_plano = men.id_plano
JOIN ref({{ 'dim_operadoras' }}) o ON o.id_operadora = men.id_operadora
JOIN ref({{ 'dim_faixa_etaria' }}) fe ON fe.ds_faixa_etaria = men.faixa_etaria
JOIN ref({{ 'dim_tempo' }}) t ON t.id_tempo = men.dt_ntrp
