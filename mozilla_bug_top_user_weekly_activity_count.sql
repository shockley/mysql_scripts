delimiter //
drop procedure if exists user_weekly_activity_count//
truncate table v_user_weekly_activity_count//
create procedure user_weekly_activity_count ( )
root:begin
    DECLARE v_user_id  int default 0;
    DECLARE stop  int default 0;
    DECLARE v_reg_date DATE default '1900-01-01';
    DECLARE v_temp_date  DATE default '1900-01-01';
    DECLARE v_week  int default 0;
    DECLARE v_week_activity_count  int default 0;
    DECLARE cursor_id CURSOR FOR select who from v_dev_rank_by_activity_count r, profiles p where r.bug_activity_count > 400 and r.who = p.userid and p.creation_ts >= '2006-01-01 00:00:00' order by p.cryptpassword limit 0,500;
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET stop=1;
    OPEN cursor_id;
    FETCH cursor_id INTO v_user_id;
    
    while stop <> 1 do
        # get the a user_s registration
        # if theyre null, set a noticiable value and terminate
        select DATE(creation_ts) into v_reg_date from profiles where userid = v_user_id;
        if v_reg_date is null then
            insert into v_debug (thekey,value) values ("v_reg_date",v_reg_date);
            set v_reg_date = '2099-01-01';
            LEAVE root;
        end if;
        

        set v_temp_date = v_reg_date;
        
        # we only counts 7*52 days
        while v_week < 52 do
                
            set v_week = v_week + 1;
            #get the 7 day period activity count
            select COUNT(*) into v_week_activity_count from bugs_activity where who = v_user_id and DATE(bug_when) >= v_temp_date and DATE(bug_when) < DATE_ADD(v_temp_date, INTERVAL 7 DAY);
            if v_week_activity_count is null then
                set v_week_activity_count = 0;
            end if;

            insert into v_user_weekly_activity_count (user_id,week,activity_count) values (v_user_id,v_week,v_week_activity_count);
                
            set v_temp_date = DATE_ADD(v_temp_date, INTERVAL 7 DAY);
            
        end while;

        set v_week = 0;
        FETCH cursor_id INTO v_user_id;
    end while;
end//

call user_weekly_activity_count()//