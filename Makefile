all: clean build deploy

build:
	python iphone/build.py

deploy:
	unzip -o iphone/com.atticoos.titanium.chromecast-iphone-1.0.0.zip -d ~/Library/Application\ Support/Titanium/

clean:
	rm -rf iphone/build
