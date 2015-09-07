all:clean build archive doc

clean:
	rm -rf Documentation/docs
	rm -rf Documentation/IoTCloudSDK-Documentation*.zip
	rm -rf build
	rm -rf dist

build:
	sh SDK-build.sh

archive: build
	sh SDK-archive.sh

doc: build
	(cd Documentation; \
	python generateDocs.py -jazzy jazzy)
