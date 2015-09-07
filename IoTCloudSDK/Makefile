all:clean build archive doc

clean:
	rm -rf Documentation/docs
	rm -rf Documentation/IoTCloudSDK-Documentation*.zip
	rm -rf build
	rm -rf dist
	rm -rf test-reports

build:
	sh SDK-build.sh

archive: build
	sh SDK-archive.sh

doc:
	(cd Documentation; \
	python generateDocs.py)
