all:clean doc

.PHONY: clean build doc
clean:
		rm -rf Documentation/docs
		rm -rf Documentation/ThingIFSDK-Documentation*.zip
		rm -rf build
		rm -rf test-reports

build:
		xcodebuild -project ThingIFSDK.xcodeproj -target ThingIFSDK clean build

doc: build
		(cd Documentation; \
			python generateDocs.py)
