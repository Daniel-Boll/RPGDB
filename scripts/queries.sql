-- Buscar todas as classes que são usadas por mais de 3 personagens
SELECT class.name 
FROM character
INNER JOIN class ON class.id = character.class
GROUP BY class.name
HAVING count(*) >= 10 
ORDER BY count(*) DESC;

-- Fazer um ranking de personagens a partir de seu score, 
-- ordenando-os do maior para o menor, mostrando o nome do personagem, seu score, 
-- o nome de sua guilda e sua raça
SELECT 
  character.name AS character, 
  score, 
  guild.name AS guild,
  race.name AS race 
FROM character 
INNER JOIN guild ON character.guild = guild.id 
INNER JOIN race ON race.id = character.race 
ORDER BY score DESC

-- Buscar data de início e fim de todas as batalhas de um personagem específico
SELECT 
  begin_date, 
  end_date 
FROM character_battle 
NATURAL JOIN battle
WHERE character_battle.character = <UUID_character>

-- Buscar o nome da profissão e o nome dos itens dela, a partir do id da profissão
SELECT 
  craft.name as craft_name, 
  item.name as item_name 
FROM craft_item 
INNER JOIN item ON item.id = craft_item.item 
INNER JOIN craft ON craft.id = craft_item.craft 
WHERE craft.name = <craft_name>

-- Buscar todos os turnos de uma batalha, através de seu id, ordenando-os do mais antigo para o mais recente
SELECT 
  turn.id, 
  turn.character, 
  turn.battle, 
  turn.character_hp_diff, 
  turn.character_mana_diff, 
  turn.enemy, 
  turn.enemy_hp_diff, 
  turn.skill, 
  turn.created_at 
FROM turn 
INNER JOIN battle ON battle.id = turn.battle where battle.id = <UUID_turn>
ORDER BY turn.created_at DESC;

-- Buscar o nome e o id de todos os itens do inventário de um determinado personagem.
SELECT 
  item.id, 
  item.name 
FROM inventory_item 
INNER JOIN item ON item.id = inventory_item.item
WHERE 
  inventory_item.inventory = 
    (SELECT inventory FROM character WHERE character.name = <character_name>

-- Buscar o nome da profissão de um personagem através de seu nome.
SELECT 
  craft.name
FROM 
  character
INNER JOIN craft ON craft.id = character.craft
WHERE character.name = <character_name>

-- Buscar todos o id, nome, gênero, data de criação, nível e score dos personagens de um usuário a partir de seu e-mail.
SELECT 
  character.name, 
  character.id, 
  character.genre, 
  character.created_at, 
  character.level, 
  character.score 
FROM account INNER JOIN character ON character.account = account.id 
WHERE account.email=<user_email>

-- Buscar o jogador mais antigo
SELECT account.name, account.created_at FROM account ORDER BY account.created_at ASC LIMIT 1;

-- Buscar os atributos base de um personagem por nome
SELECT attribute.* FROM character INNER JOIN attribute ON attribute.id = character.attribute WHERE character.name = <character_name>
