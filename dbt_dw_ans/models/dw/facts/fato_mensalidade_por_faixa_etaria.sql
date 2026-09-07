SELECT
    o.cd_operadora,
    p.id_plano,
    fe.cd_faixa_etaria,
    mfe.id_abrg,
    mfe.cd_nota,
    mfe.vl_comercial_mensalidade,
    mfe.vl_desp_assistencial,
    mfe.vcm_minimo,
    mfe.vcm_maximo,
    mfe.dt_ntrp
FROM {{ ref('tr_mensalidade_por_faixa_etaria') }} mfe
JOIN {{ ref('dim_operadoras') }} o ON o.cd_operadora = mfe.cd_operadora
JOIN {{ ref('dim_plano') }} p ON p.id_plano = mfe.id_plano
JOIN {{ ref('dim_faixa_etaria') }} fe ON fe.ds_faixa_etaria = mfe.faixa_etaria