安装前准备
yum -y install gcc*
yum -y install libc*
yum -y install vim

*安装
1、下载，解压，编译:

wget http://download.redis.io/releases/redis-3.0.6.tar.gz
tar xzf redis-3.0.6.tar.gz
cd redis-3.0.6
make MALLOC=libc
make install

# 服务脚本安装在：/usr/local/bin/目录下

# 然后用客户端测试一下是否启动成功。
# $ redis-cli
# redis> set foo bar
# OK
# redis> get foo
# "bar"
# redis> ping
# PONG

# 上面的提示127.0.0.1是本机的IP地址，6379为Redis服务器运行的端口。


# 2、编译完成后，在Src目录下，有四个可执行文件redis-server、redis-benchmark、redis-cli和redis.conf。然后拷贝到一个目录下。

cp -rf /root/redis/redis-cluster /usr/local/

# 节点一
mkdir -p /usr/local/redis-cluster/redis-node1/bin/
mkdir -p /usr/local/redis-cluster/redis-node1/logs/
mkdir -p /usr/local/redis-cluster/redis-node1/conf/

# 节点二
mkdir -p /usr/local/redis-cluster/note2/bin/
mkdir -p /usr/local/redis-cluster/note2/logs/
mkdir -p /usr/local/redis-cluster/note2/conf/

# 节点三
mkdir -p /usr/local/redis-cluster/redis-node3/bin/
mkdir -p /usr/local/redis-cluster/redis-node3/logs/
mkdir -p /usr/local/redis-cluster/redis-node3/conf/

#修改配置文件redis.conf
##修改配置文件中的下面选项
port 7000
daemonize yes
cluster-enabled yes
cluster-config-file nodes.conf #指定配置文件路径
cluster-node-timeout 5000
appendonly yes
dir ./  #指定数据库存放路径

cd /root/redis/redis-cluster


# 添加自启动服务
cp redis-node* /etc/init.d/
cp redis-cluster /etc/init.d/

/sbin/chkconfig --add redis-node1
/sbin/chkconfig --add redis-node2
/sbin/chkconfig --add redis-node3
/sbin/chkconfig redis-node1 on
/sbin/chkconfig redis-node2 on
/sbin/chkconfig redis-node3 on

/sbin/chkconfig --add redis-cluster
/sbin/chkconfig redis-cluster on

service redis-cluster restart

# 启动redis
# /usr/local/redis-cluster/note1/bin/redis-server /usr/local/redis-cluster/note1/conf/redis.conf
# /usr/local/redis-cluster/note2/bin/redis-server /usr/local/redis-cluster/note2/conf/redis.conf
# /usr/local/redis-cluster/note3/bin/redis-server /usr/local/redis-cluster/note3/conf/redis.conf

# cluster meet 10.0.13.100 6381
# cluster meet 10.0.13.100 6382
# cluster meet 10.0.13.100 6383


# 添加节点服务

redis-cli -p 6381
$ 10.0.13.100:6381>  cluster meet 10.0.13.100 6382
$ 10.0.13.100:6381>  cluster meet 10.0.13.100 6383

cd /usr/local/redis-cluster

# 编辑redis-node1
vim redis-node1/conf/nodes.conf
# 在 myself,master - 0 0 connected 行结尾增加 0-5000

# 编辑redis-node2
vim redis-node3/conf/nodes.conf
# 在 myself,master - 0 0 connected 行结尾增加 5001-10000

# 编辑redis-node3
vim redis-node3/conf/nodes.conf
# 在 myself,master - 0 0 connected 行结尾增加 10001-16383

#重启服务
service redis-cluster restart

# 错误信息：(error) MOVED 12182 10.0.13.100:6383

# 启动集群模式(即缺少了那个"-c") 

redis-cli -c -h 10.0.13.100 -p 6381
