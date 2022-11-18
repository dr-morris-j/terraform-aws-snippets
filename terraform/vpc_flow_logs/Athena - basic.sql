Athena -

# Table creation

CREATE EXTERNAL TABLE IF NOT EXISTS default.vpc_flow_logs1 (
  version int,
  account string,
  interfaceid string,
  sourceaddress string,
  destinationaddress string,
  sourceport int,
  destinationport int,
  protocol int,
  numpackets int,
  numbytes bigint,
  starttime int,
  endtime int,
  action string,
  logstatus string
)  
PARTITIONED BY (dt string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ' '
LOCATION 's3://vpc-flowlogs-test123456/AWSLogs/155468627204/vpcflowlogs/us-east-1/'
TBLPROPERTIES ("skip.header.line.count"="1");

++++++++++
ALTER TABLE default.vpc_flow_logs1
ADD PARTITION (dt='2022-11-16')
location 's3://vpc-flowlogs-test123456/AWSLogs/155468627204/vpcflowlogs/us-east-1/2022/11/16';

++++++++++++++++++
SELECT day_of_week(from_iso8601_timestamp(dt)) AS
  day,
  dt,
  interfaceid,
  sourceaddress,
  destinationport,
  action,
  protocol
FROM vpc_flow_logs
WHERE action = 'REJECT' AND protocol = 6
order by sourceaddress
LIMIT 100;