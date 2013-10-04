create table common_proj(
id INTEGER(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
softpedia_id INTEGER(11),
softpedia_name varchar(255),
sourceforge_id INTEGER(11),
sourceforge_short_name varchar(255),
sourceforge_real_name varchar(2000)
);

mysql> show columns in softpedia_proj;
+-------------+--------------+------+-----+---------+-------+
| Field       | Type         | Null | Key | Default | Extra |
+-------------+--------------+------+-----+---------+-------+
| name        | varchar(255) | YES  | MUL | NULL    |       |
| id          | int(11)      | NO   | PRI | NULL    |       |
| url         | varchar(255) | YES  |     | NULL    |       |
| html        | text         | YES  |     | NULL    |       |
| category    | varchar(255) | YES  |     | NULL    |       |
| description | text         | YES  |     | NULL    |       |
+-------------+--------------+------+-----+---------+-------+

mysql> show columns in sourceforge_proj;
+-----------------+------------------+------+-----+---------------------+----------------+
| Field           | Type             | Null | Key | Default             | Extra         |
+-----------------+------------------+------+-----+---------------------+----------------+
| proj_short_name | varchar(1000)    | NO   | MUL | NULL                |         |
| proj_id         | int(10) unsigned | NO   | PRI | NULL                | auto_increment |
| forge_id        | int(11)          | NO   | MUL | 0                   |         |
| url             | varchar(1000)    | YES  | MUL | NULL                |         |
| html            | mediumtext       | YES  |     | NULL                |         |
| date_collected  | datetime         | YES  |     | 0000-00-00 00:00:00 |         |
| page_index      | int(11)          | YES  |     | NULL                |         |
| proj_real_name  | varchar(2000)    | YES  | MUL | NULL                |         |
+-----------------+------------------+------+-----+---------------------+----------------+

create index name on softpedia_proj (name);

select count(*) from softpedia_proj where name = "";


insert into common_proj(softpedia_id,softpedia_name,sourceforge_id,sourceforge_short_name,sourceforge_real_name) 
				values (1,'a',1,'a','a')//
				