UPDATE v_user_daily_post_count a 
SET a.registration_date = (SELECT c.creation_date 
FROM users c 
WHERE c.id = a.user_id); 

UPDATE v_user_daily_post_count set day = DATEDIFF(date, registration_date);