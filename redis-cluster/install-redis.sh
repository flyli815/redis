��װǰ׼��
yum -y install gcc*
yum -y install libc*
yum -y install vim

*��װ
1�����أ���ѹ������:

wget http://download.redis.io/releases/redis-3.0.6.tar.gz
tar xzf redis-3.0.6.tar.gz
cd redis-3.0.6
make MALLOC=libc
make install

# ����ű���װ�ڣ�/usr/local/bin/Ŀ¼��

# Ȼ���ÿͻ��˲���һ���Ƿ������ɹ���
# $ redis-cli
# redis> set foo bar
# OK
# redis> get foo
# "bar"
# redis> ping
# PONG

# �������ʾ127.0.0.1�Ǳ�����IP��ַ��6379ΪRedis���������еĶ˿ڡ�


# 2��������ɺ���SrcĿ¼�£����ĸ���ִ���ļ�redis-server��redis-benchmark��redis-cli��redis.conf��Ȼ�󿽱���һ��Ŀ¼�¡�

cp -rf /root/redis/redis-cluster /usr/local/

# �ڵ�һ
mkdir -p /usr/local/redis-cluster/redis-node1/bin/
mkdir -p /usr/local/redis-cluster/redis-node1/logs/
mkdir -p /usr/local/redis-cluster/redis-node1/conf/

# �ڵ��
mkdir -p /usr/local/redis-cluster/note2/bin/
mkdir -p /usr/local/redis-cluster/note2/logs/
mkdir -p /usr/local/redis-cluster/note2/conf/

# �ڵ���
mkdir -p /usr/local/redis-cluster/redis-node3/bin/
mkdir -p /usr/local/redis-cluster/redis-node3/logs/
mkdir -p /usr/local/redis-cluster/redis-node3/conf/

#�޸������ļ�redis.conf
##�޸������ļ��е�����ѡ��
port 7000
daemonize yes
cluster-enabled yes
cluster-config-file nodes.conf #ָ�������ļ�·��
cluster-node-timeout 5000
appendonly yes
dir ./  #ָ�����ݿ���·��

cd /root/redis/redis-cluster


# �������������
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

# ����redis
# /usr/local/redis-cluster/note1/bin/redis-server /usr/local/redis-cluster/note1/conf/redis.conf
# /usr/local/redis-cluster/note2/bin/redis-server /usr/local/redis-cluster/note2/conf/redis.conf
# /usr/local/redis-cluster/note3/bin/redis-server /usr/local/redis-cluster/note3/conf/redis.conf

# cluster meet 10.0.13.100 6381
# cluster meet 10.0.13.100 6382
# cluster meet 10.0.13.100 6383


# ��ӽڵ����

redis-cli -p 6381
$ 10.0.13.100:6381>  cluster meet 10.0.13.100 6382
$ 10.0.13.100:6381>  cluster meet 10.0.13.100 6383

cd /usr/local/redis-cluster

# �༭redis-node1
vim redis-node1/conf/nodes.conf
# �� myself,master - 0 0 connected �н�β���� 0-5000

# �༭redis-node2
vim redis-node3/conf/nodes.conf
# �� myself,master - 0 0 connected �н�β���� 5001-10000

# �༭redis-node3
vim redis-node3/conf/nodes.conf
# �� myself,master - 0 0 connected �н�β���� 10001-16383

#��������
service redis-cluster restart

# ������Ϣ��(error) MOVED 12182 10.0.13.100:6383

# ������Ⱥģʽ(��ȱ�����Ǹ�"-c") 

redis-cli -c -h 10.0.13.100 -p 6381
