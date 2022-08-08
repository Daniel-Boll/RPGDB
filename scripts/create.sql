CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE account (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP
);

CREATE TABLE attribute (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  wisdom integer NOT NULL DEFAULT 0,
  charisma integer NOT NULL DEFAULT 0,
  constitution integer NOT NULL DEFAULT 0,
  dexterity integer NOT NULL DEFAULT 0,
  strength integer NOT NULL DEFAULT 0,
  intelligence integer NOT NULL DEFAULT 0
);

CREATE TABLE modifier (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  wisdom integer NOT NULL DEFAULT 0,
  charisma integer NOT NULL DEFAULT 0,
  constitution integer NOT NULL DEFAULT 0,
  dexterity integer NOT NULL DEFAULT 0,
  strength integer NOT NULL DEFAULT 0,
  intelligence integer NOT NULL DEFAULT 0
);

CREATE TABLE race (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name text NOT NULL,
  region text NOT NULL,
  lore text NOT NULL,
  modifier UUID,

  constraint fk_race_modifier FOREIGN key (modifier) REFERENCES modifier(id)
);

CREATE TABLE class (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name text NOT NULL,
  modifier UUID,

  constraint fk_class_modifier FOREIGN key (modifier) REFERENCES modifier(id)
);

CREATE TABLE Craft (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name text NOT NULL,
  modifier UUID,

  constraint fk_craft_modifier FOREIGN key (modifier) REFERENCES modifier(id)
);

CREATE TABLE Item (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name text NOT NULL,
  description text NOT NULL,
  modifier UUID,

  constraint fk_item_modifier FOREIGN key (modifier) REFERENCES modifier(id)
);

CREATE TABLE Craft_Item (
  item UUID,
  craft UUID,
  amount integer NOT NULL,

  PRIMARY KEY (item, craft),

  constraint fk_craft_item_item FOREIGN key (item) REFERENCES item(id),
  constraint fk_craft_item_craft FOREIGN key (craft) REFERENCES craft(id)
);

CREATE TABLE Guild (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name text NOT NULL
);

CREATE TABLE Inventory (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4()
);
