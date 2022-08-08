do $$
declare  
 user_characters_count integer;
begin
 select count(*)
 into user_characters_count
 from account join character ON character.account = account.id;
 assert user_characters_count <= 3, 'More then 3 characters in this user';
end$$;
