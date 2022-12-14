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
  name text UNIQUE NOT NULL,
  region text NOT NULL,
  lore text NOT NULL,
  modifier UUID,

  constraint fk_race_modifier FOREIGN key (modifier) REFERENCES modifier(id)
);

CREATE TABLE class (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name text UNIQUE NOT NULL,
  modifier UUID,

  constraint fk_class_modifier FOREIGN key (modifier) REFERENCES modifier(id)
);

CREATE TABLE Craft (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name text UNIQUE NOT NULL,
  modifier UUID,

  constraint fk_craft_modifier FOREIGN key (modifier) REFERENCES modifier(id)
);

CREATE TABLE Item (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name text UNIQUE NOT NULL,
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
  name text UNIQUE NOT NULL
);

CREATE TABLE Inventory (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  weight integer NOT NULL
);

CREATE TABLE Inventory_Item (
  inventory UUID,
  item UUID,
  amount integer NOT NULL,
  
  PRIMARY KEY (inventory, item),

  constraint fk_inventory_item_item FOREIGN key (item) REFERENCES item(id),
  constraint fk_inventory_item_inventory FOREIGN key (inventory) REFERENCES inventory(id)
);

CREATE TABLE Skill (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name text UNIQUE NOT NULL,
  description text NOT NULL,
  cost integer NOT NULL,
  effect text NOT NULL
);

CREATE TABLE Enemy (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name text UNIQUE NOT NULL,
  hp integer NOT NULL,

  attribute UUID,

  constraint fk_enemy_attribute FOREIGN key (attribute) REFERENCES attribute(id)
);

CREATE TABLE Environment (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name text UNIQUE NOT NULL,
  region text NOT NULL,

  modifier UUID,

  constraint fk_environment_modifier FOREIGN key (modifier) REFERENCES modifier(id)
);

CREATE TABLE Skill_Class (
  class UUID,
  skill UUID,

  PRIMARY KEY (class, skill),

  constraint fk_skill_class_class FOREIGN key (class) REFERENCES class(id),
  constraint fk_skill_class_skill FOREIGN key (skill) REFERENCES skill(id)
);

CREATE TABLE Skill_Race (
  race UUID,
  skill UUID,

  PRIMARY KEY (race, skill),

  constraint fk_skill_race_race FOREIGN key (race) REFERENCES race(id),
  constraint fk_skill_race_skill FOREIGN key (skill) REFERENCES skill(id)
);

CREATE TABLE Skill_Enemy (
  skill UUID,
  enemy UUID,

  PRIMARY KEY (skill, enemy),

  constraint fk_skill_enemy_enemy FOREIGN key (enemy) REFERENCES enemy(id),
  constraint fk_skill_enemy_skill FOREIGN key (skill) REFERENCES skill(id)
);

CREATE TABLE Battle (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  end_date timestamp,
  begin_date timestamp
);

CREATE TABLE Environment_Battle (
  environment UUID,
  battle UUID,

  PRIMARY KEY (environment, battle),

  constraint fk_environment_battle_environment FOREIGN key (environment) REFERENCES environment(id),
  constraint fk_environment_battle_battle FOREIGN key (battle) REFERENCES battle(id)
);

CREATE TABLE Enemy_Battle (
  enemy UUID,
  battle UUID,
  
  PRIMARY KEY (enemy, battle),

  constraint fk_enemy_battle_enemy FOREIGN key (enemy) REFERENCES enemy(id),
  constraint fk_enemy_battle_battle FOREIGN key (battle) REFERENCES battle(id)
);

CREATE TABLE character (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name varchar(36) UNIQUE NOT NULL,
  genre text NOT NULL,
  created_at timestamp DEFAULT now(),
  level integer NOT NULL,
  exp integer NOT NULL,
  hp integer NOT NULL,
  mana integer NOT NULL,
  score bigint NOT NULL,

  account UUID,
  attribute UUID,
  race UUID,
  class UUID,
  craft UUID,
  guild UUID,
  inventory UUID,

  constraint fk_character_account FOREIGN key (account) REFERENCES account(id),
  constraint fk_character_attribute FOREIGN key (attribute) REFERENCES attribute(id),
  constraint fk_character_race FOREIGN key (race) REFERENCES race(id),
  constraint fk_character_class FOREIGN key (class) REFERENCES class(id),
  constraint fk_character_craft FOREIGN key (craft) REFERENCES craft(id),
  constraint fk_character_guild FOREIGN key (guild) REFERENCES guild(id),
  constraint fk_character_inventory FOREIGN key (inventory) REFERENCES inventory(id)
);

CREATE TABLE Character_Battle (
  character UUID,
  battle UUID,

  PRIMARY KEY (character, battle),
  
  constraint fk_character_battle_character FOREIGN key (character) REFERENCES character(id),
  constraint fk_character_battle_battle FOREIGN key (battle) REFERENCES battle(id)
);

CREATE TABLE Turn (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  character_hp_diff integer DEFAULT 0,
  enemy_hp_diff integer DEFAULT 0,
  character_mana_diff integer DEFAULT 0,

  created_at timestamp DEFAULT now(),

  character UUID,
  enemy UUID,
  skill UUID,
  battle UUID,

  constraint fk_turn_character FOREIGN key (character) REFERENCES character(id),
  constraint fk_turn_enemy FOREIGN key (enemy) REFERENCES enemy(id),
  constraint fk_turn_skill FOREIGN key (skill) REFERENCES skill(id),
  constraint fk_turn_battle FOREIGN key (battle) REFERENCES battle(id)
);

CREATE TABLE Boss (
  id UUID PRIMARY KEY,
  modifier UUID,

  constraint fk_boss_enemy FOREIGN key (id) REFERENCES enemy(id),
  constraint fk_boss_modifier FOREIGN key (modifier) REFERENCES modifier(id)
);

CREATE TABLE Boss_Item (
  item UUID,
  boss UUID,
  amount integer NOT NULL,

  PRIMARY KEY (item, boss),

  constraint fk_boss_item_item FOREIGN key (item) REFERENCES item(id),
  constraint fk_boss_item_boss FOREIGN key (boss) REFERENCES boss(id)
);

CREATE TABLE Siege (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name text UNIQUE NOT NULL,

  boss UUID,
  guild UUID,

  constraint fk_siege_boss FOREIGN key (boss) REFERENCES boss(id),
  constraint fk_siege_guild FOREIGN key (guild) REFERENCES guild(id)
);

COMMENT ON TABLE account IS '# <h1 align=center>Usu??rio</h1>
> Essa tabela define o conjunto de dados necess??rios para compor uma esp??cie de conta

## Detalhes
- Um usu??rio pode no m??ximo ter 3 personagens.';

COMMENT ON COLUMN account.Password IS 'Essa senha ?? salva encriptada de forma a garantir maior seguran??a';

COMMENT ON TABLE Character IS '# <h1 align=center>Personagem</h1>
> Essa tabela guarda as informa????es de um personagem, bem como suas rela????es com suas diversas tabelas';

COMMENT ON COLUMN Character.level IS 'Armazena o level atual do personagem';

COMMENT ON COLUMN Character.exp IS 'Armazena a quantidade de experi??ncia atual do personagem';

COMMENT ON COLUMN Character.hp IS 'Guarda o HP (pontos de vida) m??ximo desse personagem';

COMMENT ON COLUMN Character.mana IS 'Representa a quantidade de energia m??xima que esse personagem tem';

COMMENT ON COLUMN Character.score IS 'Representa a quantidade de pontos que esse personagem arrecadou';

COMMENT ON COLUMN Character.account IS 'Um usu??rio pode ter no m??ximo 3 personagens';

COMMENT ON COLUMN Character.craft IS 'Rela????o de profiss??o do personagem';

COMMENT ON TABLE Attribute IS '# <h1 align=center>Atributos</h1>
> Essa tabela guarda as informa????es cl??ssicas de uma ficha de RPG, sendo os pontos que caracterizam um personagem';

COMMENT ON COLUMN Attribute.wisdom IS 'Armazena a quantidade de sabedoria pura do personagem';

COMMENT ON COLUMN Attribute.charisma IS 'Armazena a carisma de sabedoria pura do personagem';

COMMENT ON COLUMN Attribute.constitution IS 'Armazena a constitui????o de sabedoria pura do personagem';

COMMENT ON COLUMN Attribute.dexterity IS 'Armazena a destreza de sabedoria pura do personagem';

COMMENT ON COLUMN Attribute.strength IS 'Armazena a for??a de sabedoria pura do personagem';

COMMENT ON COLUMN Attribute.intelligence IS 'Armazena a intelig??ncia de sabedoria pura do personagem';

COMMENT ON TABLE Race IS '# <h1 align=center>Ra??a</h1>
> Essa tabela representa as ra??as do universo desse RPG';

COMMENT ON COLUMN Race.region IS 'Regi??o de origem da ra??a';

COMMENT ON COLUMN Race.lore IS 'Backstory da ra??a';

COMMENT ON COLUMN Race.modifier IS 'Modifica????o de atributos que essa tabela altera no personagem'; 

COMMENT ON TABLE Class IS '# <h1 align=center>Classe</h1>
> Essa tabela representa as classes do universo desse RPG';

COMMENT ON COLUMN Class.modifier IS 'Modifica????o de atributos que essa tabela altera no personagem';

COMMENT ON TABLE Craft IS '# <h1 align=center>Profiss??es</h1>
> Essa tabela representa as profiss??es do universo desse RPG';

COMMENT ON COLUMN Craft.modifier IS 'Modifica????o de atributos que essa tabela altera no personagem';

COMMENT ON COLUMN Craft_Item.amount IS 'Quantidade desse terminado item que essa profiss??o recebe';

COMMENT ON TABLE Guild IS '# <h1 align=center>Guilda</h1>
> Essa tabela representa grupos/alian??as que os personagens podem fazer para se ajudarem em eventos especiais';

COMMENT ON TABLE Inventory IS '# <h1 align=center>Invent??rio</h1>
> Essa tabela representa o sistema de armazenamento de itens do personagem';

COMMENT ON COLUMN Inventory_Item.amount IS 'Quantidade desse terminado item no invent??rio';

COMMENT ON TABLE Item IS '# <h1 align=center>Item</h1>
> Essa tabela representa um item, um artefato que prop??es altera????es de atributos para os personagens';

COMMENT ON COLUMN Item.modifier IS 'Modifica????o de atributos que essa tabela altera no personagem';

COMMENT ON TABLE Skill IS '# <h1 align=center>Habilidade</h1>
> Habilidades que podem ser conjuradas por um personagem ou inimigo';

COMMENT ON COLUMN Skill.description IS 'A descri????o de utiliza????o e efeitos da habilidade';

COMMENT ON COLUMN Skill.cost IS 'Determina o custo de utiliza????o de determinada habilidade';

COMMENT ON COLUMN Skill.effect IS 'Um balan??a de consequ??ncias do uso da habilidade';

COMMENT ON TABLE Enemy IS '# <h1 align=center>Inimigo</h1>
> Essa tabela descreve um inimigo e seus atributos';

COMMENT ON COLUMN Enemy.hp IS 'Guarda o HP (pontos de vida) m??ximo desse inimigo';

COMMENT ON TABLE Environment IS '# <h1 align=center>Ambiente</h1>
> Essa tabela resulta em uma regi??o de batalha que confere buffs/debuffs aos atributos de personagens e inimigos';

COMMENT ON COLUMN Environment.region IS 'Regi??o onde se encontra esse ambiente';

COMMENT ON COLUMN Environment.modifier IS 'Modifica????o de atributos que essa tabela altera nos personagens e inimigos';

COMMENT ON TABLE Battle IS '# <h1 align=center>Batalha</h1>
> Essa tabela guarda eventos de batalhas do RPG';

COMMENT ON TABLE Turn IS '# <h1 align=center>Turno</h1>
> Essa tabela guarda todos os turnos de uma determinada batalha, sendo um log de danos e curas realizadas';

COMMENT ON COLUMN Turn.character_hp_diff IS 'Dedu????o ou soma na vida do personagem a ser aplicada nesse turno';

COMMENT ON COLUMN Turn.enemy_hp_diff IS 'Dedu????o ou soma na vida do inimigo a ser aplicada nesse turno';

COMMENT ON COLUMN Turn.character_mana_diff IS 'Dedu????o ou soma na mana do personagem a ser aplicada nesse turno';

COMMENT ON TABLE Modifier IS '# <h1 align=center>Modificadores</h1>
> Essa tabela guarda modifica????es que ser??o aplicadas nos atributos puro/base do personagem durante uma determinada batalha';

COMMENT ON COLUMN Modifier.wisdom IS 'Armazena a quantidade de sabedoria que ser?? deduzida/somada do personagem';

COMMENT ON COLUMN Modifier.charisma IS 'Armazena a carisma de sabedoria que ser?? deduzida/somada do personagem';

COMMENT ON COLUMN Modifier.constitution IS 'Armazena a constitui????o de sabedoria que ser?? deduzida/somada do personagem';

COMMENT ON COLUMN Modifier.dexterity IS 'Armazena a destreza de sabedoria que ser?? deduzida/somada do personagem';  

COMMENT ON COLUMN Modifier.strength IS 'Armazena a for??a de sabedoria que ser?? deduzida/somada do personagem';

COMMENT ON COLUMN Modifier.intelligence IS 'Armazena a intelig??ncia de sabedoria que ser?? deduzida/somada do personagem';

COMMENT ON TABLE Boss IS '# <h1 align=center>Chefe de batalha</h1>
> Essa tabela representa um chefe de uma determinada batalha, um inimigo final mais poderoso';

COMMENT ON COLUMN Boss.modifier IS 'Modifica????o de atributos que essa tabela altera no personagem';

COMMENT ON TABLE Siege IS '# <h1 align=center>Cerco</h1>
> Essa tabela representa uma batalha realizada em equipe com uma guilda';
