#include <stdio.h>

#include <pcp/pmapi.h>
#include <pcp/impl.h>
#include <pcp/import.h>

int main() {
	struct timeval tv;
	int i;

	pmiStart("mover_v1",0);
	pmiAddMetric("mover.nfile",PM_IN_NULL,PM_TYPE_U32,PM_INDOM_NULL,PM_SEM_INSTANT,pmiUnits(0,0,1,0,0,PM_COUNT_ONE));
	for(i=0;i<5;i++) {
		pmiPutValue("mover.nfile", "", "123");
		gettimeofday(&tv,NULL);
		pmiWrite(tv.tv_sec,tv.tv_usec);
		sleep(1);
	}
	pmiEnd();

	return(0);
}
