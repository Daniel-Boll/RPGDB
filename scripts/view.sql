CREATE OR REPLACE VIEW guild_rank AS
  SELECT 
    guild.name, 
    sum(character.score) 
  FROM guild 
  INNER JOIN character ON character.guild = guild.id 
  GROUP BY guild.name 
  ORDER BY sum(character.score) DESC;

CREATE OR REPLACE VIEW player_rank_top_3 AS
  SELECT 
    character.name,
    character.score
  FROM character
  ORDER BY character.score DESC
  LIMIT 3;

CREATE OR REPLACE FUNCTION sum_two_numbers(a INTEGER, b INTEGER)
RETURNS INTEGER AS
$$
  SELECT a + b;
$$ LANGUAGE SQL;


-- Sum the character attributes plus all the modifiers for each attribute.
CREATE OR REPLACE FUNCTION sum_attributes(attribute_id uuid, modifier_id uuid) 
-- Sum the values of the columns from the attribute table + the modifier table
RETURNS table (wisdom int, charisma int, constitution int, dexterity int, strength int, intelligence int) AS $$
  SELECT 
    sum_two_numbers(attribute.wisdom, modifier.wisdom) as wisdom,
    sum_two_numbers(attribute.charisma, modifier.charisma) as charisma,
    sum_two_numbers(attribute.constitution, modifier.constitution) as constitution,
    sum_two_numbers(attribute.dexterity, modifier.dexterity) as dexterity,
    sum_two_numbers(attribute.strength, modifier.strength) as strength,
    sum_two_numbers(attribute.intelligence, modifier.intelligence) as intelligence
  FROM attribute, modifier
  WHERE attribute.id = $1 AND modifier.id = $2;
$$ LANGUAGE SQL;

CREATE OR REPLACE VIEW player_stats AS
  select 
    sum_attributes(character.attribute, class.modifier)
  from character
  inner join class on class.id = character.class
  inner join race on race.id = character.race
  inner join craft on craft.id = character.craft
