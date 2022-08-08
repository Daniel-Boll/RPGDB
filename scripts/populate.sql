--                                    ACCOUNT
-- +------------+-----------------------------+--------------------------------------+
-- | Column     | Type                        | Modifiers                            |
-- |------------+-----------------------------+--------------------------------------|
-- | id         | uuid                        |  not null default uuid_generate_v4() |
-- | name       | text                        |  not null                            |
-- | email      | text                        |  not null                            |
-- | password   | text                        |  not null                            |
-- | created_at | timestamp without time zone |  default now()                       |
-- | updated_at | timestamp without time zone |                                      |
-- +------------+-----------------------------+--------------------------------------+
-- Indexes:
--     "account_pkey" PRIMARY KEY, btree (id)
--     "account_email_key" UNIQUE CONSTRAINT, btree (email)

-- Insert into Account
INSERT INTO account (name, email, password) VALUES (
  'Daniel Boll',
  'danielboll.academico@gmail.com', 
  crypt('123', gen_salt('bf')) 
), (
  'Felipi Matozinho',
  'matozinhof.academico@gmail.com', 
  crypt('123', gen_salt('bf')) 
), (
  'Pablo Hugen',
  'pablo.hugen.onlyfans@gmail.com', 
  crypt('123', gen_salt('bf')) 
), (
  'Lucas Mulling',
  'mulling.l@intel.com', 
  crypt('gentoo', gen_salt('bf')) 
);


--                                    CLASS
-- +----------+------+--------------------------------------+
-- | Column   | Type | Modifiers                            |
-- |----------+------+--------------------------------------|
-- | id       | uuid |  not null default uuid_generate_v4() |
-- | name     | text |  not null                            |
-- | modifier | uuid |                                      |
-- +----------+------+--------------------------------------+
-- Indexes:
--     "class_pkey" PRIMARY KEY, btree (id)
-- Foreign-key constraints:
--     "fk_class_modifier" FOREIGN KEY (modifier) REFERENCES modifier(id)
-- Referenced by:
--     TABLE "skill_class" CONSTRAINT "fk_skill_class_class" FOREIGN KEY (class) REFERENCES class(id)
--     TABLE ""character"" CONSTRAINT "fk_character_class" FOREIGN KEY (class) REFERENCES class(id)

--                                    MODIFIER
-- +--------------+---------+--------------------------------------+
-- | Column       | Type    | Modifiers                            |
-- |--------------+---------+--------------------------------------|
-- | id           | uuid    |  not null default uuid_generate_v4() |
-- | wisdom       | integer |  not null default 0                  |
-- | charisma     | integer |  not null default 0                  |
-- | constitution | integer |  not null default 0                  |
-- | dexterity    | integer |  not null default 0                  |
-- | strength     | integer |  not null default 0                  |
-- | intelligence | integer |  not null default 0                  |
-- +--------------+---------+--------------------------------------+
do $$
declare 
    classes text[];
begin
    classes := array ['Barbarian', 'Bard', 'Cleric', 'Druid', 'Fighter', 'Monk', 'Paladin', 'Ranger', 'Rogue', 'Sorcerer', 'Warlock', 'Wizard'];
    for r in 1..(select array_length(classes, 1)) loop
    WITH modifier_id AS (
      INSERT INTO modifier (wisdom, charisma, constitution, dexterity, strength, intelligence) VALUES (
        (SELECT (random() * 20 - 10)::integer),
        (SELECT (random() * 20 - 10)::integer),
        (SELECT (random() * 20 - 10)::integer),
        (SELECT (random() * 20 - 10)::integer),
        (SELECT (random() * 20 - 10)::integer),
        (SELECT (random() * 20 - 10)::integer)
    ) RETURNING id)
    INSERT INTO class (name, modifier) VALUES (
      classes[r],
      (SELECT id FROM modifier_id)
    );
    end loop;
end $$;


--                                    RACE
-- +----------+------+--------------------------------------+
-- | Column   | Type | Modifiers                            |
-- |----------+------+--------------------------------------|
-- | id       | uuid |  not null default uuid_generate_v4() |
-- | name     | text |  not null                            |
-- | region   | text |  not null                            |
-- | lore     | text |  not null                            |
-- | modifier | uuid |                                      |
-- +----------+------+--------------------------------------+
-- Indexes:
--     "race_pkey" PRIMARY KEY, btree (id)
-- Foreign-key constraints:
--     "fk_race_modifier" FOREIGN KEY (modifier) REFERENCES modifier(id)
-- Referenced by:
--     TABLE "skill_race" CONSTRAINT "fk_skill_race_race" FOREIGN KEY (race) REFERENCES race(id)
--     TABLE ""character"" CONSTRAINT "fk_character_race" FOREIGN KEY (race) REFERENCES race(id)

do $$
declare 
    races text[];
    regions text[];
begin
    races := array ['Human', 'Gnome', 'Faeries', 'Goblins', 'Dwarves', 'Orcs', 'Elves'];
    regions := array [
      'Nabupol', 'Ammitaal', 'Saamsuma', 'Saresu', 'Aliinmus', 
      'Ammitad', 'Ammamum', 'Asmamuk', 'Arsamum', 'Sumuzi', 
      'Abiudin', 'Sheanebu', 'Abin', 'Amsuibnit', 'Abobas', 
      'Zeriashuu', 'Ergamsus', 'Nunnerga', 'Saamsara', 'Inusum'
    ];
    for r in 1..(select array_length(races, 1)) loop
    WITH modifier_id AS (
      INSERT INTO modifier (wisdom, charisma, constitution, dexterity, strength, intelligence) VALUES (
        (SELECT (random() * 20 - 10)::integer),
        (SELECT (random() * 20 - 10)::integer),
        (SELECT (random() * 20 - 10)::integer),
        (SELECT (random() * 20 - 10)::integer),
        (SELECT (random() * 20 - 10)::integer),
        (SELECT (random() * 20 - 10)::integer)
    ) RETURNING id)
    INSERT INTO race (name, region, lore, modifier) VALUES (
      races[r],
      regions[(random() * (select array_length(regions, 1) + 1)::integer)],
      'Awesome lore here',
      (SELECT id FROM modifier_id)
    );
    end loop;
end $$;

--                                    ITEM
-- +-------------+------+--------------------------------------+
-- | Column      | Type | Modifiers                            |
-- |-------------+------+--------------------------------------|
-- | id          | uuid |  not null default uuid_generate_v4() |
-- | name        | text |  not null                            |
-- | description | text |  not null                            |
-- | modifier    | uuid |                                      |
-- +-------------+------+--------------------------------------+
-- Indexes:
--     "item_pkey" PRIMARY KEY, btree (id)
-- Foreign-key constraints:
--     "fk_item_modifier" FOREIGN KEY (modifier) REFERENCES modifier(id)
-- Referenced by:
--     TABLE "craft_item" CONSTRAINT "fk_craft_item_item" FOREIGN KEY (item) REFERENCES item(id)
--     TABLE "inventory_item" CONSTRAINT "fk_inventory_item_item" FOREIGN KEY (item) REFERENCES item(id)
--     TABLE "boss_item" CONSTRAINT "fk_boss_item_item" FOREIGN KEY (item) REFERENCES item(id)
do $$
declare 
    items text[];
begin
    items := array [
      'Elysian Champion', 'Sublime Triumph', 'Malevolent Tyrant', 
      'Ghoulthorn', 'Giantslayer', 'Waverazor', 
      'Skullbreaker', 'Wavecrusher', 'Hearthammer', 
      'Foefang', 'The Libram of Glyphs and Runes', 'The Tome of Fari', 
      'The Abyssal Folio of Liasinom', 'The Heavenly Codex of Palmaro', 
      'Eurybbas  Parchments of the Underdark', 'Alilon s Parchments of Law', 
      'The Elemental Incunabulum of Muli', 'Cune s Parchments of Ectoplasm', 
      'Ario s Leaves of Cataclysm', 'The Demonic Esoterica of Rarde'
    ];
    for r in 1..(select array_length(items, 1)) loop
    WITH modifier_id AS (
      INSERT INTO modifier (wisdom, charisma, constitution, dexterity, strength, intelligence) VALUES (
        (SELECT (random() * 20 - 10)::integer),
        (SELECT (random() * 20 - 10)::integer),
        (SELECT (random() * 20 - 10)::integer),
        (SELECT (random() * 20 - 10)::integer),
        (SELECT (random() * 20 - 10)::integer),
        (SELECT (random() * 20 - 10)::integer)
    ) RETURNING id)
    INSERT INTO item (name, description ,modifier) VALUES (
      items[r],
      'Items description here',
      (SELECT id FROM modifier_id)
    );
    end loop;
end $$;

--                                    SKILL
-- +-------------+---------+--------------------------------------+
-- | Column      | Type    | Modifiers                            |
-- |-------------+---------+--------------------------------------|
-- | id          | uuid    |  not null default uuid_generate_v4() |
-- | name        | text    |  not null                            |
-- | description | text    |  not null                            |
-- | cost        | integer |  not null                            |
-- | effect      | text    |  not null                            |
-- +-------------+---------+--------------------------------------+
-- Indexes:
--     "skill_pkey" PRIMARY KEY, btree (id)
-- Referenced by:
--     TABLE "skill_race" CONSTRAINT "fk_skill_race_skill" FOREIGN KEY (skill) REFERENCES skill(id)
--     TABLE "skill_enemy" CONSTRAINT "fk_skill_enemy_skill" FOREIGN KEY (skill) REFERENCES skill(id)
--     TABLE "skill_class" CONSTRAINT "fk_skill_class_skill" FOREIGN KEY (skill) REFERENCES skill(id)
--     TABLE "turn" CONSTRAINT "fk_turn_skill" FOREIGN KEY (skill) REFERENCES skill(id)

do $$
declare 
    skills text[];
begin
    skills := array [
      'Nimble Rampage', 'Devoted Energy', 'Grateful Desolation', 
      'Mystic s Smash', 'Kraken s Frenzy', 'Celtic s Beauty', 
      'Minotaur s Beacon', 'Hades Pull', 'Hideous Arrow', 
      'Witch s Possessed Yearning', 'Harvester s Black Victory', 
      'Motion of the Axemaster', 'Hatred of the Abbot', 'Grapple against Vengeance', 
      'Bludgeoning against Labyrinth'
    ];

    for r in 1..(select array_length(skills, 1)) loop
    INSERT INTO skill (name, description, cost, effect) VALUES (
      skills[r],
      'Skill description here',
      (SELECT (random() * 10 + 1)::integer),
      'Skill effect here'
    );
    end loop;
end $$;

-- TODO: Craft insertion
-- TODO: Character insertion
