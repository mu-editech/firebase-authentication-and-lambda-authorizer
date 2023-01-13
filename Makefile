STAGE=dev
BINFILES=$(patsubst cmd/%/main.go,bin/%,$(wildcard cmd/*/main.go))

.PHONY: clean build deploy

clean:
	rm -rf ./bin

$(BINFILES): clean
$(BINFILES): bin/%: cmd/%/main.go
	export GO111MODULE=on
	env GOARCH=amd64 GOOS=linux go build -ldflags="-s -w" -o $@ $<

build: $(BINFILES)

deploy: clean build
	sls deploy --verbose --stage=${STAGE}