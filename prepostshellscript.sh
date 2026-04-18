#!/bin/bash
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
################################################ #########################################################
# Linux Server Info Gathering SCript
# Date : 25 Nov 2020  ## Version : 1.0
# This script will gather required server configuration detail from source server marked for Migration from existing DC to Wipro DC#
# How to run the script ##
# AUTHOR : Bhushan Mane
# Please type "sh LinuxServer_InfoGathering.sh(scriptname) precheck" to collect source server information
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#

#------------------------------------------#
#Variable declaration
DIR=/tmp
cd $DIR
if  [ ! -d $DIR/Linux_info/log ] ; then
mkdir -p $DIR/Linux_info/log
fi

CHKLOG=$DIR/Linux_info/log/SER_info
DAY=$(date)
F_CHK=0;
#------------------------------------------#

# Collecting INFO

getinfo()
{
E_DIS="____________________________________________________________________________________________________________"
if  [ ! -d $DIR/Linux_info/INFO ] ; then
mkdir $DIR/Linux_info/INFO
fi
if  [ ! -d $DIR/Linux_info/BKP ] ; then
mkdir $DIR/Linux_info/BKP
fi

LOG=$DIR/Linux_info/INFO/ser_info_`hostname`
cp /dev/null $LOG

        echo "INFO collected on $DAY" >> $LOG; echo $E_DIS >> $LOG
                echo "HOSTNAME" >> $LOG; hostname -s >> $LOG;echo $E_DIS >> $LOG
                echo "DOMAIN" >> $LOG; hostname -d >> $LOG;echo $E_DIS >> $LOG
                echo "Server Uptime" >> $LOG; uptime >> $LOG;echo $E_DIS >> $LOG
        echo "OS VERSION :" >> $LOG;cat /etc/redhat-release 2>/dev/null >> $LOG;echo $E_DIS >> $LOG;cat /etc/os-release  >> $LOG;echo $E_DIS >> $LOG
                echo "DNS" >> $LOG; cat /etc/resolv.conf | grep -v ^# >> $LOG;echo $E_DIS >> $LOG
                echo "NTP" >> $LOG; cat /etc/ntp.conf 2>/dev/null | grep -v ^# >> $LOG;echo $E_DIS >> $LOG
                echo "Chrony" >> $LOG; cat /etc/chrony.conf 2>/dev/null | grep -v ^# >> $LOG;echo $E_DIS >> $LOG
                echo "### NTP Status" >> $LOG; ntpq -p 2>/dev/null | grep -v ^# >> $LOG;echo $E_DIS >> $LOG
                echo "### Chrony Status" >> $LOG; chronyc  tracking 2>/dev/null | grep -v ^# >> $LOG;echo $E_DIS >> $LOG
                echo "Cron Jobs" >> $LOG; crontab -l 2>/dev/null >> $LOG;echo $E_DIS >> $LOG
                echo "SUDO detail" >> $LOG;cat /etc/sudoers |grep -v ^# >> $LOG;echo $E_DIS >> $LOG
                echo "NetworkGlobalSetting" >> $LOG; cat /etc/sysconfig/network 2>/dev/null | grep -v ^# >> $LOG;echo $E_DIS >> $LOG
                echo "Local HOST Entry" >> $LOG; cat /etc/hosts | grep -v ^# >> $LOG;echo $E_DIS >> $LOG

        echo "Kernel Version" : >> $LOG;uname -a  >> $LOG;echo $E_DIS >> $LOG
        echo "PROCESSOR DETAILS :" >> $LOG;cat /proc/cpuinfo >> $LOG;echo $E_DIS >> $LOG
        echo "PROCESSOR Count :" >> $LOG;cat /proc/cpuinfo | grep -i processor  |wc -l >> $LOG
        echo "Online PROCESSOR :" >> $LOG;lscpu |grep -i 'On-line CPU(s) list'|cut -d ":" -f2 >> $LOG
        echo "SHORT MEMORY INFO :" >> $LOG;free -m >> $LOG;echo $E_DIS  >> $LOG;echo >> $LOG
                echo "MEMORY DETAILS :" >> $LOG;cat /proc/meminfo >> $LOG;echo $E_DIS  >> $LOG;echo >> $LOG
                echo "SWAP DETAILS :" >> $LOG;swapon -s >> $LOG;echo $E_DIS  >> $LOG;echo >> $LOG
        echo "DF OUPTUT :" >> $LOG;df >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
        echo "MOUNT OUTPUT :" >> $LOG;mount >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
        echo "MOUNT Count :" >> $LOG;mount | wc -l >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
        echo "FSTAB output :" >> $LOG;cat /etc/fstab >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
        echo "NFS_CIFS_MNT OUTPUT :" >> $LOG;df -hT |grep -i 'cifs|nfs' >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
        echo "LIST BLOCK DISK :" >> $LOG;lsblk >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
                echo "LAST BOOT OUTPUT :" >> $LOG;last|grep 'boot'  >> $LOG;echo $E_DIS >> $LOG ;echo >> $LOG
        echo "LVM Detailed INFORMATION :" >> $LOG;echo "---$volumegroup$:---" >> $LOG;vgs |awk '{print$1}' >> $LOG;echo $E_DIS >> $LOG;echo "---Active VG:---" >> $LOG;vgdisplay -A |grep 'VG Name'|awk '{print$3}' >> $LOG;echo $E_DIS >> $LOG;echo "Deatail of VG & LV's:"  >> $LOG;vgs -a -o +devices >> $LOG;echo $E_DIS >> $LOG;echo "" >> $LOG;lvs -a -o +devices >> $LOG;echo $E_DIS >> $LOG;vgdisplay -v >> $LOG;echo $E_DIS >> $LOG;lvdisplay >> $LOG;echo $E_DIS >> $LOG ;echo >> $LOG;pvdisplay >> $LOG;echo $E_DIS >> $LOG;

        echo "PhysicalVolume OUTPUT :" >> $LOG;pvs >> $LOG;echo $E_DIS >> $LOG ;echo >> $LOG
        echo "Filesystems :" >> $LOG;df -hT | grep -v tmpfs >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
                echo "Filesystems Count:" >> $LOG;df -hT | grep -v tmpfs | wc -l >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
                echo "Mount Point permission :" >> $LOG;for i in `df -hT | grep -v tmpfs | awk '{print $7}'| grep -v Mounted`;do ls -ld $i;done >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
                echo "LSPath :" >> $LOG;multipath -ll 2>/dev/null >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
        echo "LSPath Count:" >> $LOG;multipath -ll 2>/dev/null |grep 'dm-' | wc -l >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
        echo "IP ADDRESS DETAILS :" >> $LOG;ifconfig -a 2>/dev/null >> $LOG;echo $E_DIS  >> $LOG;echo >> $LOG
        echo "ROUTE DETAILS :" >> $LOG;netstat -nr 2>/dev/null >> $LOG;echo $E_DIS  >> $LOG;echo >> $LOG
        echo "INTERFACE DETAILS :" >> $LOG;netstat -i 2>/dev/null >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
        echo "Network ADPTERS DETAILS :" >> $LOG;lspci |grep -i 'Ethernet' >> $LOG;echo $E_DIS >> $LOG ;echo >> $LOG
                echo "HBA Adapter DETAILS :" >> $LOG;lspci |egrep -i 'Fibre|qlogic|emulex' >> $LOG;echo $E_DIS >> $LOG ;echo >> $LOG
                echo "WWN Detail :" >> $LOG;cat /sys/class/fc_host/host*/node_name  2>/dev/null >> $LOG;echo $E_DIS >> $LOG ;echo >> $LOG
        echo "PHYSICAL ADAPTER DETAILS :" >> $LOG;lspci >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
        echo "SElinux output :" >> $LOG;getenforce 2>/dev/null >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
                echo "SElinux detailed output :" >> $LOG;sestatus -v 2>/dev/null >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
        echo "IPtables output :" >> $LOG;iptables -L >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
                echo "IPTable Rules:" >> $LOG;iptables-save 2>/dev/null >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
        echo "Kernel module :" >> $LOG;lsmod >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
                echo "Kernel Parameter :" >> $LOG;sysctl -a 2>/dev/null >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG

                ## SAR Report ##
                echo "SAR Report" >>$LOG ;sar >>$LOG;echo $E_DIS  >> $LOG;echo >> $LOG
                echo "SAR Disk Report" >>$LOG ;sar -d >>$LOG;echo $E_DIS  >> $LOG;echo >> $LOG
                echo "SAR Memory Usage report" >>$LOG ;sar -r 2 5 >>$LOG;echo $E_DIS  >> $LOG;echo >> $LOG
                echo "SAR CPU Usage report" >>$LOG ;sar 2 5 >>$LOG; echo $E_DIS  >> $LOG;echo >> $LOG
                echo "SAR Network statistic Report" >>$LOG ;sar -n ALL >>$LOG;echo $E_DIS  >> $LOG;echo >> $LOG
                echo "SAR Paging Statistics Report" >>$LOG ;sar -B 2 5 >>$LOG;echo $E_DIS  >> $LOG;echo >> $LOG
                echo "Network interfaces details:" >> $LOG; ls -l /sys/class/net/ | grep -v lo | awk '{print $9}' 2>/dev/null >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
                echo "Network Detail :" >> $LOG;cat /etc/sysconfig/network-scripts/ifcfg-* 2>/dev/null >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
                echo "Network Detail :" >> $LOG;cat /etc/sysconfig/network/ifcfg-* 2>/dev/null >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
                echo "NETWORK BOND-0 :" >> $LOG;cat /proc/net/bonding/bond0 2>/dev/null >> $LOG;echo $E_DIS  >> $LOG;echo >> $LOG
                echo "NETWORK BOND-1 :" >> $LOG;cat /proc/net/bonding/bond1 2>/dev/null >> $LOG;echo $E_DIS  >> $LOG;echo >> $LOG
                echo "NETWORK BOND-2 :" >> $LOG;cat /proc/net/bonding/bond2 2>/dev/null >> $LOG;echo $E_DIS  >> $LOG;echo >> $LOG
                echo "NETWORK BOND-3 :" >> $LOG;cat /proc/net/bonding/bond3 2>/dev/null >> $LOG;echo $E_DIS  >> $LOG;echo >> $LOG
                echo "PORT DETAILS :" >> $LOG;netstat -tulpn 2>/dev/null >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG

                ## Cluster Information ##
        echo "Pacemaker service :" >> $LOG;service pcsd status 2>/dev/null >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
                echo "RHEL Pacemaker info :" >> $LOG; pcs cluster status 2>/dev/null >> $LOG;echo $E_DIS >> $LOG; pcs status --full 2>/dev/null >> $LOG;echo $E_DIS >> $LOG; pcs resource 2>/dev/null >> $LOG; echo $E_DIS >> $LOG; pcs resource agents 2>/dev/null >> $LOG; echo $E_DIS >> $LOG;echo >> $LOG
                echo "CIB detail :" >> $LOG; cat /var/lib/pacemaker/cib/cib.xml 2>/dev/null >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG

        echo "Pacemaker service :" >> $LOG;service pacemaker status 2>/dev/null >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
        echo "SUSE Pacemaker info :" >> $LOG; crm_mon -1 2>/dev/null >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
                echo "SUSE Cluster Status" >> $LOG;crm cluster status 2>/dev/null >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
                echo "SUSE Cluster Node List" >> $LOG;crm node list 2>/dev/null >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
                echo "SUSE Cluster Node Status" >> $LOG;crm node status 2>/dev/null >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
                echo "SUSE Cluster config" >> $LOG;crm configure show 2>/dev/null >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
                echo "csync2 detail :" >> $LOG; cat /etc/csync2/csync2.cfg 2>/dev/null >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
                echo "corosync detail :" >> $LOG; cat /etc/corosync/corosync.conf 2>/dev/null >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
                echo "SBD detail :" >> $LOG; cat /etc/sysconfig/sbd 2>/dev/null >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG

                ## Added in the last, due to Long output ##
        echo "All Service List" >> $LOG;chkconfig --list 2>/dev/null >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
                echo "All List" >> $LOG;systemctl list-units 2>/dev/null >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
                echo "All Service List :" >> $LOG;systemctl list-units --type service 2>/dev/null >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
                echo "All Running List :" >> $LOG;systemctl list-units | egrep -i "running|DESCRIPTION" 2>/dev/null >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
                echo "Local disk details :" >> $LOG; iostat -xtc 2>/dev/null >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
                echo "Disk, Memory,CPU details :" >> $LOG; vmstat 2 5 2>/dev/null >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
                echo "Local disk details :" >> $LOG; fdisk -l | egrep -i "/dev/sd|/dev/hd|/dev/xvd|/dev/vd" | grep Disk|awk '{print $2,$3,$4}' 2>/dev/null >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG

                echo "dmesg Error Logs:" >> $LOG; dmesg | egrep -i 'err|down|fail|warn|faulty|critical|fatal' 2>/dev/null >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
                echo "messages Error Logs:" >> $LOG; cat /var/log/messages | egrep -i 'err|down|fail|warn|faulty|critical|fatal' 2>/dev/null >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
                echo "Boot Error Logs:" >> $LOG; cat /var/log/boot.log | egrep -i 'err|down|fail|warn|faulty|critical|fatal' 2>/dev/null >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG

                echo "last installed package :" >> $LOG;rpm -qa --last >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
            echo "Total Installed package :" >> $LOG;rpm -qa --last |wc -l >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
                echo "Running Processes" >> $LOG; ps -ef >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
                echo "Processes running by Non-root User" >> $LOG;ps -ef | grep -v root >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG
        echo "dmesg output" >> $LOG;dmesg >> $LOG;echo $E_DIS >> $LOG;echo >> $LOG

                echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" >> $LOG
                echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" >> $LOG
                echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" >> $LOG
                echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" >> $LOG
                echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" >> $LOG

cp -p /etc/passwd $DIR/Linux_info/BKP/  2>/dev/null
cp -p /etc/group $DIR/Linux_info/BKP/  2>/dev/null
cp -p /etc/sudoers $DIR/Linux_info/BKP/  2>/dev/null
cp -p /etc/openldap/ldap.conf $DIR/Linux_info/BKP/  2>/dev/null
cp -p /etc/ldap.conf $DIR/Linux_info/BKP/  2>/dev/null
cp -p /etc/openldap/cacerts/ca.cert.pem $DIR/Linux_info/BKP/  2>/dev/null
cp -p /etc/ssh/sshd_config $DIR/Linux_info/BKP/  2>/dev/null

cp -p /etc/sssd/sssd.conf $DIR/Linux_info/BKP/  2>/dev/null
cp -p /etc/krb5.conf $DIR/Linux_info/BKP/  2>/dev/null
cp -p /etc/samba/smb.conf $DIR/Linux_info/BKP/  2>/dev/null
cp -p /etc/exports $DIR/Linux_info/BKP/  2>/dev/null

cp -p /etc/csync2/csync2.cfg $DIR/Linux_info/BKP/  2>/dev/null
cp -p /etc/corosync/corosync.conf $DIR/Linux_info/BKP/  2>/dev/null
cp -p /etc/sysconfig/sbd $DIR/Linux_info/BKP/  2>/dev/null

cp -p /etc/resolv.conf $DIR/Linux_info/BKP/  2>/dev/null
cp -p /etc/ntp.conf $DIR/Linux_info/BKP/  2>/dev/null
cp -p /etc/chrony.conf $DIR/Linux_info/BKP/  2>/dev/null
cp -p /etc/sysconfig/network $DIR/Linux_info/BKP/  2>/dev/null
cp -p /etc/fstab $DIR/Linux_info/BKP/  2>/dev/null
cp -p /etc/hosts $DIR/Linux_info/BKP/  2>/dev/null

cp -p /etc/lvm/lvm.conf $DIR/Linux_info/BKP/  2>/dev/null
cp -p /proc/mdstat $DIR/Linux_info/BKP/  2>/dev/null
cp -p /etc/multipath.conf $DIR/Linux_info/BKP/  2>/dev/null

cp -p /etc/security/limits.conf $DIR/Linux_info/BKP/  2>/dev/null
cp -p /etc/selinux/config $DIR/Linux_info/BKP/  2>/dev/null
cp -p /etc/sysctl.conf $DIR/Linux_info/BKP/  2>/dev/null

cp -p /etc/udev/rules.d/70-persistent-net.rules $DIR/Linux_info/BKP/  2>/dev/null
cp -p /boot/grup/grub.conf $DIR/Linux_info/BKP/  2>/dev/null
cp -p /etc/default/grub $DIR/Linux_info/BKP/  2>/dev/null

cp -p /etc/modprobe.conf $DIR/Linux_info/BKP/  2>/dev/null
cp -p /etc/modprobe.d/*.conf $DIR/Linux_info/BKP/  2>/dev/null
cp -p /etc/sysconfig/network-scripts/ifcfg-* $DIR/Linux_info/BKP/  2>/dev/null
cp -p $LOG $DIR/Linux_info/BKP/

iptables-save > $DIR/Linux_info/BKP/iptable-rules 2>/dev/null

tar -czf $DIR/Detail_`hostname`.tar.gz  $DIR/Linux_info/ 2>/dev/null

echo "Please share "$DIR/Detail_`hostname`.tar.gz" with Wipro, Thank you."


}


#Checkbegin Function

funchk()
{
cp /dev/null $CHKLOG.$1
cp /dev/null $CHKLOG.FS_USAGE.$1
cp /dev/null $CHKLOG.CPU.$1
cp /dev/null $CHKLOG.MEM.$1
cp /dev/null $CHKLOG.PATH.$1
cp /dev/null $CHKLOG.ADAPTER.$1
cp /dev/null $CHKLOG.MPATH.$1
#cp /dev/null $CHKLOG.ERR.$1
cp /dev/null $CHKLOG.ROUTE.$1
if [[ $1 =  'begin' ]] ; then
getinfo
fi
df -k|grep -iv 'cifs|nfs'  2>/dev/null > /tmp/.DF
lscpu >>/dev/null > /tmp/.cpu
cat /proc/meminfo 2>/dev/null > /tmp/.mem
CPU_C=`cat /tmp/.cpu |grep -i 'On-line CPU(s) list'|cut -d ':' -f22`
MEM=`cat /tmp/.mem | grep MemTotal | awk '{print $2}'`
echo "$CPU_C"  >> $CHKLOG.CPU.$1
echo "$MEM" >> $CHKLOG.MEM.$1
cat /tmp/.DF  | egrep -v "Filesystem|/mnt" | awk '{print $7}' | sort -u >> $CHKLOG.$1
cat /tmp/.DF  | egrep -v "Filesystem|/mnt" |grep "%"|sed 's/%//g'|awk '{print $4,$7}'>>$CHKLOG.FS_USAGE.$1
#lspath|sort -k2,3 >> $CHKLOG.PATH.$1
lspci >> $CHKLOG.ADAPTER.$1
netstat -rn|grep "^[0-9]"|awk '{print $1,$2,$6}' >> $CHKLOG.ROUTE.$1
}

#Overmount function
fun_over()
{
#---------------------------------------------------#
#Variables declaration to the overmount function
FILE=/tmp/.over_fs
DIFF1=/tmp/.over_fs_diff1
DIFF2=/tmp/.over_fs_diff2
TR_F=/tmp/.tr_out
F_FILE=fs
O_CNT=0
#---------------------------------------------------#

echo "~~~~~~~~~~~~~~~~~~~~"
df -hT|grep -iv 'cifs|nfs'   2>/dev/null > /tmp/.DF
cat /tmp/.DF  | grep -v Filesystem | awk '{print $7}' > $F_FILE
OVER=`cat $F_FILE | awk -F "/" '{$2 != "" } {print $2}' | sort | uniq -d `
for I_OUT in $(echo ${OVER})
do
 cat $F_FILE | grep -w $I_OUT > $FILE
 for TR_IN in `cat $FILE`
  do
   cp /dev/null /tmp/.fs_out
   echo "$TR_IN" > $TR_F
   TR_CNT=`tr -d -c "/" < $TR_F  | wc -m`
   c_awk=2
  while [ $TR_CNT -gt 0 ]
   do
     S_OUT=`cat $TR_F | awk -F "/" '{print $'$c_awk'}'`
     echo "/$S_OUT" >> /tmp/.fs_out
     TR_CNT=`expr $TR_CNT - 1`
     c_awk=`expr $c_awk + 1`
  done
    FF=`cat /tmp/.fs_out`
    echo $FF > /tmp/.fs_out
    W_V=`tr -d " " < /tmp/.fs_out `
    W_CNT=`cat /tmp/.fs_out | wc -l`
    if [ $W_CNT -gt 0 ] ; then
        W_CC=`cat $FILE | grep $W_V | wc -l`
      if [ $W_CC -gt 1 ] ; then
         cat $FILE | grep -w $W_V > $DIFF1
         cat  $DIFF1 | sort > $DIFF2
         F_cnt=`diff $DIFF1 $DIFF2 | grep "<" | wc -l`
         W_V1=`cat $DIFF1 | head -n 1`
         W_V2=`cat $DIFF2 | head -n 1`
       if [[ $F_cnt -gt 0 && $W_V1 != $W_V2 ]] ; then
        echo "> REPORT OF OVERMOUNT -> FAILED:" >> $REPORT
        echo "--------------------------------" >> $REPORT
        echo "!!! Please Check Overmount Issues As Listed Below !!!" >> $REPORT
        cat /tmp/.over_fs | grep -w "$W_V" >> $REPORT
        O_CNT=10
       fi
      fi
    fi
  done
done
if [ $O_CNT -eq 0 ] ; then
 echo -e "OVER MOUNT -> \033[32mPASSED\033[0m"
 echo "REPORT OF OVERMOUNT  -> PASSED" >> $REPORT;echo "" >> $REPORT
echo "~~~~~~~~~~~~~~~~~~~~"
else
 echo -e "OVER MOUNT -> \033[31mFAILED\033[0m"
 F_CHK=10;
echo "~~~~~~~~~~~~~~~~~~~~"
fi
}

compare_all()
{
REPORT=$DIR/Linux_info/INFO/report_`hostname`
cp /dev/null $REPORT
echo "Report collected on $DAY" >> $REPORT;echo "" >> $REPORT;

CNT=$(diff $CHKLOG.CPU.begin $CHKLOG.CPU.end | grep ">" | wc -l)

echo "~~~~~~~~~~~~~~~~~~~~"
if [ $CNT -gt 0 ] ; then

B_sys=`cat $CHKLOG.CPU.begin| awk '{print $1}'`;A_sys=`cat $CHKLOG.CPU.end | awk '{print $1}'`
echo "> REPORT OF CPU -> FAILED:" >> $REPORT
echo "--------------------------" >> $REPORT
echo "Before reboot CPU : $B_sys" >> $REPORT
echo "After reboot CPU  : $A_sys" >> $REPORT;echo "" >> $REPORT
echo -e "CPU        -> \033[31mFAILED\033[0m"
F_CHK=10;
else
echo "REPORT OF CPU        -> PASSED" >> $REPORT;echo "" >> $REPORT
echo -e "CPU        -> \033[32mPASSED\033[0m"
fi
CNT=$(diff $CHKLOG.MEM.begin $CHKLOG.MEM.end | grep ">" | wc -l)
echo "~~~~~~~~~~~~~~~~~~~~"
if [ $CNT -gt 0 ] ; then
B_sys=`cat $CHKLOG.MEM.begin`;A_sys=`cat $CHKLOG.MEM.end`
echo "> REPORT OF MEMORY -> FAILED:" >> $REPORT
echo "-----------------------------" >> $REPORT
echo "Before reboot Memory : $B_sys " >> $REPORT
echo "After reboot Memory  : $A_sys " >> $REPORT;echo "" >> $REPORT
echo -e "MEMORY     -> \033[31mFAILED\033[0m"
F_CHK=10;
else
echo "REPORT OF MEMORY     -> PASSED" >> $REPORT;echo "" >> $REPORT
echo -e "MEMORY     -> \033[32mPASSED\033[0m"
fi

#####Checking all path's all status#####

PCNT_A=$(sdiff $CHKLOG.PATH.begin $CHKLOG.PATH.end |grep ">"| wc -l)
PCNT_M=$(sdiff $CHKLOG.PATH.begin $CHKLOG.PATH.end |grep "<"| wc -l)
PCNT_C=$(sdiff $CHKLOG.PATH.begin $CHKLOG.PATH.end |grep "|"| wc -l)
F_PATH=0;C_REP=0

echo "~~~~~~~~~~~~~~~~~~~~"
#Checking missing path's
if [ $PCNT_M -gt 0 ]; then
 DIFF=$(sdiff $CHKLOG.PATH.begin $CHKLOG.PATH.end|grep "<"|awk -F'<' '{print $1}')
 echo "> REPORT OF DISK PATH's -> FAILED:" >> $REPORT
 echo "----------------------------------" >> $REPORT
 echo "!!! The following Path(s) has Vanished,Please check !!!" >> $REPORT
 echo "$DIFF" >> $REPORT
 F_PATH=10;C_REP=10
fi

#Chekcing for any paths has been added after reboot
if [ $PCNT_A -gt 0 ]; then
 DIFF=$(sdiff $CHKLOG.PATH.begin $CHKLOG.PATH.end|grep ">"|awk -F'>' '{print $2}'|awk '{print $1,$2,$3}')
 if [ $C_REP -ne 10 ] ; then
  echo "> REPORT OF DISK PATH's -> FAILED:" >> $REPORT
  echo "----------------------------------" >> $REPORT
 fi
 echo "!!! Below Additional Path(s) are Added,Please check !!!" >> $REPORT
 echo "$DIFF" >> $REPORT
 F_PATH=10;C_REP=10
fi

#Chekcing for path's changes
if [ $PCNT_C -gt 0 ]; then
 C_F=1
 if [ $C_REP -ne 10 ] ; then
  echo "> REPORT OF DISK PATH's -> FAILED:" >> $REPORT
  echo "----------------------------------" >> $REPORT
 fi
 echo "!!! The below Path(s) status has Changed,Please check !!!" >> $REPORT
 sdiff $CHKLOG.PATH.begin $CHKLOG.PATH.end |grep "|" > $CHKLOG.PATH.log
 while [ $PCNT_C -gt 0 ];
 do
  DIFF_B=$(cat $CHKLOG.PATH.log|awk -F'|' '{print $1}'|awk '{print $1,$2,$3}'|head -n $C_F|tail -1)
  DIFF_A=$(cat $CHKLOG.PATH.log|awk -F'|' '{print $2}'|awk '{print $1,$2,$3}'|head -n $C_F|tail -1)
  echo "{Before reboot}: $DIFF_B {After reboot}: $DIFF_A" >> $REPORT
  PCNT_C=`expr $PCNT_C - 1`;C_F=`expr $C_F + 1`
 done
 F_PATH=10
fi
if [ $F_PATH -eq 0 ] ; then
echo "REPORT OF DISK PATH  -> PASSED" >> $REPORT;echo "" >> $REPORT
echo -e "DISK PATH  -> \033[32mPASSED\033[0m"
else
echo -e "DISK PATH  -> \033[31mFAILED\033[0m";echo "" >> $REPORT
F_CHK=10;
fi

####Checking adapter(s) status#####

ACNT_A=$(sdiff $CHKLOG.ADAPTER.begin $CHKLOG.ADAPTER.end|grep ">"| wc -l)
ACNT_M=$(sdiff $CHKLOG.ADAPTER.begin $CHKLOG.ADAPTER.end|grep "<"| wc -l)
ACNT_C=$(sdiff $CHKLOG.ADAPTER.begin $CHKLOG.ADAPTER.end|grep "|"| wc -l)
F_A=0;C_REP=0

echo "~~~~~~~~~~~~~~~~~~~~"
#Checking missing adapters
if [ $ACNT_M -gt 0 ]; then
 DIFF=$(sdiff $CHKLOG.ADAPTER.begin $CHKLOG.ADAPTER.end|grep "<"|awk -F'<' '{print $1}')
 echo "> REPORT OF ADAPTERS -> FAILED:" >> $REPORT
 echo "-------------------------------" >> $REPORT
 echo "!!! The following Adapters has Vanished,Please check !!!" >> $REPORT
 echo "$DIFF" >> $REPORT
 F_A=10;C_REP=10
fi

#Chekcing for any Adapters has been added after reboot
if [ $ACNT_A -gt 0 ]; then
 DIFF=$(sdiff $CHKLOG.ADAPTER.begin $CHKLOG.ADAPTER.end|grep ">"|awk -F'>' '{print $2}')
 if [ $C_REP -ne 10 ] ; then
  echo "> REPORT OF ADAPTERS -> FAILED:" >> $REPORT
  echo "-------------------------------" >> $REPORT
 fi
 echo "!!! Below Additional Adapters are Added,Please check !!!" >> $REPORT
 echo "$DIFF" >> $REPORT
 F_A=10;C_REP=10
fi

#Chekcing for adapter changes status
if [ $ACNT_C -gt 0 ]; then
 C_F=1
 if [ $C_REP -ne 10 ] ; then
  echo "> REPORT OF ADAPTERS -> FAILED:" >> $REPORT
  echo "-------------------------------" >> $REPORT
 fi
 echo "!!! The below Adapters status has Changed,Please check !!!" >> $REPORT
 sdiff $CHKLOG.ADAPTER.begin $CHKLOG.ADAPTER.end|grep "|" > $CHKLOG.ADAPTER.log
 while [ $ACNT_C -gt 0 ];
 do
  DIFF_B=$(cat $CHKLOG.ADAPTER.log|awk -F'|' '{print $1}'|awk '{print $1,$2,$3}'|head -n $C_F|tail -1)
  DIFF_A=$(cat $CHKLOG.ADAPTER.log|awk -F'|' '{print $2}'|awk '{print $1,$2,$3}'|head -n $C_F|tail -1)
  echo "{Before reboot}: $DIFF_B {After reboot}: $DIFF_A" >> $REPORT
  ACNT_C=`expr $ACNT_C - 1`;C_F=`expr $C_F + 1`
 done
 F_A=10;C_REP=10
fi
if [ $F_A -eq 0 ] ; then
echo "REPORT OF ADAPTERS   -> PASSED" >> $REPORT;echo "" >> $REPORT
echo -e "ADAPTERS   -> \033[32mPASSED\033[0m"
else
echo -e "ADAPTERS   -> \033[31mFAILED\033[0m";echo "" >> $REPORT
F_CHK=10;
fi


echo "~~~~~~~~~~~~~~~~~~~~"
CNT_ERR=$(sdiff $CHKLOG.ERR.begin $CHKLOG.ERR.end|grep ">"| wc -l)
if [ $CNT_ERR -gt 0 ]; then
 DIFF=$(sdiff $CHKLOG.ERR.begin $CHKLOG.ERR.end|grep ">"|awk -F'>' '{print $2}')
 echo "> REPORT OF ERRPT(PH) -> FAILED:" >> $REPORT
 echo "--------------------------------" >> $REPORT
 echo "The below are recent errors(PH)in errpt,Please check!!!" >> $REPORT
 echo "$DIFF" >> $REPORT;echo "" >> $REPORT
 echo -e "ERRPT(PH)  -> \033[31mFAILED\033[0m"
 F_CHK=10;
else
echo "REPORT OF ERRPT(PH)  -> PASSED" >> $REPORT;echo "" >> $REPORT
 echo -e "ERRPT(PH)  -> \033[32mPASSED\033[0m"
fi

### Checking for routing tables
echo "~~~~~~~~~~~~~~~~~~~~"
RCNT_R=$(sdiff $CHKLOG.ROUTE.begin $CHKLOG.ROUTE.end|grep "<"| wc -l)
if [ $RCNT_R -gt 0 ] ; then
 DIFF=$(sdiff $CHKLOG.ROUTE.begin $CHKLOG.ROUTE.end|grep "<"|awk -F'<' '{print $1}')
 echo "> REPORT OF ROUTING  -> FAILED:" >> $REPORT
 echo "------------------------------" >> $REPORT
 echo "The below routes are Removed,Please check!!!" >> $REPORT
 echo "$DIFF" >> $REPORT;echo "" >> $REPORT
 echo -e "ROUTING    -> \033[31mFAILED\033[0m"
 F_CHK=10;
else
echo "REPORT OF ROUTING    -> PASSED" >> $REPORT;echo "" >> $REPORT
 echo -e "ROUTING    -> \033[32mPASSED\033[0m"
fi

}


#Chechend & compare Function

funcompare()
{
if [[ -s $CHKLOG.begin  && -s $CHKLOG.begin ]] ; then
funchk end
compare_all
sed '/^$/d' $CHKLOG.begin > /tmp/.remove_empty_line;cp /tmp/.remove_empty_line $CHKLOG.begin
sed '/^$/d' $CHKLOG.end > /tmp/.remove_empty_line;cp /tmp/.remove_empty_line $CHKLOG.end
DIFF=$(diff $CHKLOG.begin $CHKLOG.end | grep "<" | awk '{print $2}')
CNT=$(diff $CHKLOG.begin $CHKLOG.end | grep "<" | awk '{print $2}'| wc -l)
DIFF_1=$(diff $CHKLOG.FS_USAGE.begin $CHKLOG.FS_USAGE.end | grep "<" | awk '{print $2}')
CNT_1=$(diff $CHKLOG.FS_USAGE.begin $CHKLOG.FS_USAGE.end | grep "<" | awk '{print $2}'| wc -l)

echo "~~~~~~~~~~~~~~~~~~~~"
if [ $CNT -gt 0 ] ; then
 echo -e "FILESYSTEM -> \033[31mFAILED\033[0m"
 F_CHK=10;
 echo "> REPORT OF FILESYSTEM -> FAILED:" >> $REPORT
 echo "---------------------------------" >> $REPORT
 echo "$DIFF"  >> $REPORT;echo "" >> $REPORT
else
 echo "REPORT OF FILESYSTEM -> PASSED" >> $REPORT;echo "" >> $REPORT
 echo -e "FILESYSTEM -> \033[32mPASSED\033[0m"
fi
echo "~~~~~~~~~~~~~~~~~~~~"
if [ $CNT_1 -gt 0 ] ; then
 echo -e "FILESYSTEM SIZE-> \033[31mFAILED\033[0m"
 F_CHK=10;
 echo "> REPORT OF FILESYSTEM SIZE-> FAILED:" >> $REPORT
 echo "---------------------------------" >> $REPORT
 echo "$DIFF_1"  >> $REPORT;echo "" >> $REPORT
else
 echo "REPORT OF FILESYSTEM SIZE-> PASSED" >> $REPORT;echo "" >> $REPORT
 echo -e "FILESYSTEM SIZE-> \033[32mPASSED\033[0m"
fi
funchk end
fun_over
else
echo -e "\033[31mYou must run with precheck before to run with postcheck option \033[0m";
fi
if [ $F_CHK -eq 10 ] ; then
echo;echo -e "\033[1mPlease find more information about failures @ < $REPORT >\033[0m";
fi

}

boot_list()
{
echo
df -Th |grep 'boot'|awk '{print$1}'|while read PV
do
 B_LIST=`df -hT |grep $PV |wc -l`
 if [ $B_LIST -eq 0 ] ; then
  echo -e "\033[31mThe Bootlist Not set on DISK $PV,Please check\033[0m"
 fi
done
}

rootvg_chk()
{
#df -hT |grep -w /var$| while read RFS
df -Th |egrep -v  'tmpfs|devtmpfs' | awk '{print $7}' |grep -v Mounted | while read RFS
do
 FS_U=`df -k $RFS|egrep -v "Filesystem|/mnt"|awk '{print $5}'|tr -d '%'`
 if [ "$FS_U" == "100" ]; then
  echo -e "\033[31mThe Filesystem $RFS is Full[100%],Please Check Before Reboot\033[0m"
 fi
done
}


# MAIN PROGRAM BODY
if [ $# -eq 0 ] ; then
    echo -e "                      \033[31m The options are: precheck, postcheck \033[0m";echo
    exit
fi

ser_fun()
{
case $1 in
        precheck)
        echo " @************************************************************************************************@"
        echo "                  Script will gather server information for Server Migrationcon"
        echo " @************************************************************************************************@"
                funchk begin
#        echo -e "\033[1mCaptured the basic information of the server at </tmp/Linux_info/INFO/ser_info_`hostname`> \033[0m ";
#       echo -e "\033[1mYou can run script with compare option to verify about{FS,MEM,CPU, etc...}after your actions\033[0m ";
        boot_list;
        rootvg_chk;
                ;;
        checkend)
echo -e "\033[1mServer Checkend Completed \033[0m ";
                funchk end
                ;;
        postcheck)
        echo " @*******************************************************************************************************@"
        echo "       Script will compare the current config with the old server config taken before migration"
        echo "       Snapshots of Memory, CPU, Disk Paths, Adapters, Filesystems and errpt errors will be compared"
        echo "       Please refer the logfile under the path < /tmp/Linux_info/INFO/ > in case of any other issues"
        echo " @*******************************************************************************************************@"
echo;echo -e "\033[1mComparing {FS,MEM,CPU,etc...}\033[0m";
echo -e "\033[1m-----------------------------\033[0m";
                funcompare
                ;;
        *)
                echo -e "\033[31m The options are: precheck, postcheck \033[0m"
        ;;
esac
}

echo;
ser_fun $1

echo -e "\033[0m"

