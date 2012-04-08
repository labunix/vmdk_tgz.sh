#!/bin/bash
export MYHOME="${HOME}"
export BAK="bak.vmware"

if [ -d ${MYHOME}/vmware ];then
  echo "OK: DIR = ${MYHOME}/vmware"
else
  echo "Error: Not Found DIR = ${MYHOME}/vmware"
fi
if [ -d ${MYHOME}/${BAK} ];then
  echo "OK: TGZ DIR = ${MYHOME}/${BAK}"
else
  echo "Error: TGZ DIR = ${MYHOME}/${BAK}"
fi

cd ${MYHOME}/
pwd
for list in vmware/*/;do
   EXCLUDE=`du -s ${list} | awk '{print $1}'`
   if [ ${EXCLUDE} -gt 4194304 ];then
     echo "4GB Over Skipping... $list"
   else   
     TARGET=`echo "$list" | sed s%"vmware"%"bak.&"% | sed s%"/\$"%"\.tar.gz"%`
     if [ -f ${TARGET} ];then
       TARGET_STAMP=`ls -l ${TARGET} | awk '{print $6}' | sed s/"-"//g`
       SOURCE_STAMP=`ls -ld ${list} | awk '{print $6}' | sed s/"-"//g`
       if [ ${TARGET_STAMP} -ge ${SOURCE_STAMP} ] ;then
         echo "${list} TARGET =  ${TARGET_STAMP} >= SOURCE = ${SOURCE_STAMP}"
       else
         echo "${list} SOURCE = ${SOURCE_STAMP} > TARGET = ${TARGET_STAMP}"
         for num in `seq 3 -1 0`;do
           PREV=`echo ${num} | awk '{print $1-1}'`
           if [ ${PREV} == "-1" ];then
             PREV=""
           else
             PREV=.${PREV}
           fi
           if [ -f ${HOME}/${TARGET}${PREV} ];then
             mv ${HOME}/${TARGET}${PREV} ${HOME}/${TARGET}.${num}
           fi
         done
       fi
     fi
     cd ${MYHOME}/vmware/
     pwd
     SOURCE=`echo ${list} | sed s%"vmware/"%%`
     test -f ../${TARGET} || tar zcvf ../${TARGET} ${SOURCE}
     cd ${MYHOME}
   fi
done

