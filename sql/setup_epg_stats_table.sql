CREATE OR REPLACE FUNCTION create_and_load_table() 
RETURNS VOID AS $$
BEGIN
    -- Проверяем, существует ли таблица 'epg_stats'
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables 
                   WHERE table_name = 'epg_stats' AND table_schema = 'public') THEN
        -- Если таблицы нет, создаём её
        CREATE TABLE epg_stats (
            client VARCHAR(50),
            device VARCHAR(50),
            time_ch TIMESTAMP,
            ch_id INT,
            epg_name TEXT,
            time_epg TIMESTAMP,
            time_to_epg TIMESTAMP,
            duration INT,
            category VARCHAR(100),
            subcategory TEXT
        );
    END IF;

    -- Проверяем, пуста ли таблица
    IF (SELECT COUNT(*) FROM epg_stats) = 0 THEN
        -- Если таблица пуста, выполняем COPY с помощью динамического SQL
        EXECUTE 'COPY epg_stats(client, device, time_ch, ch_id, epg_name, time_epg, time_to_epg, duration, category, subcategory)
                 FROM ''C:/path/to/your/file.csv''
                 DELIMITER '';'' CSV HEADER ENCODING ''UTF8''';
    ELSE
        -- Если таблица не пуста, выводим сообщение
        RAISE NOTICE 'Таблица не пуста, данные не загружены.';
    END IF;
END;
$$ LANGUAGE plpgsql;
