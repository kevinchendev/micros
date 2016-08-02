.SILENT :
.PHONY : main clean dist package

WITH_ENV = env `cat .env 2>/dev/null | xargs`
DATE := `date '+%Y%m%d'`

NAME:=gin
ROOF:=$(NAME)
TAG:=`git describe --tags --always`
LDFLAGS:=-X $(ROOF)/settings.buildVersion=$(TAG)-$(DATE)

main: vet
	echo "Building $(NAME)"
	go build -ldflags "$(LDFLAGS)"

deps:
	go get github.com/gin-gonic/gin
	go get github.com/golang/glog

vet:
	echo "Checking ."
	go tool vet -all .

clean:
	echo "Cleaning dist"
	rm -rf dist
	rm -f $(NAME)
	rm -f $(NAME)-*.tar.xz

dist:
	echo "Building $(NAME)"
	mkdir -p dist/linux_amd64 && GOOS=linux GOARCH=amd64 go build -ldflags "$(LDFLAGS)" -o dist/linux_amd64/$(NAME)

package:
	tar -cvJf $(NAME)-linux-amd64-$(TAG).tar.xz -C dist/linux_amd64 .