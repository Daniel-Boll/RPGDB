create extension if not exists pgcrypto;

CREATE OR REPLACE FUNCTION random(numeric, numeric)
RETURNS numeric AS
$$
   SELECT ($1 + ($2 - $1) * random())::numeric;
$$ LANGUAGE 'sql' VOLATILE;

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
-- INSERT INTO account (name, email, password) VALUES (
--   'Daniel Boll',
--   'danielboll.academico@gmail.com', 
--   crypt('123', gen_salt('bf')) 
-- ), (
--   'Felipi Matozinho',
--   'matozinhof.academico@gmail.com', 
--   crypt('123', gen_salt('bf')) 
-- ), (
--   'Pablo Hugen',
--   'pablo.hugen@gmail.com', 
--   crypt('123', gen_salt('bf')) 
-- ), (
--   'Lucas Mulling',
--   'mulling.l@intel.com', 
--   crypt('gentoo', gen_salt('bf')) 
-- );

-- Insert into Account
do $$
declare 
    names text[];
begin
    names := array [
      'Daniel Boll', 'Felipi Matozinho', 
      'Pablo Hugen', 'Lucas Mulling', 
      'Guilherme Vier', 'Lucas Tomalack', 
      'Gabriel Ramos', 'Ivonei Freitas'
      'Vitor Frois', 'Perla Castanheda',
      'Joshua Capistrano', 'Celeste Pastana',
      'Mickael Jordão', 'Cármen Oleiro',
      'Adyan Mackie', 'Aleisha Markham',
      'Kyla Flynn', 'Anwen Middleton',
      'Kenya Nielsen', 'Nasir Cross',
      'Nayla Sutton', 'Daphne Bowman',
      'Charlie Fitzgerald', 'Bobby Estes',
      'Kealan Britt', 'Hattie Bright',
      'Akaash Knowles', 'Havin Montgomery',
      'Greta Donovan', 'Rahima Wilcox',
      'Lola-Mae Houghton', 'Ella-Grace Ruiz',
      'Carwyn Santana', 'Katharine Edge',
      'Ryan Weiss', 'Chanice Fleming',
      'Blane Acosta', 'Freya Bauer',
      'Zi Chambers', 'Campbell Adamson',
      'Arya Guzman', 'Sheldon Devine',
      'Emily-Rose Mcneill', 'Ivie Thatcher',
      'Giovanna Jorge'
    ];

    for r in 1..(select array_length(names, 1)) loop
      INSERT INTO account (name, email, password) VALUES (
        names[r],
        (select LOWER(REPLACE(names[r], ' ', '.')) || '@gmail.com'),
        crypt('123', gen_salt('bf'))
      );
    end loop;
end $$;


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

--                                    CRAFT
-- +----------+------+--------------------------------------+
-- | Column   | Type | Modifiers                            |
-- |----------+------+--------------------------------------|
-- | id       | uuid |  not null default uuid_generate_v4() |
-- | name     | text |  not null                            |
-- | modifier | uuid |                                      |
-- +----------+------+--------------------------------------+
-- Indexes:
--     "craft_pkey" PRIMARY KEY, btree (id)
-- Foreign-key constraints:
--     "fk_craft_modifier" FOREIGN KEY (modifier) REFERENCES modifier(id)
-- Referenced by:
--     TABLE "craft_item" CONSTRAINT "fk_craft_item_craft" FOREIGN KEY (craft) REFERENCES craft(id)
--     TABLE ""character"" CONSTRAINT "fk_character_craft" FOREIGN KEY (craft) REFERENCES craft(id)
do $$
declare 
    crafts text[];
    items text[];
begin
    crafts := array ['Blacksmith', 'Alchemist', 'Carpenter', 'Cook',    'Farmer', 'Hunter', 'Miner',   'Woodcutter'];
    items := array [ 'Hammer',     'Potion',    'Saw',   'Cleaver', 'Scythe', 'Bow',    'Pickaxe', 'Axe'];
    for r in 1..(select array_length(items, 1)) loop
    WITH modifier_id AS (
      INSERT INTO modifier (wisdom, charisma, constitution, dexterity, strength, intelligence) VALUES (
        (SELECT (random() * 20 - 10)::integer),
        (SELECT (random() * 20 - 10)::integer),
        (SELECT (random() * 20 - 10)::integer),
        (SELECT (random() * 20 - 10)::integer),
        (SELECT (random() * 20 - 10)::integer),
        (SELECT (random() * 20 - 10)::integer)
    ) RETURNING id),
    item_id AS (
      INSERT INTO item (name, description ,modifier) VALUES (
        items[r],
        'Item description here',
        (SELECT id FROM modifier_id)
      ) RETURNING id),
    modifier_id_craft AS (
      INSERT INTO modifier (wisdom, charisma, constitution, dexterity, strength, intelligence) VALUES (
        (SELECT (random() * 20 - 10)::integer),
        (SELECT (random() * 20 - 10)::integer),
        (SELECT (random() * 20 - 10)::integer),
        (SELECT (random() * 20 - 10)::integer),
        (SELECT (random() * 20 - 10)::integer),
        (SELECT (random() * 20 - 10)::integer)
    ) RETURNING id),
    craft_id AS (
      INSERT INTO craft (name, modifier) VALUES (
        crafts[r],
        (SELECT id FROM modifier_id_craft)
    ) RETURNING id)
    INSERT INTO craft_item (item, craft, amount) VALUES (
      (SELECT id FROM item_id),
      (SELECT id FROM craft_id),
      0
    );
    end loop;
end $$;

--                                    GUILD
-- +--------+------+--------------------------------------+
-- | Column | Type | Modifiers                            |
-- |--------+------+--------------------------------------|
-- | id     | uuid |  not null default uuid_generate_v4() |
-- | name   | text |  not null                            |
-- +--------+------+--------------------------------------+
-- Indexes:
--     "guild_pkey" PRIMARY KEY, btree (id)
-- Referenced by:
--     TABLE ""character"" CONSTRAINT "fk_character_guild" FOREIGN KEY (guild) REFERENCES guild(id)
--     TABLE "siege" CONSTRAINT "fk_siege_guild" FOREIGN KEY (guild) REFERENCES guild(id)
do $$
declare 
    guild text[];
begin
    guild := array [ 'The Crossed Staves', 'The Dragon s Cellar', 'The Pilgrim and Cask' ];

    for r in 1..(select array_length(guild, 1)) loop
    INSERT INTO guild (name) VALUES (
      guild[r]
    );
    end loop;
end $$;

--                                    CHARACTER
-- +------------+-----------------------------+--------------------------------------+
-- | Column     | Type                        | Modifiers                            |
-- |------------+-----------------------------+--------------------------------------|
-- | id         | uuid                        |  not null default uuid_generate_v4() |
-- | name       | character varying(26)       |  not null                            |
-- | genre      | text                        |  not null                            |
-- | created_at | timestamp without time zone |  default now()                       |
-- | level      | integer                     |  not null                            |
-- | exp        | integer                     |  not null                            |
-- | hp         | integer                     |  not null                            |
-- | mana       | integer                     |  not null                            |
-- | score      | bigint                      |  not null                            |
-- | account    | uuid                        |                                      |
-- | attribute  | uuid                        |                                      |
-- | race       | uuid                        |                                      |
-- | class      | uuid                        |                                      |
-- | craft      | uuid                        |                                      |
-- | guild      | uuid                        |                                      |
-- | inventory  | uuid                        |                                      |
-- +------------+-----------------------------+--------------------------------------+
do $$
declare 
    names text[];
    genre text[];
    crafts_id uuid[];
    accounts_id uuid[];
    races_id uuid[];
    classes_id uuid[];
    guilds_id uuid[];

    random_name integer;
    random_craft integer;
    random_genre integer;
    random_account integer;
    random_race integer;
    random_class integer;
    random_guild integer;

    characters_amount integer;
begin
    names := array [
      'Udorht', 'Bertom', 'George',
      'Ephes', 'Gubeor', 'Reyny',
      'Here', 'Vyncent', 'Richye',
      'Andel', 'Folke', 'Cuthfre',
      'Warder', 'Bertio', 'Narder',
      'Giles', 'Behrtio', 'Gauward',
      'Gare', 'Ralphye'
    ];
    genre := array ['Male', 'Female', 'Asturh', 'Both', 'None'];
    
    crafts_id := array(select craft.id from craft);
    accounts_id := array(select account.id from account);
    races_id := array(select race.id from race);
    classes_id := array(select class.id from class);
    guilds_id := array(select guild.id from guild);

    for a in 1..(select array_length(accounts_id, 1)::integer) loop
      characters_amount = (select (random() * 1 + 2)::integer);

      for r in 1..characters_amount loop
        random_name  = random(1, array_length(names, 1))::int;
        random_genre = random(1, array_length(genre, 1))::int;
        random_craft = random(1, array_length(crafts_id, 1))::int;
        random_race  = random(1, array_length(races_id, 1))::int;
        random_class = random(1, array_length(classes_id, 1))::int;
        random_guild = random(1, array_length(guilds_id, 1))::int;

        -- raise notice 'Name: %', names[random_name] || ' The ' || (select craft.name from craft where id = crafts_id[random_craft]) || ' ' || random(1, 10)::int::text;

        -- Modifier
        WITH character_attribute_id AS (
          INSERT INTO attribute (wisdom, charisma, constitution, dexterity, strength, intelligence) VALUES (
            (SELECT (random() * 10 - 5)::integer),
            (SELECT (random() * 10 - 5)::integer),
            (SELECT (random() * 10 - 5)::integer),
            (SELECT (random() * 10 - 5)::integer),
            (SELECT (random() * 10 - 5)::integer),
            (SELECT (random() * 10 - 5)::integer)
        ) RETURNING id),
        character_inventory_id AS (INSERT INTO inventory (weight) VALUES (
          (SELECT (random() * 100 - 50)::integer) -- weight
        ) RETURNING id)
        
        INSERT INTO character (name, genre, level, exp, hp, mana, score, account, attribute, race, class, craft, guild, inventory) VALUES (
          names[random_name] || ' The ' || (select craft.name from craft where id = crafts_id[random_craft]) || ' ' || random(1, 2022)::int::text,
          genre[random_genre],
          random(1, 30)::int, -- level
          0, -- exp
          (select (random() * 60 + 55)::integer), -- hp
          (select (random() * 30 + 50)::integer), -- mana
          random(1, 10000)::int, -- score
          accounts_id[a], -- account
          (SELECT id FROM character_attribute_id),  -- attribute
          races_id[random_race], -- race
          classes_id[random_class], -- class
          crafts_id[random_craft], -- craft
          guilds_id[random_guild], -- guild
          (select id from character_inventory_id)
        );
      end loop;
    end loop;
end $$;
