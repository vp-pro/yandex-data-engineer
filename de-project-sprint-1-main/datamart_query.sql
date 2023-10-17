insert into de.analysis.dm_rfm_segments (user_id, recency, frequency, monetary_value)
 select * from de.analysis.tmp_rfm_recency
 join de.analysis.tmp_rfm_frequency using(user_id)
 join de.analysis.tmp_rfm_monetary_value using(user_id)

user_id, recency, frequency, monetary_value
0	1	3	4
1	4	3	3
2	2	3	5
3	2	4	3
4	4	3	3
5	5	5	5
6	1	3	5
7	4	3	2
8	1	1	3
9	1	2	2