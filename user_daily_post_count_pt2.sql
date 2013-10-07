delimiter //
drop procedure if exists user_daily_post_count_pt2//
truncate table v_user_daily_post_count_pt2//
create procedure user_daily_post_count_pt2 ( )
begin
    DECLARE v_user_id  int default 0;
    DECLARE stop  int default 0;
    DECLARE cursor_id CURSOR FOR select id from users where reputation > 3000 and DATEDIFF(last_access_date, creation_date)>360 order by email_hash limit 0,1000;
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET stop=1;
    OPEN cursor_id;
    FETCH cursor_id INTO v_user_id;
    while stop <> 1 do
        insert into v_user_daily_post_count_pt2 (user_id,date,post_count)
            select v_user_id,creation_date,count(*) from posts where owner_user_id = v_user_id group by creation_date;
        FETCH cursor_id INTO v_user_id;
    end while;
end//
call user_daily_post_count_pt2()//