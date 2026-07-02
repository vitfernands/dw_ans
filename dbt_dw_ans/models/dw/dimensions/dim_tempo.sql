WITH datas_geradas AS (
    -- Gera uma sequência de datas de 2024 até o fim de 2026
    SELECT 
        CAST(data AS DATE) AS data_dia
    FROM 
        GENERATE_SERIES('2024-01-01'::DATE, '2026-12-31'::DATE, '1 day'::INTERVAL) AS data
)

SELECT
    -- A sua Chave Primária (pode ser a própria data ou um ID inteiro AAAAMMDD)
    TO_CHAR(data_dia, 'YYYYMMDD')::INT AS id_tempo,
    data_dia AS data_completa,
    
    -- Atributos de Ano
    EXTRACT(YEAR FROM data_dia) AS ano,
    
    -- Atributos de Mês
    EXTRACT(MONTH FROM data_dia) AS mes,
    TO_CHAR(data_dia, 'TMMonth') AS nome_mes, -- Ex: Janeiro, Fevereiro
    TO_CHAR(data_dia, 'Mon') AS nome_mes_abrev, -- Ex: Jan, Fev
    
    -- Atributos de Trimestre / Semestre
    EXTRACT(QUARTER FROM data_dia) AS trimestre,
    CASE WHEN EXTRACT(MONTH FROM data_dia) <= 6 THEN 1 ELSE 2 END AS semestre,
    
    -- Atributos de Semana / Dia
    EXTRACT(DAY FROM data_dia) AS dia,
    EXTRACT(DOW FROM data_dia) AS dia_da_semana, -- 0 (Domingo) a 6 (Sábado)
    TO_CHAR(data_dia, 'TMDay') AS nome_dia_semana, -- Ex: Segunda-Feira
    
    -- Flags Úteis para Análise Econômica
    CASE WHEN EXTRACT(DOW FROM data_dia) IN (0, 6) THEN TRUE ELSE FALSE END AS eh_final_semana

FROM datas_geradas