
#get the name of the folder we're in
#which will be the executable name

DEV_NAME := "Bananicorn_Studios"
DEV_REAL_NAME := "Georg Ratschiller"
DEV_MAIL := "webmaster@bananicorn.com"
GAME_SITE := "http\:\/\/www.bananicorn.com\/games\/list"
CURR_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURR_DIR := $(notdir $(patsubst %/,%,$(dir $(CURR_PATH))))
APKTOOL := java -jar ../platform_dependencies/android/apktool_2.4.1.jar

$(CURR_DIR).love: src/*.lua src/**/*.lua src/external/*.lua src/base/*.lua assets/*.png credits.txt
	#change the window title to the title of the game
	sed -Ei s/t.window.title\ \=\ \".*\"/t.window.title\ =\ \"$(CURR_DIR)\"/ src/conf.lua
	mkdir -p src/assets
	cp assets/*.png src/assets/
	cp credits.txt src/
	cd src; zip -9 -r $(CURR_DIR).love *; mv *love ../
	rm -rf src/assets
	rm -rf src/credits.txt

lin: $(CURR_DIR).love
	mkdir -p lin
	cp $(CURR_DIR).love lin/

win: $(CURR_DIR).love
	mkdir -p win32/$(CURR_DIR)
	cat ../platform_dependencies/win32/love.exe $(CURR_DIR).love > ./win32/$(CURR_DIR)/$(CURR_DIR).exe
	cp ../platform_dependencies/win32/license.txt win32/$(CURR_DIR)/license.txt
	cp ../platform_dependencies/win32/*.dll win32/$(CURR_DIR)/

mac: $(CURR_DIR).love
	mkdir -p mac
	cp -r ../platform_dependencies/mac/love.app mac/$(CURR_DIR).app
	cp $(CURR_DIR).love ./mac/$(CURR_DIR).app/Contents/Resources/
	sed -i s/LÖVE/$(CURR_DIR)/ mac/$(CURR_DIR).app/Contents/Info.plist
	sed -i s/org.love2d.love-game/com.$(DEV_NAME).$(CURR_DIR)/ mac/$(CURR_DIR).app/Contents/Info.plist

android: $(CURR_DIR).love other/$(CURR_DIR).keystore
	mkdir -p android
	$(APKTOOL) d -sf -o android/love_decoded ../platform_dependencies/android/love-11.3-android-embed.apk
	mkdir -p android/love_decoded/assets
	cp $(CURR_DIR).love android/love_decoded/assets/game.love
	cp ../platform_dependencies/android/AndroidManifest.xml android/love_decoded/
	sed -i s/\{GamePackageName\}/com.$(CURR_DIR).$(CURR_DIR)/ android/love_decoded/AndroidManifest.xml
	sed -i s/\{GameVersionCode\}/1/ android/love_decoded/AndroidManifest.xml
	sed -i s/\{GameVersionSemantic}/1.0.0/ android/love_decoded/AndroidManifest.xml
	sed -i s/\{GameName}/$(CURR_DIR)/ android/love_decoded/AndroidManifest.xml
	#make a logo target, then require that before this step
	#cp assets/logos/love48x48.png android/love_decoded/res/drawable-mdpi/love.png
	#cp assets/logos/love72x72.png android/love_decoded/res/drawable-hdpi/love.png
	#cp assets/logos/love96x96.png android/love_decoded/res/drawable-xhdpi/love.png
	#cp assets/logos/love144x144.png android/love_decoded/res/drawable-xxhdpi/love.png
	#cp assets/logos/love192x192.png android/love_decoded/res/drawable-xxxhdpi/love.png
	$(APKTOOL) b -o $(CURR_DIR).apk android/love_decoded
	mv $(CURR_DIR).apk android/
	#To generate a keystore:
	#keytool -genkey -v -keystore template.keystore -alias alias_template -keyalg RSA -keysize 2048
	jarsigner -keystore other/$(CURR_DIR).keystore android/$(CURR_DIR).apk alias_$(CURR_DIR)
	#your_android-sdk_path/android-sdk/build-tools/your_build_tools_version/zipalign -v 4 android/$(CURR_DIR).apk android/$(CURR_DIR).apk

web: $(CURR_DIR).love
	npx love.js -ct $(CURR_DIR).love $(CURR_DIR).love web

other/$(CURR_DIR).keystore:
	cd other; keytool -genkey -v -keystore $(CURR_DIR).keystore -alias alias_$(CURR_DIR) -keyalg RSA -keysize 2048 -validity 10000

run: $(CURR_DIR).love
	love $(CURR_DIR).love

downloads: win lin mac android
	mkdir -p downloads
	cd win32; zip -9 -r ../downloads/$(CURR_DIR)-win32.zip ./
	cd mac; zip -9 -r ../downloads/$(CURR_DIR)-mac.zip ./
	cp android/$(CURR_DIR).apk downloads/
	cp $(CURR_DIR).love downloads/

clean:
	rm -rf ./mac ./win32 ./lin ./android *.love ./downloads

.PHONY: clean
