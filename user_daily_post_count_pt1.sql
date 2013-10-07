delimiter //
drop procedure if exists user_daily_post_count//
truncate table v_user_daily_post_count//
create procedure user_daily_post_count ( )
begin
    DECLARE v_user_id  int default 0;
    DECLARE stop  int default 0;
    DECLARE cursor_id CURSOR FOR select id from users where reputation > 50000 and creation_date > '2010-01-01';
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET stop=1;
    OPEN cursor_id;
    FETCH cursor_id INTO v_user_id;
    while stop <> 1 do
        insert into v_user_daily_post_count (user_id,date,post_count)
            select v_user_id,creation_date,count(*) from posts where owner_user_id = v_user_id group by creation_date;
        FETCH cursor_id INTO v_user_id;
    end while;
end//
call user_daily_post_count()//