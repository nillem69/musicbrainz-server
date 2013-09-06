SET search_path = 'musicbrainz', 'public';

BEGIN;
SELECT no_plan();

--------------------------------------------------------------------------------
-- Test data
INSERT INTO artist_name (id, name) VALUES (1, 'Name');
INSERT INTO artist (id, gid, name, sort_name)
VALUES (1, '3aa25d1a-fe09-47d0-80b5-350d0bae40bf', 1, 1);

INSERT INTO artist_credit (id, name, artist_count) VALUES (1, 1, 1);

INSERT INTO track_name (id, name) VALUES (1, 'Recording');
INSERT INTO release_name (id, name) VALUES (1, 'Release');
INSERT INTO release_group (id, gid, name, artist_credit)
VALUES (1, '8c88e3ed-fe61-433f-844f-54a573bf4253', 1, 1);

INSERT INTO release (id, gid, name, artist_credit, release_group)
VALUES (1, 'a847b5a9-ba88-4cfb-b243-06333cf0d3f9', 1, 1, 1);
INSERT INTO medium (id, release, position) VALUES (1, 1, 1);

--------------------------------------------------------------------------------
-- Tests!
INSERT INTO recording (id, gid, artist_credit, name)
VALUES (1, '59304940-fd3e-49bf-9657-16a0f8687c26', 1, 1);

-- Can update standalone recording lengths
SELECT is(length, NULL) FROM recording WHERE id = 1;
UPDATE recording SET length = 1234 WHERE id = 1;
SELECT is(length, 1234) FROM recording WHERE id = 1;

-- Track length overrides standalone recording lengths
INSERT INTO track (id, gid, name, artist_credit, recording, length, medium, position, number)
VALUES (1, 'd87fb7e5-4446-4cd5-89f1-9da452606da7', 1, 1, 1, NULL, 1, 1, '1');
SELECT is(length, NULL) FROM recording WHERE id = 1;

-- A recording with tracks cannot have a non-median length
UPDATE recording SET length = 1234 WHERE id = 1;
SELECT is(length, NULL) FROM recording WHERE id = 1;

-- Updating tracks changes the recording length
UPDATE track SET length = 1234 WHERE id = 1;
SELECT is(length, (SELECT length FROM track WHERE id = 1)) FROM recording WHERE id = 1;

-- New tracks keep left biased median
INSERT INTO track (id, gid, name, artist_credit, recording, length, medium, position, number)
VALUES (2, '391d8119-102d-42a2-a932-4bf44ea3927e', 1, 1, 1, 9999, 1, 2, '2');
SELECT is(length, (SELECT length FROM track WHERE id = 1)) FROM recording WHERE id = 1;

-- Median update due to a new track
INSERT INTO track (id, gid, name, artist_credit, recording, length, medium, position, number)
VALUES (3, '04009a2e-959c-4dfa-98a1-c0241fe60eb7', 1, 1, 1, 7777, 1, 3, '3');
SELECT is(length, (SELECT length FROM track WHERE id = 3)) FROM recording WHERE id = 1;

-- Median can update to a lower median
INSERT INTO track (id, gid, name, artist_credit, recording, length, medium, position, number)
VALUES (4, '9147bbdf-0d44-4966-8f58-526b3885aaff', 1, 1, 1, 1235, 1, 4, '4');
SELECT is(length, (SELECT length FROM track WHERE id = 4)) FROM recording WHERE id = 1;

-- Track deletions update recording length
DELETE FROM track WHERE id IN (1, 2, 4);
SELECT is(length, (SELECT length FROM track WHERE id = 3)) FROM recording WHERE id = 1;

SELECT finish();
ROLLBACK;
