CREATE TABLE IF NOT EXISTS public.posts (
    id uuid DEFAULT uuid_generate_v4(),
    title text,
    PRIMARY KEY (id)
);
ALTER TABLE IF EXISTS public.posts OWNER to db;