CREATE TABLE de.analysis.dm_rfm_segments (
    user_id int PRIMARY KEY NOT NULL,
    recency int NOT NULL,
    frequency int NOT NULL,
    monetary_value int NOT NULL,
    CHECK (recency >= 1 AND recency <= 5),
    CHECK (frequency >= 1 AND frequency <= 5),
    CHECK (monetary_value >= 1 AND monetary_value <= 5)
);