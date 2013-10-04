# this is how v_qa_network gets created
truncate table v_qa_network;
insert into v_qa_network (answerer_id,questioner_id,answer_id,question_id,answer_date,question_date) 
select a.owner_user_id,q.owner_user_id,a.id,q.id,a.creation_date,q.creation_date from posts q, posts a where a.post_type_id = 2 && a.creation_date >= '2012-05-01' && a.parent_id = q.id && q.creation_date >= '2012-03-01';