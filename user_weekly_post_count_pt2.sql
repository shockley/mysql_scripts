delimiter //
truncate table v_debug//
drop procedure if exists user_weekly_post_count_2//
create procedure user_weekly_post_count_2 ( )
root:begin
    DECLARE v_user_id  int default 0;
    DECLARE v_reg_date DATE default '1900-01-01';
    DECLARE v_temp_date  DATE default '1900-01-01';
    DECLARE v_week  int default 0;
    DECLARE v_week_post_count  int default 0;
    DECLARE stop  int default 0;
    
    DECLARE cursor_id CURSOR FOR select DISTINCT user_id from v_user_daily_post_count_pt2;
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET stop=1;
    OPEN cursor_id;
    FETCH cursor_id INTO v_user_id;
    while stop <> 1 do
        #get the a user_s registration and last_active date
        # if theyre null, set a noticiable value and terminate
        select creation_date into v_reg_date from users where id = v_user_id;
        if v_reg_date is null then
            insert into v_debug (thekey,value) values ("v_reg_date",v_reg_date);
            set v_reg_date = '2099-01-01';
            LEAVE root;
        end if;
        

        set v_temp_date = v_reg_date;
        
        # we only counts 52*7 days
        while v_week < 52 do
                
            set v_week = v_week + 1;
            #get the 30 day period post count
            select sum(post_count) into v_week_post_count from v_user_daily_post_count_pt2 where user_id = v_user_id and date >= v_temp_date and date < DATE_ADD(v_temp_date, INTERVAL 7 DAY);
            if v_week_post_count is null then
                set v_week_post_count = 0;
            end if;

            insert into v_user_weekly_post_count_pt2 (user_id,week,post_count) values (v_user_id,v_week,v_week_post_count);
                
            set v_temp_date = DATE_ADD(v_temp_date, INTERVAL 7 DAY);
            
        end while;

        set v_week = 0;
        FETCH cursor_id INTO v_user_id;
    end while;
end//
call user_weekly_post_count_2()//
