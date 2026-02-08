-- ============================================================================
-- TEST-SKRIPT FOR OPPGAVESETT 1.4: Databasemodellering og implementering
-- ============================================================================

-- Kjør med: docker-compose exec postgres psql -h -U admin -d data1500_db -f test-scripts/oppgave4_losning.sql

-- 4.1. Finn de 3 nyeste beskjeder fra læreren i et gitt klasserom
SELECT * FROM messages
WHERE classroom_id = 1
ORDER BY (created_at) DESC
LIMIT 3;

-- 4.2. Vis en hel diskusjonstråd startet av en spesifikk student
-- Henter ut diskusjonstråd id 1 startet av bruker id 2.
WITH RECURSIVE diskusjonstraad AS (
    SELECT discussion_id, user_id, reply_to_id, title, message, created_at FROM discussionforum
    WHERE discussion_id = 1

    UNION ALL

    SELECT df.discussion_id, df.user_id, df.reply_to_id, df.title, df.message, df.created_at FROM discussionforum AS df
    JOIN diskusjonstraad AS dt
    ON df.reply_to_id = dt.discussion_id
)

SELECT * FROM diskusjonstraad;

-- 4.3. Finn alle studenter i en spesifikk gruppe
-- Jeg har antatt at det er et en-til-en forhold mellom klasserom og grupper.
SELECT COUNT(user_id) FROM groups
WHERE classroom_id = 1;

-- 4.4. Finn antall grupper
-- Jeg har antatt at det er et en-til-en forhold mellom klasserom og grupper.
SELECT COUNT(*) FROM (
    SELECT classroom_id FROM groups
    GROUP BY classroom_id
) AS grouped

-- En test SQL-spørring mot metadata i PostgreSQL
select nspname as schema_name from pg_catalog.pg_namespace;
