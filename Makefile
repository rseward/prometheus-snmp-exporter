build:
	podman build -t snmp_exporter .	

run:
	podman run --rm --publish=0.0.0.0:9116:9116 -ti -v "${PWD}:/opt/" snmp_exporter

push:	build
	./build-celeborn-regimg.sh

clean:
	rm -f build.out
	
