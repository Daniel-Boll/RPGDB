-- Function to do updated_at
CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER set_timestamp
BEFORE UPDATE ON account
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

-- Trigger de adicionar item da profissão no inventário de um novo personagem
CREATE OR REPLACE FUNCTION add_item()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO inventory_item (inventory, item, amount) VALUES (
    NEW.inventory, 
    (select item from craft_item where craft = NEW.craft),
    1
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER add_item_from_craft_to_inventory
AFTER INSERT ON character
FOR EACH ROW
WHEN (NEW.craft IS NOT NULL)
EXECUTE PROCEDURE add_item();
