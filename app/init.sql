CREATE TABLE IF NOT EXISTS submissions (
                id SERIAL PRIMARY KEY,
                name TEXT NOT NULL,
                email TEXT NOT NULL,
                message TEXT NOT NULL,
                created_at TIMESTAMPTZ DEFAULT now()
            );