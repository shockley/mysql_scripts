#get a top user
#select * from users where reputation > 10000 limit 0,5;
# suppose 12541
#select count(*) from posts where owner_user_id = 12541; #183
delimiter //
drop procedure if exists build_personal_network//
drop procedure if exists answer_network//
create procedure answer_network ()
begin
    DECLARE v_answerer_id int default 12541;
    DECLARE stop int default 0;
    DECLARE v_answer_id int default 0;
    DECLARE v_question_id int default 0;
# select id, parent_id of all his answers into v_answer_id, v_question_id
	DECLARE cursor1 CURSOR FOR select id, parent_id from posts where owner_user_id = v_answerer_id && post_type_id = 2;    
	DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET stop=1;
	OPEN cursor1;
    FETCH cursor1 INTO v_answer_id, v_question_id;
    while stop <> 1 do
        #select the row by v_question_id
        insert into v_qa_network (questioner_id,answerer_id,question_id,answer_id)
            select owner_user_id, v_answerer_id, v_question_id, v_answer_id  from posts where id = v_question_id;
        #insert into v_tags (description) values ("aaaaaaa");
        FETCH cursor1 INTO v_answer_id, v_question_id;
    end while;
    CLOSE cursor1;
end //
drop procedure if exists question_network//
create procedure question_network ()
begin
    DECLARE v_questioner_id int default 12541;
    DECLARE v_question_id int default 0;
    DECLARE stop int default 0;
-- select all his questions
    DECLARE cursor2 CURSOR FOR select id from posts where owner_user_id = v_questioner_id && post_type_id = 1;
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET stop=1;
    OPEN cursor2;
    FETCH cursor2 INTO v_question_id;
    while stop <> 1 do
-- select all answers whose parent is v_question_id
        insert into v_qa_network (questioner_id,answerer_id,question_id,answer_id)
            select v_questioner_id, owner_user_id, v_question_id, id  from posts where parent_id = v_question_id;
        #insert into v_tags (description) values ("aaaaaaa");
        FETCH cursor2 INTO v_question_id;
    end while;
    CLOSE cursor2;
end //
#call answer_network()//
call question_network()//