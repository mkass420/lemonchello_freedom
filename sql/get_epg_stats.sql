--DO $$ 
--BEGIN
    --IF NOT EXISTS (SELECT 1 FROM information_schema.tables 
                   --WHERE table_name = 'epg_stats' AND table_schema = 'public') OR (SELECT COUNT(*) FROM epg_stats) = 0 THEN
        --SELECT create_and_load_table();
    --END IF;
--END $$;

CREATE OR REPLACE FUNCTION get_epg_stats()
RETURNS TABLE (
    epg_name TEXT,                  -- Название программы
    unique_clients INTEGER,         -- Количество уникальных пользователей
    formatted_duration TEXT,        -- Суммарное время в формате HH:MM:SS
    total_duration_seconds BIGINT   -- Суммарное время в секундах
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        epg_stats.epg_name,  -- Название программы
        COUNT(DISTINCT client)::INTEGER AS unique_clients,  -- Количество уникальных пользователей
        -- Преобразование total_duration в формат HH:MM:SS
        TO_CHAR(
            SUM(
                LEAST(
                    epg_stats.duration,  -- Сравниваем duration
                    EXTRACT(EPOCH FROM (epg_stats.time_to_epg - epg_stats.time_epg))  -- Разница во времени между time_epg и time_to_epg в секундах
                )::BIGINT * INTERVAL '1 second'  -- Переводим в интервал времени
            ),
            'HH24:MI:SS'  -- Форматируем в HH:MM:SS
        ) AS formatted_duration,  -- Преобразованный результат
        SUM(
            LEAST(
                epg_stats.duration,  
                EXTRACT(EPOCH FROM (epg_stats.time_to_epg - epg_stats.time_epg)) 
            )  -- Суммируем минимальные значения в секундах
        )::BIGINT AS total_duration_seconds  -- Суммарное время в секундах
    FROM 
        epg_stats
    GROUP BY 
        epg_stats.epg_name
    ORDER BY 
        total_duration_seconds DESC;  -- Сортировка по суммарному времени в секундах
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_ch_stats()
RETURNS TABLE (
    ch_id INTEGER,                  -- Номер канала
    unique_clients INTEGER,         -- Количество уникальных пользователей
    formatted_duration TEXT,        -- Суммарное время в формате HH:MM:SS
    total_duration_seconds BIGINT   -- Суммарное время в секундах
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        epg_stats.ch_id,  -- Номер канала
        COUNT(DISTINCT client)::INTEGER AS unique_clients,  -- Количество уникальных пользователей
        -- Преобразование total_duration в формат HH:MM:SS
        TO_CHAR(
            SUM(epg_stats.duration)::BIGINT * INTERVAL '1 second',  -- Переводим в интервал времени
            'HH24:MI:SS'  -- Форматируем в HH:MM:SS
        ) AS formatted_duration,  -- Преобразованный результат
        SUM(epg_stats.duration)::BIGINT  -- Суммируем время в секундах
        AS total_duration_seconds  -- Суммарное время в секундах
    FROM 
        epg_stats
    GROUP BY 
        epg_stats.ch_id
    ORDER BY 
        total_duration_seconds DESC;  -- Сортировка по суммарному времени в секундах
END;
$$ LANGUAGE plpgsql;

