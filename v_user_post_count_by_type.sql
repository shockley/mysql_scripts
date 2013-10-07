delimiter //
drop procedure if exists get_user_postcount//
create procedure get_user_postcount ()
begin
	DECLARE v_post_count int default 0;
    DECLARE v_type1_count int default 0;
    DECLARE v_type2_count int default 0;
    DECLARE v_type3_count int default 0;
    DECLARE v_type4_count int default 0;
    DECLARE v_type5_count int default 0;
    DECLARE v_type6_count int default 0;
    DECLARE v_type7_count int default 0;
    DECLARE v_userid int default 0;
    DECLARE v_reputation int default 0;
    DECLARE v_from_date date default  '2012-04-01';
    DECLARE v_to_date date default  '2012-07-09';

    DECLARE stop int default 0;
	DECLARE cursor_id CURSOR FOR select id,reputation from users where reputation < 100 and id > 0 limit 0,1000;#and creation_date < v_from_date and last_access_date > v_to_date 
	DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET stop=1; 
	OPEN cursor_id;
	FETCH cursor_id INTO v_userid,v_reputation;
	while stop <> 1 do
        select count(*) into v_post_count from posts where owner_user_id = v_userid;#and creation_date >= v_from_date and creation_date <= v_to_date;
        select count(*) into v_type1_count from posts where owner_user_id = v_userid and post_type_id = 1;#and creation_date >= v_from_date and creation_date <= v_to_date;
        select count(*) into v_type2_count from posts where owner_user_id = v_userid and post_type_id = 2;#and creation_date >= v_from_date and creation_date <= v_to_date;
        select count(*) into v_type3_count from posts where owner_user_id = v_userid and post_type_id = 3;#and creation_date >= v_from_date and creation_date <= v_to_date;
        select count(*) into v_type4_count from posts where owner_user_id = v_userid and post_type_id = 4;#and creation_date >= v_from_date and creation_date <= v_to_date;
        select count(*) into v_type5_count from posts where owner_user_id = v_userid and post_type_id = 5;#and creation_date >= v_from_date and creation_date <= v_to_date;
        select count(*) into v_type6_count from posts where owner_user_id = v_userid and post_type_id = 6;#and creation_date >= v_from_date and creation_date <= v_to_date;
        select count(*) into v_type7_count from posts where owner_user_id = v_userid and post_type_id = 7;#and creation_date >= v_from_date and creation_date <= v_to_date;
        insert into v_user_post_count_by_type set 
            user_id = v_userid,
            reputation = v_reputation,#from_date = v_from_date, to_date = v_to_date,
            post_count = v_post_count, type1_count = v_type1_count, type2_count = v_type2_count, type3_count = v_type3_count, type4_count = v_type4_count, type5_count = v_type5_count, type6_count = v_type6_count, type7_count = v_type7_count;
        FETCH cursor_id INTO v_userid,v_reputation;
     end while;
     CLOSE cursor_id;
end//
call get_user_postcount()//