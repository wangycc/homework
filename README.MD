# Homework

make docker

# Preference

- docker
- docker-compose
- make

# compile

```bash
$ make install
$ make setup 
$ make deploy
```


#生产环节高可用架构
###方案1： 公有云及私有云基础设施
- 基础设置


EC2/ECS作为服务运行平台，SLB/ELB提供前端入口流量，可提供后端服务横向扩展，容量伸缩。通过VPC方式隔离网络保证内外网安全性。

- 日志
	1. 可采用云厂商提供的日志系统(费用高，运维方便)
	2. 独立开发日志系统或者基于开源解决方案。日志可随着业务的规模扩大，可进行统一的日志采集(ELK+kafka),filebeat采集日志写入kafka，logstash作为consumer读取日志写入elasticsearch最终通过kibana绘图展示.对于需要数据分析的日志可通过写入HDFS作为冷数据保存。

- 监控及报警

可采用Prometheus 作为监控系统及报警系统.可提供目标target的SD服务发现功能，可报警指slak，或者通过webhook报警至钉钉微信。

- ingress

 入口采用nginx webserver作为入口流量，保证静态服务的高并发性及无状态服务快速扩展。
 
 

2 基于于Kubernetes的容器编排解决方案
容器化,围绕kubernetes实现服务动态横向扩展、弹性伸缩、HA、日志、监控、trace内部调用跟踪、CI/CD等解决方案。


