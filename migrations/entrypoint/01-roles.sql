------ REALTIME
DO $$ BEGIN if current_setting('wal_level') is distinct
from 'logical' then raise exception 'wal_level must be set to ''logical'', your database has it set to ''%''. Please edit your `%` file and restart PostgreSQL.',
    current_setting('wal_level'),
    current_setting('config_file');
end if;
if (
    current_setting('max_replication_slots')::int >= 1
) is not true then raise exception 'Your max_replication_slots setting is too low, it must be greater than 1. Please edit your `%` file and restart PostgreSQL.',
current_setting('config_file');
end if;
if (current_setting('max_wal_senders')::int >= 1) is not true then raise exception 'Your max_wal_senders setting is too low, it must be greater than 1. Please edit your `%` file and restart PostgreSQL.',
current_setting('config_file');
end if;
perform pg_create_logical_replication_slot('compatibility_test', 'wal2json');
perform pg_drop_replication_slot('compatibility_test');
raise notice 'Everything seems to be in order.';
end;
$$ LANGUAGE plpgsql;

CREATE ROLE "USER" WITH NOLOGIN NOSUPERUSER NOINHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
CREATE ROLE "ADMIN" WITH NOLOGIN NOSUPERUSER NOINHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
CREATE ROLE "MODER" WITH NOLOGIN NOSUPERUSER NOINHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
CREATE ROLE "GUEST" WITH NOLOGIN NOSUPERUSER NOINHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;

------ EXTENSION
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';

GRANT ALL ON SCHEMA public TO "ADMIN";
GRANT ALL ON SCHEMA public TO "GUEST";
GRANT ALL ON SCHEMA public TO "MODER";
GRANT ALL ON SCHEMA public TO "USER";
GRANT ALL ON SCHEMA public TO db;

---
GRANT ALL ON DATABASE db TO "db";
ALTER DEFAULT PRIVILEGES
GRANT ALL ON TABLES TO "db";
ALTER DEFAULT PRIVILEGES
GRANT ALL ON SEQUENCES TO "db";
ALTER DEFAULT PRIVILEGES
GRANT ALL ON FUNCTIONS TO "db";
ALTER DEFAULT PRIVILEGES
GRANT ALL ON TYPES TO "db";

---
GRANT ALL ON DATABASE db TO "ADMIN";
ALTER DEFAULT PRIVILEGES
GRANT ALL ON TABLES TO "ADMIN";
ALTER DEFAULT PRIVILEGES
GRANT ALL ON SEQUENCES TO "ADMIN";
ALTER DEFAULT PRIVILEGES
GRANT ALL ON FUNCTIONS TO "ADMIN";
ALTER DEFAULT PRIVILEGES
GRANT ALL ON TYPES TO "ADMIN";

---
GRANT ALL ON DATABASE db TO "MODER";
ALTER DEFAULT PRIVILEGES
GRANT ALL ON TABLES TO "MODER";
ALTER DEFAULT PRIVILEGES
GRANT ALL ON SEQUENCES TO "MODER";
ALTER DEFAULT PRIVILEGES
GRANT ALL ON FUNCTIONS TO "MODER";
ALTER DEFAULT PRIVILEGES
GRANT ALL ON TYPES TO "MODER";

---
GRANT ALL ON DATABASE db TO "USER";
ALTER DEFAULT PRIVILEGES
GRANT ALL ON TABLES TO "USER";
ALTER DEFAULT PRIVILEGES
GRANT ALL ON SEQUENCES TO "USER";
ALTER DEFAULT PRIVILEGES
GRANT ALL ON FUNCTIONS TO "USER";
ALTER DEFAULT PRIVILEGES
GRANT ALL ON TYPES TO "USER";